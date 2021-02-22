import macros, httpclient, asyncdispatch, sam, strutils, types, options, logging, strtabs, random
from json import escapeJson
from streams import Stream, readAll

randomize()

const
  API_URL* = "https://api.telegram.org/bot$#/"
  FILE_URL* = "https://api.telegram.org/file/bot$#/$#"

template END_POINT*(`method`: string) =
  let endpoint {.used, inject.} = API_URL & `method`

template hasCommand*(update: Update, username: string): bool =
  var
    result = false
    hasMessage = false
  when not declaredInScope(command):
    var
      command {.inject.} = ""
      params {.inject.} = ""
      message {.inject.}: Message
  if update.message.isSome:
    hasMessage = true
    message = update.message.get()
  elif update.editedMessage.isSome:
    hasMessage = true
    message = update.editedMessage.get()
  else:
    result = false

  if hasMessage and message.entities.isSome:
    let
      entities = message.entities.get()
      messageText = message.text.get()
    if entities[0].kind == "bot_command":
      let
        offset = entities[0].offset
        length = entities[0].length
      command = messageText[(offset + 1)..<(offset + length)].strip()
      params = messageText[(offset + length)..^1].strip()
      result = true
      if '@' in command:
        var parts = command.split('@')
        command = parts[0]
        if (parts.len == 2 and parts[1].toLowerAscii != username):
          result = false
  result

proc isSet*(value: any): bool {.inline.} =
  when value is string:
    result = value.len > 0
  elif value is int:
    result = value != 0
  elif value is bool:
    result = value
  elif value is object:
    result = true
  elif value is float:
    result = value != 0
  elif value is enum:
      result = true
  else:
    result = not value.isNil

template d*(args: varargs[string, `$`]) =
  debug(args)

proc formatName*(s: string): string =
  if s == "kind":
    return "type"
  if s == "fromUser":
    return "from"

  result = newStringOfCap(s.len + 5)
  for c in s:
    if c in {'A'..'Z'}:
      result.add("_")
      result.add(c.toLowerAscii)
    else:
      result.add(c)

proc unmarshal*(n: JsonNode, T: typedesc): T =
  when result is object:
    for name, value in result.fieldPairs:
      let jsonKey = formatName(name)
      when value.type is Option:
        if n.hasKey(jsonKey):
          toOption(value, n[jsonKey])
      elif value.type is TelegramObject:
        value = unmarshal(n[jsonKey], value.type)
      elif value.type is seq:
        for item in n[jsonKey]:
          put(value, item)
      elif value.type is string:
        value = n[jsonKey].toStr
      else:
        value = to[value.type](n[jsonKey])
  elif result is seq:
    for item in n:
      result.put(item)

proc marshal*[T](t: T, s: var string) =
  when t is Option:
    if t.isSome:
      marshal(t.get, s)
  elif t is object:
    s.add "{"
    for name, value in t.fieldPairs:
      const jsonKey = formatName(name)
      # DIRTY hack to make internal fields invisible
      if name != "type":
        when value is Option:
          if value.isSome:
            s.add("\"" & jsonKey & "\":")
            marshal(value, s)
            s.add(',')
        else:
          s.add("\"" & jsonKey & "\":")
          marshal(value, s)
          s.add(',')
    s.removeSuffix(',')
    s.add "}"
  elif t is ref:
    marshal(t[], s)
  elif t is seq or t is openarray:
    s.add "["
    for item in t:
      marshal(item, s)
      s.add(',')
    s.removeSuffix(',')
    s.add "]"
  else:
    if t.isSet:
      when t is string:
        s.add(escapeJson(t))
      else:
        s.add($t)
    else:
      when t is bool:
        s.add("false")
      else:
        s.add("null")

proc put*[T](s: var seq[T], n: JsonNode) {.inline.} =
  s.add(unmarshal(n, T))

proc unref*[T: TelegramObject](r: ref T, n: JsonNode ): ref T {.inline.} =
  new(result)
  result[] =  unmarshal(n, T)

  # DIRTY hack to unmarshal keyboard markups
  when result is InlineKeyboardMarkup:
    result.type = kInlineKeyboardMarkup
  elif result is ReplyKeyboardMarkup:
    result.type = kReplyKeyboardMarkup
  elif result is ReplyKeyboardRemove:
    result.type = kReplyKeyboardRemove
  elif result is ForceReply:
    result.type = kForceReply


proc toOption*[T](o: var Option[T], n: JsonNode) {.inline.} =
  when T is TelegramObject:
    o = some(unmarshal(n, T))
  elif T is int:
    o = some(n.toInt)
  elif T is string:
    o = some(n.toStr)
  elif T is bool:
    o = some(n.toBool)
  elif T is seq:
    var arr: T = @[]
    for item in n:
      arr.put(item)
    o = some(arr)
  elif T is ref:
    var res: T
    o = some(unref(res, n))

proc initHttpClient(b: Telebot): AsyncHttpClient =
  result = newAsyncHttpClient(userAgent="telebot.nim/0.5.7", proxy=b.proxy)

proc makeRequest*(b: Telebot, endpoint: string, data: MultipartData = nil): Future[JsonNode] {.async.} =
  d("Making request to ", endpoint)
  let client = initHttpClient(b)
  defer: client.close()
  let r = await client.post(endpoint, multipart=data)
  if r.code == Http200 or r.code == Http400:
    var obj = parse(await r.body)
    if obj["ok"].toBool:
      result = obj["result"]
      d("Result: ", $result)
    else:
      raise newException(IOError, obj["description"].toStr)
  else:
    raise newException(IOError, r.status)

proc getMessage*(n: JsonNode): Message {.inline.} =
  result = unmarshal(n, Message)

proc newProcDef(name: string): NimNode {.compileTime.} =
   result = newNimNode(nnkProcDef)
   result.add(postfix(ident(name), "*"))
   result.add(
     newEmptyNode(),
     newEmptyNode(),
     newNimNode(nnkFormalParams),
     newEmptyNode(),
     newEmptyNode(),
     newStmtList()
   )

proc addData*(p: var MultipartData, name: string, content: auto, fileCheck = false) {.inline.} =
  when content is string:
    if fileCheck and content.startsWith("file://"):
      p.addFiles({name: content[7..content.len-1]})
    else:
      p.add(name, content)
  else:
    p.add(name, $content)

proc addData*(p: var MultipartData, name: string, content: Stream, fileName = "", contentType = "") {.inline.} =
  p.add(name, content.readAll(), fileName, contentType)

proc uploadInputMedia*(p: var MultipartData, m: InputMedia) =
  var name = "file_upload_" & $rand(high(int))
  if m.media.startsWith("file://"):
    p.addFiles({name: m.media[7..<m.media.len]})
    m.media = "attach://" & name

  if m.thumb.isSome:
    let thumb = m.thumb.get()
    if thumb.startsWith("file://"):
      name = "file_upload_" & $rand(high(int))
      p.addFiles({name: thumb[7..<thumb.len]})
      m.thumb = some("attach://" & name)

macro genInputMedia*(mediaType: untyped): untyped =
  let
    media = "InputMedia" & $mediaType
    kind = toLowerAscii($mediaType)
    objName = newIdentNode(media)
    funcName = newIdentNode("new" & media)

  result = quote do:
    proc `funcName`*(media: string; caption=""; parseMode=""): `objName` =
      var inputMedia = new(`objName`)
      inputMedia.kind = `kind`
      inputMedia.media = media
      if caption.len > 0:
        inputMedia.caption = some(caption)
      if parseMode.len > 0:
        inputMedia.parseMode = some(parseMode)
      return inputMedia

macro magic*(head, body: untyped): untyped =
  result = newStmtList()

  var
    objNameNode: NimNode

  if head.kind == nnkIdent:
    objNameNode = head
  else:
    quit "Invalid node: " & head.lispRepr

  var
    objectTy = newNimNode(nnkObjectTy)

  objectTy.add(newEmptyNode(), newEmptyNode())

  var
    objName = $objNameNode & "Object"
    objParamList = newNimNode(nnkRecList)
    objInitProc = newProcDef("new" & $objNameNode)
    objSendProc = newProcDef("send")
    objInitProcParams = objInitProc[3]
    objInitProcBody = objInitProc[6]
    objSendProcParams = objSendProc[3]
    objSendProcBody = objSendProc[6]

  objSendProc[4] = newNimNode(nnkPragma).add(ident("async"), ident("discardable"), ident("deprecated"))

  objectTy.add(objParamList)
  objInitProcParams.add(ident(objName))

  objSendProcParams.add(newNimNode(nnkBracketExpr).add(
    ident("Future"), ident("Message")) # return value
  ).add(newIdentDefs(ident("b"), ident("TeleBot"))
  ).add(newIdentDefs(ident("m"), ident(objName)))

  objSendProcBody.add(newConstStmt(
    ident("endpoint"),
    infix(ident("API_URL"), "&", newStrLitNode("send" & $objNameNode))
  )).add(newVarStmt(
      ident("data"),
      newCall(ident("newMultipartData"))
  ))

  for node in body:
    let fieldName = $node[0]

    case node[1][0].kind
    of nnkIdent:
      var identDefs = newIdentDefs(
        node[0],
        node[1][0] # objInitProcBody -> Ident
      )
      objParamList.add(identDefs)
      objInitProcParams.add(identDefs)
      objInitProcBody.add(newAssignment(
        newDotExpr(ident("result"), node[0]),
        node[0]
      ))

      # dirty hack to determine if the field might be `InputFile`
      # if  field is InputFile or string, `addData` will checks if it starts w/ file://
      # and do file upload
      var fileCheck = ident("false")
      if toLowerAscii(fieldName) == toLowerAscii($objNameNode):
        fileCheck = ident("true")


      objSendProcBody.add(
        newCall(
          ident("addData"),
          ident("data"),
          newStrLitNode(formatName(fieldName)),
          newDotExpr(ident("m"), node[0]),
          fileCheck
      ))

    of nnkPragmaExpr:
      objParamList.add(
        newIdentDefs(
          postfix(node[0], "*"),
          node[1][0][0] # stmtList -> pragma -> ident
        )
      )

      var ifStmt = newNimNode(nnkIfStmt).add(
        newNimNode(nnkElifBranch).add(
          newCall(
            ident("isSet"),
            newDotExpr(ident("m"), node[0])
          ),
          newStmtList(
            newCall(
              ident("addData"),
              ident("data"),
              newStrLitNode(formatName(fieldName)),
              newDotExpr(ident("m"), node[0])
            )
          )
        )
      )
      objSendProcBody.add(ifStmt)
    else:
      # silently ignore unsupported node
      discard

  var epilogue = parseStmt("""
try:
  let res = await makeRequest(b, endpoint % b.token, data)
  result = unmarshal(res, Message)
except:
  echo "Got exception ", repr(getCurrentException()), " with message: ", getCurrentExceptionMsg()
""")
  objSendProcBody.add(epilogue[0])

  result.add(newNimNode(nnkTypeSection).add(
    newNimNode(nnkTypeDef).add(postfix(ident(objName), "*"), newEmptyNode(), objectTy)
  ))
  result.add(objInitProc, objSendProc)

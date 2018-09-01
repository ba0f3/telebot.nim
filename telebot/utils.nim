import macros, httpclient, asyncdispatch, json, strutils, types, options, logging, strtabs, random

randomize()

const
  API_URL* = "https://api.telegram.org/bot$#/"
  FILE_URL* = "https://api.telegram.org/file/bot$#/$#"

macro END_POINT*(s: string): typed =
  result = parseStmt("const endpoint = \"" & API_URL & s.strVal & "\"")

proc hasCommand*(update: Update): bool =
  result = false
  if update.message.isSome:
    var message = update.message.get()
    if message.entities.isSome:
      var entities = message.entities.get()
      for entity in entities:
        if entity.kind == "bot_command":
          return true

proc getCommands*(update: Update): StringTableRef =
  result = newStringTable(modeCaseInsensitive)
  if update.message.isSome:
    var message = update.message.get()
    if message.entities.isSome:
      var entities = message.entities.get()
      for entity in entities:
        if entity.kind == "bot_command":
          var 
            messageText = message.text.get()
            offset = entity.offset
            length = entity.length
            command = message_text[(offset + 1)..<(offset + length)].strip()

          if '@' in command:
            command = command.split('@')[0]

          var param = message_text[(offset + length)..^1]
          param = param.split(Whitespace, 0).join().strip()
          result[command] = param

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
  else:
    result = not value.isNil

template d*(args: varargs[string, `$`]) =
  debug(args)

proc makeRequest*(endpoint: string, data: MultipartData = nil): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  d("Making request to ", endpoint)
  let r = await client.post(endpoint, multipart=data)
  if r.code == Http200 or r.code == Http400:
    var obj = parseJson(await r.body)
    if obj["ok"].bval == true:
      result = obj["result"]
      d("Result: ", pretty(result))
    else:
      raise newException(IOError, obj["description"].getStr(r.status))
  else:
    raise newException(IOError, r.status)
  client.close()

proc formatName(s: string): string {.compileTime.} =
  if s == "kind":
    return "type"
  if s == "fromUser":
    return "from"

  result = ""
  for c in s:
    if c.isUpperAscii():
      result.add("_")
      result.add(c.toLowerAscii)
    else:
      result.add(c)

proc unmarshal*(n: JsonNode, T: typedesc): T {.inline.} =
  when result is object:
    for name, value in result.fieldPairs:
      when value.type is Option:
        if n.hasKey(formatName(name)):
          toOption(value, n[formatName(name)])
      elif value.type is TelegramObject:
        value = unmarshal(n[formatName(name)], value.type)
      elif value.type is seq:
        value = @[]
        for item in n[formatName(name)].items:
          put(value, item)
      else:
        value = to(n[formatName(name)], value.type)
  elif result is seq:
    result = @[]
    for item in n.items:
      result.put(item)

proc marshal*[T](t: T, s: var string) =
  when t is Option:
    if t.isNone:
      s.add "null"
    else:
      marshal(t.get, s)
  elif t is object:
    s.add "{"
    for name, value in t.fieldPairs:
      when value is Option:
        if value.isSome:
          s.add("\"" & formatName(name) & "\":")
          marshal(value, s)
          s.add(',')
      else:
        s.add("\"" & formatName(name) & "\":")
        marshal(value, s)
        s.add(',')
    s.removeSuffix(',')
    s.add "}"
  #elif t is ref:
  #  marshal(t[], s)
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
        s.add(escape(t))
      else:
        s.add($t)
    else:
      s.add("null")

proc put*[T](s: var seq[T], n: JsonNode) {.inline.} =
  s.add(unmarshal(n, T))

proc unref*[T: TelegramObject](r: ref T, n: JsonNode ): ref T {.inline.} =
  new(result)
  result[] =  unmarshal(n, T)

proc toOption*[T](o: var Option[T], n: JsonNode) {.inline.} =
  when T is TelegramObject:
    o = some(unmarshal(n, T))
  elif T is int:
    o = some(n.num.int)
  elif T is string:
    o = some(n.str)
  elif T is bool:
    o = some(n.bval)
  elif T is seq:
    var arr: T = @[]
    for item in n.items:
      arr.put(item)
    o = some(arr)
  elif T is ref:
    var res: T
    o = some(unref(res, n))

proc getMessage*(n: JsonNode): Message {.inline.} =
  result = unmarshal(n, Message)


proc `%`*[T](o: Option[T]): JsonNode {.inline.} =
  if o.isSome:
    result = %o.get
  else:
    result = newJNull()

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
      p.add(name, $content)
  else:
    p.add(name, $content)

proc uploadInputMedia*(p: var MultipartData, m: InputMedia) =
  var name = "file_upload_" & $rand(high(int))
  if m.media.startsWith("file://"):
    m.media = "attach://" & name
    p.addFiles({name: m.media[7..m.media.len-1]})

  if m.thumb.isSome:
    name = "file_upload_" & $rand(high(int))
    m.thumb = some("attach://" & name)
    p.addFiles({name: m.media[7..m.media.len-1]})




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

  objSendProc[4] = newNimNode(nnkPragma).add(ident("async"), ident("discardable"))

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

  for node in body.items:
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
  let res = await makeRequest(endpoint % b.token, data)
  result = unmarshal(res, Message)
except:
  echo "Got exception ", repr(getCurrentException()), " with message: ", getCurrentExceptionMsg()
""")
  objSendProcBody.add(epilogue[0])

  result.add(newNimNode(nnkTypeSection).add(
    newNimNode(nnkTypeDef).add(postfix(ident(objName), "*"), newEmptyNode(), objectTy)
  ))
  result.add(objInitProc, objSendProc)

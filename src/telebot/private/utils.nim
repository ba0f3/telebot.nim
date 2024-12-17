import macros, httpclient, asyncdispatch, json, strutils, types, logging, strtabs, random
from streams import Stream, readAll
from parseutils import parseUntil

randomize()

const
  API_URL = "$#/bot$#/$#"
  #FILE_PATH = "file/bot$#/$#"

template PROC_NAME*: string =
  when not declaredInScope(internalProcName):
    var internalProcName {.exportc, inject.}: cstring
    {.emit: "`internalProcName` = __func__;".}
    var realProcName {.inject.}: string
    const newAsyncSuffix = "X20X28AsyncX29" # " (Async)" in ASCII
    let suffix = if newAsyncSuffix in $internalProcName: newAsyncSuffix else: "Iter_"
    discard parseUntil($internalProcName, realProcName, suffix)
  realProcName

template hasCommand*(update: Update, username: string): bool =
  var
    result = false
    hasMessage = false
  when not declaredInScope(command):
    var
      command {.inject.} = ""
      params {.inject.} = ""
      message {.inject.}: Message
  if update.message != nil:
    hasMessage = true
    message = update.message
  elif update.editedMessage != nil:
    hasMessage = true
    message = update.editedMessage
  else:
    result = false

  if hasMessage and message.entities.len > 0:
    let
      entities = message.entities
      messageText = message.text
    if entities[0].kind == "bot_command" and entities[0].offset == 0:
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

proc isSet*(value: auto): bool {.inline.} =
  when value is string: value.len > 0
  elif value is int: value != 0
  elif value is int64: value != 0
  elif value is bool: value
  elif value.type is seq: value.len > 0
  elif value is object: true
  elif value is float: value != 0.0
  elif value is enum: true
  else: value != nil


template d*(args: varargs[string, `$`]) = debug(args)

proc formatName*(s: string): string {.compileTime.} =
  if s == "kind":
    return "type"
  if s == "fromUser":
    return "from"
  # optimize: dont alloc new string if not needed
  var hasUpperChar = false
  for i in 0..<s.len:
    if s[i].isUpperAscii:
      hasUpperChar = true
      break
  if not hasUpperChar:
    return s
  result = newStringOfCap(s.len)
  for c in s:
    case c
    of 'A'..'Z':
      result.add('_')
      result.add(toLowerAscii c)
    else: result.add(c)

proc put*[T](s: var seq[T], n: JsonNode) {.inline.}

proc unmarshal*(n: JsonNode, T: typedesc): T {.gcsafe.} =
  when T is TelegramObject:
    for name, value in result.fieldPairs:
      when not value.hasCustomPragma(telebotInternalUse):
        let jsonKey = static(formatName(name))
        if n.hasKey(jsonKey):
          value = unmarshal(n[jsonKey], value.type)
  elif result is ref:
    if n.kind != JNull:
      new(result)
      result[] = unmarshal(n, result[].type)
  elif result is array or result is seq:
    when result is seq:
      newSeq(result, n.len)
    for i in 0..<n.len:
      result[i] = unmarshal(n[i], result[0].type)
  elif result is SomeInteger:
    result = type(result)(n.getBiggestInt)
  elif result is SomeFloat:
    result = n.getFloat
  elif result is string:
    result = n.getStr
  elif result is bool:
    result = n.getBool
  elif result is char:
    result = n.getStr()[0]
  elif result is enum:
    let value = n.getStr
    for e in low(result.type)..high(result.type):
      if $e == value:
        result = e

proc marshal*[T](t: T, s: var string) {.inline.} =
  when t is TelegramObject:
    s.add "{"
    for name, value in t.fieldPairs:
      when not value.hasCustomPragma(telebotInternalUse):
        let jsonKey = static(formatName(name))
        if value.isSet:
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
  elif t is enum:
    s.add "\""
    s.add($t)
    s.add "\""
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

proc postWithTimeout(client: AsyncHttpClient, endpoint: string, data: MultipartData, timeoutMs: int): Future[AsyncResponse] =
  result = newFuture[AsyncResponse]()
  let res = result
  let freq = client.post(endpoint, multipart=data)
  freq.addCallback() do():
    if not res.finished:
      if freq.failed:
        res.fail(freq.error)
      else:
        res.complete(freq.read())

  if timeoutMs >= 0:
    sleepAsync(timeoutMs).addCallback() do():
      if not res.finished:
        res.fail(newException(IOError, "HTTP response timeout exceeded"))

proc makeRequest*(b: Telebot, `method`: string, data: MultipartData = nil, timeoutMs = -1): Future[JsonNode] {.async.} =
  when defined(telebotTestMode):
    let endpoint = API_URL % [b.serverUrl, b.token, "test/" & `method`]
  else:
    let endpoint = API_URL % [b.serverUrl, b.token, `method`]
  d("Making request to ", endpoint)
  when defined(TELEBOT_DEBUG):
    if data != nil:
      echo $data
  let client = newAsyncHttpClient(userAgent="telebot.nim/2023.02 Nim/" & NimVersion, proxy=b.proxy)
  defer: client.close()
  let r = await client.postWithTimeout(endpoint, data, timeoutMs)
  if r.code == Http200 or r.code == Http400:
    let body = await r.body
    var obj: JsonNode
    obj = parseJson(body)
    if obj.hasKey("ok") and obj["ok"].getBool:
      result = obj["result"]
      d("Result: ", $result)
    else:
      raise newException(IOError, obj["description"].getStr)
  else:
    raise newException(IOError, r.status)

proc uploadInputMedia*(p: var MultipartData, m: InputMedia)

proc `$`*[T](k: ref T): string {.inline.} = marshal(k, result)

proc addData*(p: var MultipartData, name: string, content: auto) {.inline.} =
  when content is InputFileOrString:
    if content.startsWith("file://"):
      p.addFiles({name: content[7..content.len-1]})
    else:
      p.add(name, content)
  elif content is KeyboardMarkup:
    p.add(name, $content)
  elif content is ref:
    when content is InputMediaSet:
      p.uploadInputMedia(content)
    var value = ""
    marshal(content, value)
    p.add(name, value)
  elif content is object or content is seq:
    when content is seq:
      when content[0].type is InputMediaSet:
        for m in content:
          p.uploadInputMedia(m)

    var value = ""
    marshal(content, value)
    p.add(name, value)
  else:
    p.add(name, $content)

proc addData*(p: var MultipartData, name: string, content: Stream, fileName = "", contentType = "") {.inline.} =
  p.add(name, content.readAll(), fileName, contentType)

proc uploadInputMedia*(p: var MultipartData, m: InputMedia) =
  var name = "file_upload_" & $rand(high(int))
  if m.media.startsWith("file://"):
    p.addFiles({name: m.media[7..<m.media.len]})
    m.media = "attach://" & name

  if m.thumbnail.len > 0:
    if m.thumbnail.startsWith("file://"):
      name = "file_upload_" & $rand(high(int))
      p.addFiles({name: m.thumbnail[7..<m.thumbnail.len]})
      m.thumbnail = "attach://" & name

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
        inputMedia.caption = caption
      if parseMode.len > 0:
        inputMedia.parseMode = parseMode
      return inputMedia

proc addRequiredParam(stmtList, paramName, paramType: NimNode) =
  let jsonName = newStrLitNode(formatName($paramName))
  stmtList.add(nnkCall.newTree(
      nnkDotExpr.newTree(
        ident("data"),
        ident("addData")
      ),
      jsonName,
      paramName
    )
  )

proc addOptionalParam(stmtList, paramName, paramType: NimNode) =
  let jsonName = newStrLitNode(formatName($paramName))
  stmtList.add(nnkIfStmt.newTree(
    nnkElifBranch.newTree(
      nnkDotExpr.newTree(
        paramName,
        ident("isSet")
      ),
      nnkStmtList.newTree(
        nnkCall.newTree(
          nnkDotExpr.newTree(
            ident("data"),
            ident("addData")
          ),
          jsonName,
          paramName
        )
      ))
    ))

macro api*(body: untyped) : untyped =
  if body.kind != nnkProcDef:
    return

  var
    procName: NimNode
    formalParams = body[3]
    returnType = formalParams[0][1]
    procBody = newStmtList()

  body[6] = procBody

  if body[0].kind == nnkIdent:
    procName = body[0]
  else:
    procName = body[0][1]

  if formalParams.len > 2:
    procBody.add(nnkVarSection.newTree(
      nnkIdentDefs.newTree(
        newIdentNode("data"),
        newEmptyNode(),
        nnkCall.newTree(newIdentNode("newMultipartData"))
      )
    ))

    for i in 2..<formalParams.len:
      let param = formalParams[i]

      if param.len == 3:
        # single param
        let
          paramName = param[0]
          paramType = param[1]
          defaultValue = param[2]

        if defaultValue.kind == nnkEmpty:
          # required params
          procBody.addRequiredParam(paramName, paramType)
        #elif paramType.kind == nnkEmpty:
        else:
          procBody.addOptionalParam(paramName, paramType)
      elif param.len > 3:
        # multiple params
        let
          paramType = param[param.len - 2]
          defaultValue = param[param.len - 1]

        for j in 0..<(param.len - 2):
          if defaultValue.kind == nnkEmpty:
            # last node is empty, this is a required param
            procBody.addRequiredParam(param[j], paramType)
          else:
            procBody.addOptionalParam(param[j], paramType)

    procBody.add(nnkLetSection.newTree(
      nnkIdentDefs.newTree(
        newIdentNode("res"),
        newEmptyNode(),
        nnkCommand.newTree(
          newIdentNode("await"),
          nnkCall.newTree(newIdentNode("makeRequest"), newIdentNode("b"), newStrLitNode($procName), newIdentNode("data"))
        )
      )
    ))
  else:
    procBody.add(nnkLetSection.newTree(
      nnkIdentDefs.newTree(
        newIdentNode("res"),
        newEmptyNode(),
        nnkCommand.newTree(
          newIdentNode("await"),
          nnkCall.newTree(newIdentNode("makeRequest"), newIdentNode("b"), newStrLitNode($procName))
        )
      )
    ))

  if returnType.kind == nnkBracketExpr and $returnType[0] == "Option":
    let retObj = returnType[1]
    procBody.add quote do:
      if res.kind == JBool:
        result = none(`retObj`)
      else:
        result = unmarshal(res, `returnType`)

  else:
    procBody.add(nnkAsgn.newTree(
      newIdentNode("result"),
      nnkCall.newTree(newIdentNode("unmarshal"), newIdentNode("res"), returnType)
    ))

  #echo treeRepr body
  #echo repr body
  #echo astGenRepr(body)
  result = body


when isMainModule:
  proc sendMessage*(b: TeleBot, chatId: ChatId, text: string, messageThreadId = 0, parseMode = "", entities: seq[MessageEntity] = @[],
                  disableWebPagePreview = false, disableNotification = false, protectContent = false, replyToMessageId = 0,
                  allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Option[Message]] {.api, async.}


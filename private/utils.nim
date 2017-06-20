
import macros, httpclient, asyncdispatch, json, strutils, types

const
  API_URL* = "https://api.telegram.org/bot$#/"
  FILE_URL* = "https://api.telegram.org/file/bot$#/$#"

macro END_POINT*(s: string): typed =
  result = parseStmt("const endpoint = \"" & API_URL & s.strVal & "\"")

proc makeRequest*(endpoint: string, data: MultipartData = nil): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  let r = await client.post(endpoint, multipart=data)
  if r.code == Http200:
    var obj = parseJson(await r.body)
    if obj["ok"].bval == true:
      result = obj["result"]
  else:
    raise newException(IOError, r.status)
  client.close()

proc camelCaseToUnderscore*(s: string): string {.compileTime.} =
  result = ""
  for c in s:
    if c.isUpper():
      result.add("_")
      result.add(c.toLower())
    else:
      result.add(c)

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

proc isSet*(value: any): bool {.inline.} =
  when value is string:
    result = not value.isNilOrEmpty
  elif value is int:
    result = value != 0
  elif value is bool:
    result = value
  else:
    result = not value.isNil

macro magic*(head, body: untyped): untyped =
  result = newStmtList()

  var
    tname: NimNode

  if head.kind == nnkIdent:
    tname = head
  else:
    quit "Invalid node: " & head.lispRepr

  var
    objectTy = newNimNode(nnkObjectTy)

  objectTy.add(newEmptyNode(), newEmptyNode())

  var
    realname = $tname & "Config"
    recList = newNimNode(nnkRecList)
    constructor = newProcDef("new" & $tname)
    sender = newProcDef("send")
    cParams = constructor[3]
    cStmtList = constructor[6]
    sParams = sender[3]
    sStmtList = sender[6]

  sender[4] = newNimNode(nnkPragma).add(ident("async"))

  objectTy.add(recList)
  cParams.add(ident(realname))

  sParams.add(newNimNode(nnkBracketExpr).add(
    ident("Future"), ident("Message"))
  ).add(newIdentDefs(ident("b"), ident("TeleBot"))
  ).add(newIdentDefs(ident("m"), ident(realname)))

  let apiMethod = "send" & $tname

  sStmtList.add(newConstStmt(
    ident("endpoint"),
    infix(ident("API_URL"), "&", newStrLitNode(apiMethod))
  )).add(newVarStmt(
      ident("data"),
      newCall(ident("newMultipartData"))
  ))

  for node in body.items:
    let fname = $node[0]
    case node[1][0].kind
    of nnkIdent:
      var identDefs = newIdentDefs(
        node[0],
        node[1][0] # cStmtList -> Ident
      )
      recList.add(identDefs)
      cParams.add(identDefs)
      cStmtList.add(newAssignment(
        newDotExpr(ident("result"), node[0]),
        node[0]
      ))

      sStmtList.add(newAssignment(
        newNimNode(nnkBracketExpr).add(
          ident("data"),
          newStrLitNode(camelCaseToUnderscore(fname))
        ),
        prefix(newDotExpr(ident("m"), node[0]), "$")
      ))

    of nnkPragmaExpr:
      recList.add(
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
              ident("add"),
              ident("data"),
              newStrLitNode(camelCaseToUnderscore(fname)),
              prefix(newDotExpr(ident("m"), node[0]), "$")
            )
          )
        )
      )
      sStmtList.add(ifStmt)
    else:
      raise newException(ValueError, "Unsupported node: " & node[1][0].lispRepr)


  var epilogue = parseStmt("""
try:
  let res = await makeRequest(endpoint % b.token, data)
  result = res.getMessage()
except:
  echo "Got exception ", repr(getCurrentException()), " with message: ", getCurrentExceptionMsg()
""")
  sStmtList.add(epilogue[0])

  result.add(newNimNode(nnkTypeSection).add(
    newNimNode(nnkTypeDef).add(postfix(ident($tname & "Config"), "*"), newEmptyNode(), objectTy)
  ))
  result.add(constructor, sender)

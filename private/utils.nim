import macros, httpclient, asyncdispatch, json, strutils

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

proc camelCaseToUnderscore*(s: string): string =
  for c in s:
    if c.isUpper():
      result.add("_")
      result.add(c.toLower())
    else:
      result.add(c)


macro magic*(head, body: untyped): untyped =
  result = newStmtList()

  var typeName: NimNode

  if head.kind == nnkIdent:
    typeName = head
  else:
    quit "Invalid node: " & head.lispRepr
  echo $typeName

  var
    objectTy = newNimNode(nnkObjectTy)

  objectTy.add(newEmptyNode(), newEmptyNode())
  
  result.add(newNimNode(nnkTypeSection).add(
    newNimNode(nnkTypeDef).add(postfix(typeName, "*"), newEmptyNode(), objectTy)
  ))
  var recList = newNimNode(nnkRecList)
  objectTy.add(recList)

  var procDef = newNimNode(nnkProcDef)
  result.add(procDef)
  procDef.add(
    postfix(newIdentNode("new" & $typeName), "*")
  )
  procDef.add(
    newEmptyNode(),
    newEmptyNode(),
    newNimNode(nnkFormalParams),
    newEmptyNode(),
    newEmptyNode(),
    newStmtList()
  )
  let
    params = procDef[3]
    stmts = procDef[6]

  params.add(typeName)


  var requiredFields, optionalFields: seq[string] = @[]

  for node in body.items:
    let fname = $node[0]
    case node[1][0].kind 
    of nnkIdent:
      requiredFields.add(fname)
      var identDefs = newIdentDefs(
        node[0],
        node[1][0] # stmtList -> Ident
      )
      recList.add(identDefs)
      params.add(identDefs)
      stmts.add(newAssignment(
        newDotExpr(newIdentNode("result"), node[0]),
        node[0]
      ))

    of nnkPragmaExpr:
      optionalFields.add(fname)
      recList.add(
        newIdentDefs(
          postfix(node[0], "*"),
          node[1][0][0] # stmtList -> pragma -> ident
        )
      )
    else:
      raise newException(ValueError, "Unsupported node: " & $node[1][0].lispRepr)

  echo treeRepr(result)



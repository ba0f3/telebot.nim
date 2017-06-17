import macros, httpclient, asyncdispatch, json, strutils

const
  API_URL* = "https://api.telegram.org/bot$#/"
  FILE_URL* = "https://api.telegram.org/file/bot$#/$#"

macro END_POINT*(s: string): typed =
  result = parseStmt("const endpoint = \"" & API_URL & s.strVal & "\"")


proc makeRequest*(endpoint: string, data: MultipartData = nil): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  let r = await client.post(endpoint, multipart=data)
  if r.status.startsWith("200"):
    var obj = parseJson(await r.body)
    if obj["ok"].bval == true:
      result = obj["result"]
  else:
    raise newException(IOError, r.status)
  client.close()

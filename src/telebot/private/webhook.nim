import asyncdispatch, asynchttpserver, httpclient, strutils, json, options
import utils, types, api

type
  WebhookInfo* = object
    url*: string
    hasCustomCertificate*: bool
    pendingUpdateCount*: int
    ipAddress*: string
    lastErrorDate*: int
    lastErrorMessage*: string
    lastSynchronizationErrorDate*: int
    maxConnections*: int
    allowedUpdates*: seq[string]

proc getWebhookInfo(n: JsonNode): WebhookInfo =
  result.url = $n["url"]
  result.hasCustomCertificate = n["has_custom_certificate"].getBool
  result.pendingUpdateCount = n["pending_update_count"].getInt
  if n.hasKey("ip_address"):
    result.ipAddress = $n["ip_address"]
  if n.hasKey("last_error_date"):
    result.lastErrorDate = n["last_error_date"].getInt
  if n.hasKey("last_error_message"):
    result.lastErrorMessage = $n["last_error_message"]
  if n.hasKey("max_connections"):
    result.maxConnections = n["max_connections"].getInt
  else:
    result.maxConnections = 40
  if n.hasKey("allowed_updates"):
    result.allowedUpdates = @[]
    for i in n["allowed_udpates"]:
      result.allowedUpdates.add($i)

proc setWebhook*(b: TeleBot, url: string, certificate = "", ipAddress = "", maxConnections = -1, allowedUpdates: seq[string] = @[], dropPendingUpdates = false, secretToken = "") {.async.} =
  var data = newMultipartData()
  data["url"] = url
  if certificate.len > 0:
    data.addData("certificate", certificate, true)
  if ipAddress.len > 0:
    data.addData("ip_address", ipAddress, true)
  if maxConnections > 0 and maxConnections != 40:
    data["max_connections"] = $maxConnections
  if allowedUpdates.len > 0:
    data["allowed_updates"] = $allowedUpdates
  if dropPendingUpdates:
    data["drop_pending_updates"] = "true"
  if secretToken.len > 0:
    data["secret_token"] = secretToken

  discard await makeRequest(b, PROC_NAME, data)

proc deleteWebhook*(b: TeleBot, dropPendingUpdates = false): Future[bool] {.async.} =
  var data = newMultipartData()
  if dropPendingUpdates:
    data["drop_pending_updates"] = "true"
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc getWebhookInfo*(b: TeleBot): Future[WebhookInfo] {.async.} =
  let res = await makeRequest(b, PROC_NAME)
  result = getWebhookInfo(res)


proc startWebhook*(b: Telebot, secret, url: string, port=Port(8080), dropPendingUpdates = false) =
  try:
    let me = waitFor b.getMe()
    b.id = me.id
    if me.username.isSome:
      b.username = me.username.get().toLowerAscii()
  except IOError, OSError:
    d("Unable to fetch my info ", getCurrentExceptionMsg())

  waitFor b.setWebhook(url, dropPendingUpdates = dropPendingUpdates)

  proc callback(req: Request) {.gcsafe, async.} =
    let headers = newHttpHeaders([("content-type", "text/plain")])
    d("GET: ", req.body)
    if req.url.path == "/" & secret:
      try:
        let
          json = parseJson(req.body)
          update = unmarshal(json, Update)
        await b.handleUpdate(update)
        await req.respond(Http200, "OK\n", headers)
      except:
        await req.respond(Http500, "FAIL\n", headers)
    else:
      await req.respond(Http404, "Not Found\n", headers)

  var server = newAsyncHttpServer()
  d("Starting webhook, listens on port ", port.int)
  d("URL: ", url)
  waitFor server.serve(port=port, callback=callback)

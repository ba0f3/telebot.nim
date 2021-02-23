import asyncdispatch, asynchttpserver, httpclient, strutils, sam, options
import utils, types, api

type
  WebhookInfo* = object
    url*: string
    hasCustomCertificate*: bool
    pendingUpdateCount*: int
    ipAddress*: string
    lastErrorDate*: int
    lastErrorMessage*: string
    maxConnections*: int
    allowedUpdates*: seq[string]

proc getWebhookInfo(n: JsonNode): WebhookInfo =
  result.url = $n["url"]
  result.hasCustomCertificate = n["has_custom_certificate"].toBool
  result.pendingUpdateCount = n["pending_update_count"].toInt
  if n.hasKey("ip_address"):
    result.ipAddress = $n["ip_address"]
  if n.hasKey("last_error_date"):
    result.lastErrorDate = n["last_error_date"].toInt
  if n.hasKey("last_error_message"):
    result.lastErrorMessage = $n["last_error_message"]
  if n.hasKey("max_connections"):
    result.maxConnections = n["max_connections"].toInt
  else:
    result.maxConnections = 40
  if n.hasKey("allowed_updates"):
    result.allowedUpdates = @[]
    for i in n["allowed_udpates"]:
      result.allowedUpdates.add($i)

proc setWebhook*(b: TeleBot, url: string, certificate = "", ipAddress = "", maxConnections = -1, allowedUpdates: seq[string] = @[], dropPendingUpdates = false) {.async.} =
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

  discard await makeRequest(b, procName, data)

proc deleteWebhook*(b: TeleBot, dropPendingUpdates = false): Future[bool] {.async.} =
  var data = newMultipartData()
  if dropPendingUpdates:
    data["drop_pending_updates"] = "true"
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc getWebhookInfo*(b: TeleBot): Future[WebhookInfo] {.async.} =
  let res = await makeRequest(b, procName)
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

  proc callback(req: Request) {.async.} =
    let headers = newHttpHeaders([("content-type", "text/plain")])
    d("GET: ", req.body)
    if req.url.path == "/" & secret:
      try:
        let
          json = parse(req.body)
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

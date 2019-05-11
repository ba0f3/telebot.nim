import asyncdispatch, httpclient, strutils, sam
import utils, types

type
  WebhookInfo* = object
    url*: string
    hasCustomCertificate*: bool
    pendingUpdateCount*: int
    lastErrorDate*: int
    lastErrorMessage*: string
    maxConnections*: int
    allowedUpdates*: seq[string]

proc getWebhookInfo(n: JsonNode): WebhookInfo =
  result.url = $n["url"]
  result.hasCustomCertificate = n["has_custom_certificate"].toBool
  result.pendingUpdateCount = n["pending_update_count"].toInt
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

proc setWebhook*(b: TeleBot, url: string, certificate: string = "", maxConnections = -1, allowedUpdates: seq[string] = @[]) {.async.} =
  END_POINT("setWebhook")
  var data = newMultipartData()
  data["url"] = url
  if certificate.len > 0:
    data.addFiles({"certificate": certificate})
  if maxConnections > 0 and maxConnections != 40:
    data["max_connections"] = $maxConnections
  if allowedUpdates.len > 0:
    data["allowed_updates"] = $allowedUpdates

  discard await makeRequest(b, endpoint % b.token, data)

proc deleteWebhook*(b: TeleBot): Future[bool] {.async.} =
  END_POINT("deleteWebhook")
  let res = await makeRequest(b, endpoint % b.token)
  result = res.toBool

proc getWebhookInfo*(b: TeleBot): Future[WebhookInfo] {.async.} =
  END_POINT("getWebhookInfo")
  let res = await makeRequest(b, endpoint % b.token)
  result = getWebhookInfo(res)

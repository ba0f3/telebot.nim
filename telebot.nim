import httpclient, json, strutils, tempfile, os, uri


import private/[types, common, inline, webhook]
export types, inline

proc newTeleBot*(token: string): TeleBot =
  ## Init new Telegram Bot instance
  new(result)
  result.token = token
  result.lastUpdateId = 0

include private/api

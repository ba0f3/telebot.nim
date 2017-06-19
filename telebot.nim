import httpclient, json, strutils, tempfile, os, uri


import private/[types, common, webhook]
export types

proc newTeleBot*(token: string): TeleBot =
  ## Init new Telegram Bot instance
  new(result)
  result.token = token
  result.lastUpdateId = 0

include private/api

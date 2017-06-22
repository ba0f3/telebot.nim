import httpclient, json, strutils, tempfile, os, uri


import private/[types, optional, common, webhook]
export types, optional.`$`, optional.`unwrap`

proc newTeleBot*(token: string): TeleBot =
  ## Init new Telegram Bot instance
  new(result)
  result.token = token
  result.lastUpdateId = 0

include private/api

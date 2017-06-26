import httpclient, json, strutils, tempfile, os, uri, options


import private/[types, keyboard, webhook]
export types, options, keyboard

proc newTeleBot*(token: string): TeleBot =
  ## Init new Telegram Bot instance
  new(result)
  result.token = token
  result.lastUpdateId = 0

include private/api

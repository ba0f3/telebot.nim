import tables, httpclient

import telebot/[types, keyboard, webhook, inputmedia, helpers]
export types, webhook, keyboard, inputmedia, helpers

proc initHttpClient(b: Telebot, proxy: Proxy = nil) {.inline.} =
  b.httpClient = newAsyncHttpClient(userAgent="telebot.nim/0.5.7", proxy=proxy)
  b.httpClient.headers = newHttpHeaders({
    "Connection": "Keep-Alive",
    "Keep-Alive": "timeout=50"
  })

proc setProxy*(b: Telebot, url: string, auth = "") {.inline.} =
  b.initHttpClient(newProxy(url, auth))

proc newTeleBot*(token: string): TeleBot =
  ## Init new Telegram Bot instance
  new(result)
  result.token = token
  result.commandCallbacks = newTable[string, seq[CommandCallback]]()

  result.initHttpClient()

include telebot/api
include telebot/events

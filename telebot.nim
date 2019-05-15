import tables, httpclient

import telebot/[types, keyboard, webhook, inputmedia, helpers]
export types, webhook, keyboard, inputmedia, helpers

proc setProxy*(b: Telebot, url: string, auth = "") {.inline.} =
  b.proxy = newProxy(url, auth)

proc newTeleBot*(token: string): TeleBot =
  ## Init new Telegram Bot instance
  new(result)
  result.token = token
  result.commandCallbacks = newTable[string, seq[CommandCallback]]()

include telebot/api
include telebot/events

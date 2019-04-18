import tables

import telebot/[types, keyboard, webhook, inputmedia, helpers]
export types, webhook, keyboard, inputmedia, helpers

proc newTeleBot*(token: string): TeleBot =
  ## Init new Telegram Bot instance
  new(result)
  result.token = token
  result.lastUpdateId = 0
  result.updateCallbacks = @[]
  result.commandCallbacks = newTable[string, seq[CommandCallback]]()
  result.inlineQueryCallbacks = @[]

include telebot/api
include telebot/events

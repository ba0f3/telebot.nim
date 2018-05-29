import asyncevents except off

import telebot/[types, keyboard, webhook]
export types, webhook, keyboard

proc newTeleBot*(token: string): TeleBot =
  ## Init new Telegram Bot instance
  new(result)
  result.token = token
  result.lastUpdateId = 0
  result.updateEmitter = initAsyncEventEmitter[Update, string]()
  result.commandEmitter = initAsyncEventEmitter[Command, string]()

include telebot/api
include telebot/events

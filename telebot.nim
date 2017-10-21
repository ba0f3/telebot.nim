import tables

import telebot/[types, keyboard, webhook]
export types, webhook, keyboard

proc newTeleBot*(token: string, name: string): TeleBot =
  ## Init new Telegram Bot instance
  new(result)
  result.token = token
  result.lastUpdateId = 0
  result.commands = initTable[string, Command](2)
  result.name = name

include telebot/api

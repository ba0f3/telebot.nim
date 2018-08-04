import telebot, asyncdispatch, options

const API_KEY = slurp("secret.key")

proc geoHandler(bot: TeleBot, e: Command) {.async.} =
  let message = newLocation(e.message.chat.id, longitude=42.0, latitude=42.0)
  discard await bot.send(message)

let bot = newTeleBot(API_KEY)
bot.onCommand("geo", geoHandler)  # Use /geo on Telegram chat to trigger.
bot.poll(666)

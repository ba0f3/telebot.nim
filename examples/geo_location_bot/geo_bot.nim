import telebot, asyncdispatch, options

const API_KEY = slurp("../secret.key")

proc geoHandler(bot: TeleBot, e: Command): Future[bool] {.async.} =
  discard await bot.sendLocation(e.message.chat.id, longitude=42.0, latitude=42.0)

let bot = newTeleBot(API_KEY)
bot.onCommand("geo", geoHandler)  # Use /geo on Telegram chat to trigger.
bot.poll(timeout=666)

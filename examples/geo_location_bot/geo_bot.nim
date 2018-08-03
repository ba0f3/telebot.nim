import telebot, asyncdispatch, options

const API_KEY = ""  # Add your API Key here.

proc geoHandler(bot: TeleBot): CommandCallback =
  proc cb(e: Command) {.async.} =
    let message = newLocation(e.message.chat.id, longitude=42.0, latitude=42.0)
    discard await bot.send(message)
  result = cb

let bot = newTeleBot(API_KEY)
bot.onCommand("geo", geoHandler(bot))  # Use /geo on Telegram chat to trigger.
bot.poll(666)

import telebot, asyncdispatch, options, logging, os


const API_KEY = ""  # Add your API Key here.


addHandler(newConsoleLogger(fmtStr="$levelname, [$time] "))

proc handleUpdate(bot: TeleBot): UpdateCallback =
  proc cb(e: Update) {.async.} =
    let message = newPhoto(e.message.get.chat.id, "file://" & getCurrentDir() & "/sample.jpg")
    discard await bot.send(message)
  result = cb

let
  bot = newTeleBot(API_KEY)
  handler = handleUpdate(bot)

bot.onUpdate(handler)
bot.poll(500)

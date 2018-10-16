import telebot, asyncdispatch, options, logging, os


const API_KEY = slurp("secret.key")


addHandler(newConsoleLogger(fmtStr="$levelname, [$time] "))

proc updateHandler(bot: TeleBot, e: Update) {.async.} =
  let message = newPhoto(e.message.get.chat.id, "file://" & getCurrentDir() & "/sample.jpg")
  discard await bot.send(message)

let bot = newTeleBot(API_KEY)

bot.onUpdate(updateHandler)
bot.poll(timeout=500)

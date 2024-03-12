import telebot, asyncdispatch, logging, os, strutils


const API_KEY = slurp("../secret.key").strip()


addHandler(newConsoleLogger(fmtStr="$levelname, [$time] "))

proc updateHandler(bot: TeleBot, e: Update): Future[bool] {.async.} =
  discard await bot.sendPhoto(e.message.chat.id, "file://" & getAppDir() & "/sample.jpg")

let bot = newTeleBot(API_KEY)

bot.onUpdate(updateHandler)
bot.poll(timeout=500)

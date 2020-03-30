import telebot, asyncdispatch, logging, options
from strutils import strip

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc updateHandler(b: Telebot, u: Update) {.async.} =
  var response = u.message.get
  if response.text.isSome:
    discard await b.sendMessage(response.chat.id, response.text.get)


proc greatingHandler(b: Telebot, c: Command) {.async.} =
  discard b.sendMessage(c.message.chat.id, "hello " & c.message.fromUser.get().firstName)

when isMainModule:
  let bot = newTeleBot(API_KEY)
  bot.setProxy("http://localhost:8080")

  bot.onUpdate(updateHandler)
  bot.onCommand("hello", greatingHandler)
  bot.poll(timeout=300)

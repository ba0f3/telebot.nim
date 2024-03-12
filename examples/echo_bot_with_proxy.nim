import telebot, asyncdispatch, logging
from strutils import strip

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc updateHandler(b: Telebot, u: Update): Future[bool] {.gcsafe, async.} =
  if u.message != nil:
    var response = u.message
    if response.text.len > 0:
      discard await b.sendMessage(response.chat.id, response.text)


proc greatingHandler(b: Telebot, c: Command): Future[bool] {.gcsafe, async.} =
  if c.message.fromUser != nil:
    discard b.sendMessage(c.message.chat.id, "hello " & c.message.fromUser.firstName)

when isMainModule:
  let bot = newTeleBot(API_KEY)
  bot.setProxy("http://localhost:8080")

  bot.onUpdate(updateHandler)
  bot.onCommand("hello", greatingHandler)
  bot.poll(timeout=300)

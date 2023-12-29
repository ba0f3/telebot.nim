import telebot, asyncdispatch, logging, options
from strutils import strip

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc updateHandler(b: Telebot, u: Update): Future[bool] {.gcsafe, async.} =
  if u.message.isSome:
    var response = u.message.get
    if response.text.isSome:
      let text = response.text.get
      echo text
      discard await b.sendMessage(response.chat.id, "text:" & text, parseMode = "markdown", disableNotification = true, replyParameters = ReplyParameters(messageId: response.messageId))
  return true


proc greatingHandler(b: Telebot, c: Command): Future[bool] {.gcsafe, async.} =
  discard b.sendMessage(c.message.chat.id, "hello " & c.message.fromUser.get().firstname, disableNotification = true, replyParameters = ReplyParameters(messageId: c.message.messageId))
  result = true

when isMainModule:
  when defined(local):
    let bot = newTeleBot(API_KEY, "http://127.0.0.1:8081")
  else:
    let bot = newTeleBot(API_KEY)

  bot.onUpdate(updateHandler)
  bot.onCommand("hello", greatingHandler)
  bot.poll(timeout=300)

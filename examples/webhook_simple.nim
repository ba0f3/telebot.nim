import telebot, asyncdispatch, logging
from strutils import strip

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc updateHandler(b: Telebot, u: Update): Future[bool] {.gcsafe, async.} =
  if u.message.isNil:
    return true
  var response = u.message
  if response.text.len > 0:
    discard b.sendMessage(response.chat.id, response.text, disableNotification = true, replyParameters = ReplyParameters(messageId: response.messageId), parseMode = "markdown")
  return true


proc greatingHandler(b: Telebot, c: Command): Future[bool] {.gcsafe, async.} =
  if c.message.fromUser != nil:
    discard b.sendMessage(c.message.chat.id, "hello " & c.message.fromUser.firstName, disableNotification = true, replyParameters = ReplyParameters(messageId: c.message.messageId), parseMode = "markdown")

when isMainModule:
  let bot = newTeleBot(API_KEY)

  bot.onUpdate(updateHandler)
  bot.onCommand("hello", greatingHandler)

  bot.startWebhook("rNFRWJqqmxteVtjciNFxuNoznphWzxYFNscicjrYPHVjrnYrFVtdKNkckk3hjAYH", "https://0899ba14.ngrok.io/rNFRWJqqmxteVtjciNFxuNoznphWzxYFNscicjrYPHVjrnYrFVtdKNkckk3hjAYH")

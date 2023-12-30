import telebot, asyncdispatch, logging
from strutils import strip

var L = newConsoleLogger()
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc updateHandler(b: Telebot, u: Update): Future[bool] {.gcsafe, async.} =
  var response = u.message
  if response.text.len > 0:
    let text = response.text
    var google = KeyboardButton(text: "Search the web", webApp: WebAppInfo(url: "https://quick-loops-prove-116-110-41-44.loca.lt/webapp.html"))

    let replyMarkup = ReplyKeyboardMarkup(kind: kReplyKeyboardMarkup, keyboard: @[@[google]])

    discard await b.sendMessage(response.chat.id, text, replyMarkup = replyMarkup)

when isMainModule:
  let bot = newTeleBot(API_KEY)

  bot.onUpdate(updateHandler)
  bot.poll(timeout=300)
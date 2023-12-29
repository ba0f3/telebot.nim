import telebot, asyncdispatch, logging, options
from strutils import strip

var L = newConsoleLogger()
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc updateHandler(b: Telebot, u: Update): Future[bool] {.gcsafe, async.} =
  var response = u.message.get
  if response.text.isSome:
    let text = response.text.get
    var google = KeyboardButton(text: "Search the web", webApp: some WebAppInfo(url: "https://quick-loops-prove-116-110-41-44.loca.lt/webapp.html"))

    let replyMarkup = ReplyKeyboardMarkup(kind: kReplyKeyboardMarkup, keyboard: @[@[google]])

    discard await b.sendMessage(response.chat.id, text, replyMarkup = replyMarkup)

when isMainModule:
  let bot = newTeleBot(API_KEY)

  bot.onUpdate(updateHandler)
  bot.poll(timeout=300)
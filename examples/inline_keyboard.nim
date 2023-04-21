import telebot, asyncdispatch, logging, options
from strutils import strip

var L = newConsoleLogger()
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc updateHandler(b: Telebot, u: Update): Future[bool] {.gcsafe, async.} =
  var response = u.message.get
  if response.text.isSome:
    let
      text = response.text.get
    var
      google = initInlineKeyboardButton("Google", url = "https://www.google.com/search?q=" & text)
      bing = initInlineKeyboardButton("Bing", url = "https://www.bing.com/search?q=" & text)
      ddg = initInlineKeyboardButton("DuckDuckGo", url = "https://duckduckgo.com/?q=" & text)
      searx = initInlineKeyboardButton("searx.me", url = "https://searx.me/?q=" & text)

    let replyMarkup = newInlineKeyboardMarkup(@[google, bing], @[ddg, searx])

    discard await b.sendMessage(response.chat.id, text, replyMarkup = replyMarkup)

when isMainModule:
  let bot = newTeleBot(API_KEY)

  bot.onUpdate(updateHandler)
  bot.poll(timeout=300)

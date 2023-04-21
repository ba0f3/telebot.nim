import telebot, asyncdispatch, logging, options
from strutils import strip

var L = newConsoleLogger()
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc updateHandler(b: Telebot, u: Update): Future[bool] {.gcsafe, async.} =
  if u.message.isSome:
    var response = u.message.get
    if response.text.isSome:
      let text = response.text.get
      var
        yes = initInlineKeyboardButton("Yes 🆗", callbackData = "yes " & text)
        no = initInlineKeyboardButton("No 🚫", callbackData = "no " & text)

      let replyMarkup = newInlineKeyboardMarkup(@[yes, no])

      discard await b.sendMessage(response.chat.id, "Confirm: " & text, replyMarkup = replyMarkup)
  elif u.callbackQuery.isSome:
    var data = u.callbackQuery.get
    try:
      discard await b.answerCallbackQuery(data.id, "Response: " & data.data.get, true)
    except CatchableError:
      discard


when isMainModule:
  let bot = newTeleBot(API_KEY)

  bot.onUpdate(updateHandler)
  bot.poll(timeout=300)

import telebot, asyncdispatch, logging
from strutils import strip

var L = newConsoleLogger()
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc updateHandler(b: Telebot, u: Update): Future[bool] {.gcsafe, async.} =
  if u.message != nil:
    var response = u.message
    if response.text.len > 0:
      let text = response.text
      var
        yes = newInlineKeyboardButton("Yes 🆗", callbackData = "yes " & text)
        no = newInlineKeyboardButton("No 🚫", callbackData = "no " & text)

      let replyMarkup = newInlineKeyboardMarkup(@[yes, no])

      echo replyMarkup[]

      discard await b.sendMessage(response.chat.id, "Confirm: " & text, replyMarkup = replyMarkup)
  elif u.callbackQuery != nil:
    var data = u.callbackQuery
    try:
      discard await b.answerCallbackQuery(data.id, "Response: " & data.data, true)
    except CatchableError:
      discard


when isMainModule:
  let bot = newTeleBot(API_KEY)

  bot.onUpdate(updateHandler)
  bot.poll(timeout=300)

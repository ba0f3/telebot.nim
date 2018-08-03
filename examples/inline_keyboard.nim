import ../telebot, asyncdispatch, logging, options

var L = newConsoleLogger()
addHandler(L)

const API_KEY = slurp("secret.key")

var updates: seq[Update]


proc handleUpdate(bot: TeleBot): UpdateCallback =
  proc cb(e: Update) {.async.} =
    var response = e.message.get
    if response.text.isSome:
      let
        text = response.text.get
      var
        message = newMessage(response.chat.id, text)
        google = initInlineKeyboardButton("Google")
        bing = initInlineKeyboardButton("Bing")
        ddg = initInlineKeyboardButton("DuckDuckGo")
        searx = initInlineKeyboardButton("searx.me")

      google.url = some("https://www.google.com/search?q=" & text)
      bing.url = some("https://www.bing.com/search?q=" & text)
      ddg.url = some("https://duckduckgo.com/?q=" & text)
      searx.url = some("https://searx.me/?q=" & text)

      message.replyMarkup = newInlineKeyboardMarkup(@[google, bing], @[ddg, searx])
      discard await bot.send(message)
  result = cb

when isMainModule:
  let
    bot = newTeleBot(API_KEY)
    handler = handleUpdate(bot)

  bot.onUpdate(handler)
  bot.poll(300)

import ../telebot, asyncdispatch, logging

var L = newConsoleLogger()
addHandler(L)

const API_KEY = slurp("secret.key")

var updates: seq[Update]
proc main() {.async.} =
  let bot = newTeleBot(API_KEY)
  while true:
    updates = await bot.getUpdates(timeout=300)
    for update in updates:
      if update.message.isSome:
        var response = update.message.get
        if response.text.isNone:
          continue
        let
          user = response.fromUser.get
          text = response.text.get

        var
          message = newMessage(response.chat.id, text)
          google = initInlineKeyboardButton("Google")
          bing = initInlineKeyboardButton("Bing")
          ddg = initInlineKeyboardButton("DuckDuckGo")
          searx = initInlineKeyboardButton("searx.me")

        google.url = "https://www.google.com/search?q=" & text
        bing.url = "https://www.bing.com/search?q=" & text
        ddg.url = "https://duckduckgo.com/?q=" & text
        searx.url = "https://searx.me/?q=" & text

        message.replyMarkup = newInlineKeyboardMarkup(@[google, bing], @[ddg, searx])

        discard await bot.send(message)

asyncCheck main()
runForever()

import ../telebot, asyncdispatch, logging, options

var L = newConsoleLogger()
addHandler(L)

const API_KEY = slurp("secret.key")

var updates: seq[Update]
proc main() {.async.} =
  let bot = newTeleBot(API_KEY, "nim_telebot")
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

        var message = newMessage(response.chat.id, text)
        message.disableNotification = true
        message.replyToMessageId = response.messageId
        message.parseMode = "markdown"
        discard await bot.send(message)

asyncCheck main()
runForever()

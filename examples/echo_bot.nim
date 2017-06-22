import ../telebot, asyncdispatch

const API_KEY = slurp("secret.key")

var updates: seq[Update]
proc main() {.async.} =
  let bot = newTeleBot(API_KEY)
  while true:
    updates = await bot.getUpdates(timeout=300)
    for update in updates:
      if update.kind == kMessage:
        if not update.message.text.isNil:
          let
            user = unwrap(update.message.fromUser)
            text = unwrap(update.message.text)

          var message = newMessage(update.message.chat.id, "Got message from: *" & user.firstName &  "*\nText: `" & text & "`")
          message.disableNotification = true
          message.parseMode = "markdown"
          discard await bot.send(message)

asyncCheck main()
runForever()

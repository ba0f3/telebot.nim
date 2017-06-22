import ../telebot, asyncdispatch

const API_KEY = slurp("secret.key")

proc main() {.async.} =
  let bot = newTeleBot(API_KEY)

  var updates: seq[Update]
  while true:
    updates = await bot.getUpdates(timeout=300)
    echo "Got ", updates.len, " message(s)"
    for update in updates:
      if update.kind == kMessage:
        if not update.message.text.isNil:
          var message = newMessage(update.message.chat.id, $update.message.text)
          message.disableNotification = true
          discard await bot.send(message)

asyncCheck main()
runForever()

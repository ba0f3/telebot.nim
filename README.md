# telebot.nim
Async Telegram Bot API Client implement in @Nim-Lang

Installation
============
```
$ nimble install telebot
```

Usage
=====
```nim
import asyncdispatch
import telebot

let bot = newTeleBot("ABC:XYZ")

proc main() {.async.} =
  var message = newMessage(XXXX, "hi boss")
  message.disableNotification = true
  less response = bot.send(message)
  echo "Sent message ID: ", response.messageId
  
  var updates: seq[Update]
  while true:
    updates = await bot.getUpdates()
    echo "Got ", updates.len, " message(s)"

asyncCheck main()
runForever()
```
For more information please refer to official [Telegram Bot API](https://core.telegram.org/bots/api) page

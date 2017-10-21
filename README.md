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
import asyncdispatch, telebot, options

const API_KEY = "ABC:XYZ"

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

```
For more information please refer to official [Telegram Bot API](https://core.telegram.org/bots/api) page

# telebot.nim
Async Telegram Bot API Client implement in @Nim-Lang

Installation
============
```
$ nimble install telebot
```

Usage
=====

## echo bot
```nim
import telebot, asyncdispatch, options

const API_KEY = slurp("secret.key")

proc handleUpdate(bot: TeleBot): UpdateCallback =
  proc cb(e: Update) {.async.} =
    var response = e.message.get
    if response.text.isSome:
      let
        text = response.text.get
      var message = newMessage(response.chat.id, text)
      message.disableNotification = true
      message.replyToMessageId = response.messageId
      message.parseMode = "markdown"
      discard bot.send(message)
  result = cb

let
  bot = newTeleBot(API_KEY)
  handler = handleUpdate(bot)
bot.onUpdate(handler)
bot.poll(300)

```

## send local photo
```nim
import telebot, asyncdispatch, options, logging

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

const API_KEY = slurp("secret.key")

proc handleUpdate(bot: TeleBot): UpdateCallback =
  proc cb(e: Update) {.async.} =
    var response = e.message.get
    if response.text.isSome:
      let
        text = response.text.get
      var message = newPhoto(response.chat.id, "file:///path/to/photo.jpg")
      discard await bot.send(message)
  result = cb

let
  bot = newTeleBot(API_KEY)
  handler = handleUpdate(bot)

bot.onUpdate(handler)
bot.poll(300)
```
For more information please refer to official [Telegram Bot API](https://core.telegram.org/bots/api) page

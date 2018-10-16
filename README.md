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
import telebot, asyncdispatch, logging, options

const API_KEY = slurp("secret.key")

proc updateHandler(b: Telebot, u: Update) {.async.} =
  var response = u.message.get
  if response.text.isSome:
    let
      text = response.text.get
    var message = newMessage(response.chat.id, text)
    message.disableNotification = true
    message.replyToMessageId = response.messageId
    message.parseMode = "markdown"
    discard await b.send(message)

let bot = newTeleBot(API_KEY)
bot.onUpdate(updateHandler)
bot.poll(timeout=300)
```

## send local photo
```nim
import telebot, asyncdispatch, options, logging

const API_KEY = slurp("secret.key")

proc updateHandler(bot: TeleBot, update: Update): UpdateCallback =
  var response = update.message.get
  if response.text.isSome:
    let
      text = response.text.get
    var message = newPhoto(response.chat.id, "file:///path/to/photo.jpg")
    discard await bot.send(message)

let
  bot = newTeleBot(API_KEY)
bot.onUpdate(updateHandler)
bot.poll(timeout=300)
```
For more information please refer to official [Telegram Bot API](https://core.telegram.org/bots/api) page

# telebot.nim
Async Telegram Bot API Client implement in @Nim-Lang

Notes
=====
From version 1.0.0, procs likes `newMessage`, `newPhoto`,.. are gone, use `sendMessage`, `sendDocument` instead.
If you still prefer the old/ugly way to send stuffs, just import `telebot/compat` for backward compatible

Installation
============
```
$ nimble install telebot
```

Usage
=====

## echo bot
```nim
import telebot, asyncdispatch, logging, options, strutils
var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

# remember to strip your secret key to avoid HTTP error
const API_KEY = strip(slurp("secret.key"))

proc updateHandler(b: Telebot, u: Update): Future[bool] {.async.} =
  if not u.message.isSome:
    # return true will make bot stop process other callbacks
    return true
  var response = u.message.get
  if response.text.isSome:
    let text = response.text.get
    discard await b.sendMessage(response.chat.id, text, parseMode = "markdown", disableNotification = true, replyParameters = ReplyParameters(messageId: response.messageId))

let bot = newTeleBot(API_KEY)
bot.onUpdate(updateHandler)
bot.poll(timeout=300)

```

## send local photo
```nim
import telebot, asyncdispatch, options, logging, strutils

# remember to strip your secret key to avoid HTTP error
const API_KEY = strip(slurp("secret.key"))

proc updateHandler(bot: TeleBot, update: Update): Future[bool] {.async.} =
  discard await bot.sendPhoto(response.chat.id, "file:///path/to/photo.jpg")

let bot = newTeleBot(API_KEY)
bot.onUpdate(updateHandler)
bot.poll(timeout=300)
```
For more information please refer to official [Telegram Bot API](https://core.telegram.org/bots/api) page

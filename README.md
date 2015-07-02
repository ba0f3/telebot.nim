# telebot.nim
Async Telegram Bot API Client implement in @Nim-Lang

## Usage
```nim
import asyncdispatch
import telebot

let bot = newTeleBot("ABC:XYZ")

proc main() {.async.} =
  let message =  await bot.sendMessage(XXXX, "hi boss")
  echo "Sent message ID: ", message.messageId
  
  var updates: seq[Update]
  while true:
    updates = await bot.getUpdates()
    echo "Got ", updates.len, " message(s)"

asyncCheck main()
runForever()
```
For more information please refer to official [Telegram Bot API](https://core.telegram.org/bots/api) page

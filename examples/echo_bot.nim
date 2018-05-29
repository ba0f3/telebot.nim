import ../telebot, asyncdispatch, logging, options

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

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

proc greatingHandler(bot: Telebot): CommandCallback =
  proc cb(e: Command) {.async.} =
    var message = newMessage(e.message.chat.id, "hello " & e.message.fromUser.get().firstName)
    message.disableNotification = true
    message.replyToMessageId = e.message.messageId
    message.parseMode = "markdown"
    discard bot.send(message)

  result = cb

when isMainModule:
  let
    bot = newTeleBot(API_KEY)
    handler = handleUpdate(bot)
    greatingCb = greatingHandler(bot)

  bot.onUpdate(handler)
  bot.onCommand("hello", greatingCb)
  bot.poll(300)

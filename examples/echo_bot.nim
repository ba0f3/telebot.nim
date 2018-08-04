import ../telebot, asyncdispatch, logging, options

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

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


proc greatingHandler(b: Telebot, c: Command) {.async.} =
  var message = newMessage(c.message.chat.id, "hello " & c.message.fromUser.get().firstName)
  message.disableNotification = true
  message.replyToMessageId = c.message.messageId
  message.parseMode = "markdown"
  discard b.send(message)

when isMainModule:
  let bot = newTeleBot(API_KEY)

  bot.onUpdate(updateHandler)
  bot.onCommand("hello", greatingHandler)
  bot.poll(300)

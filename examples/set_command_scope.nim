import telebot, asyncdispatch, logging, options
from strutils import strip

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc greatingHandler(b: Telebot, c: Command): Future[bool] {.gcsafe, async.} =
  discard b.sendMessage(c.message.chat.id, "hello " & c.message.fromUser.get().firstname, disableNotification = true, replyParameters = ReplyParameters(messageId: c.message.messageId))
  result = true


when isMainModule:
  let bot = newTeleBot(API_KEY)

  var commands = @[
    BotCommand(command: "hello" , description: "Greating")
  ]

  echo waitFor bot.setMyCommands(commands)
  echo waitFor bot.setMyCommands(commands, COMMAND_SCOPE_CHAT,  "-1001149985204")
  echo waitFor bot.setMyCommands(commands, COMMAND_SCOPE_CHAT_MEMBER,  "-1001149985204", 1)

  bot.onCommand("hello", greatingHandler)
  bot.poll(timeout=300)

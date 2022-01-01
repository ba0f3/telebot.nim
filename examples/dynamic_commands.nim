import telebot, asyncdispatch, logging
from strutils import strip

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc getCommandHandler(b: Telebot, c: Command): Future[bool] {.gcsafe, async.} =
  let commands = await b.getMyCommands()
  var output = ""
  if commands.len == 0:
    output = "No command registered yet"
  else:
    for command in commands:
      output.add(command.command & "\t" & command.description & "\n")
  discard await b.sendMessage(c.message.chat.id, "```\n" & output & "\n```", parseMode="markdown")
  result = true

proc setCommandHandler(b: Telebot, c: Command): Future[bool] {.gcsafe, async.} =
  discard await b.sendDice(c.message.chat.id)
  result = true

when isMainModule:
  let bot = newTeleBot(API_KEY)
  bot.onCommand("get", getCommandHandler)
  bot.onCommand("set", setCommandHandler)
  bot.poll(timeout=300)

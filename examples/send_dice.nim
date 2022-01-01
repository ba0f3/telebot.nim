import telebot, asyncdispatch, logging
from strutils import strip

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc commandHandler(b: Telebot, c: Command): Future[bool] {.gcsafe, async.} =
  discard await b.sendDice(c.message.chat.id)

when isMainModule:
  let bot = newTeleBot(API_KEY)
  bot.onCommand("dice", commandHandler)
  bot.poll(timeout=300)

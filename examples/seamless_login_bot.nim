import telebot, asyncdispatch, logging
from strutils import strip

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

const API_KEY = slurp("secret.key").strip()

#[
    YOU MUST SET DOMAIN FOR YOUR BOT FIRST
    SEND /setdomain COMMAND TO @BotFatheR
]#

proc loginHandler(b: Telebot, c: Command): Future[bool] {.gcsafe, async.} =
  var loginButton = initInlineKeyBoardButton("Login")
  loginButton.loginUrl = newLoginUrl("https://huy.im")
  discard await b.sendMessage(c.message.chat.id, "Welcome to Seamless Web Bots", replyMarkup = newInlineKeyboardMarkup(@[loginButton]))


when isMainModule:
  let bot = newTeleBot(API_KEY)

  bot.onCommand("login", loginHandler)
  bot.poll(timeout=300)

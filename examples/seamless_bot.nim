import ../telebot, asyncdispatch, logging, options, sam, telebot/utils
from strutils import strip

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

const API_KEY = slurp("secret.key").strip()

#[
    YOU MUST SET DOMAIN FOR YOUR BOT FIRST
    SEND /setdomain COMMAND TO @BotFatheR
]#

proc loginHandler(b: Telebot, c: Command) {.async.} =
    var
      message = newMessage(c.message.chat.id, "Welcome to Seamless Web Bots")
      loginButton = initInlineKeyBoardButton("Login")
    loginButton.loginUrl = some(newLoginUrl("https://huy.im"))
    message.replyMarkup = newInlineKeyboardMarkup(@[loginButton])
    discard await b.send(message)


when isMainModule:
    let bot = newTeleBot(API_KEY)

    bot.onCommand("login", loginHandler)
    bot.poll(timeout=300)

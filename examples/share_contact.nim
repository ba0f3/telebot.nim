import telebot, asyncdispatch, logging, strutils

#[
  this example has been shared by @hamidb80
  https://github.com/ba0f3/telebot.nim/issues/68
]#

var L = newConsoleLogger(fmtStr = "$levelname, [$time] ")
addHandler(L)

func singleReply*(btn: KeyboardButton): ReplyKeyboardMarkup =
  ReplyKeyboardMarkup(kind: kReplyKeyboardMarkup, keyboard: @[@[btn]])

const API_KEY = slurp("secret.key").strip()

proc updateHandler(b: Telebot, u: Update): Future[bool] {.gcsafe, async.} =
  if u.message != nil:
    var response = u.message

    if response.contact != nil:
      # send received contact info
      discard await b.sendMessage(
        response.chat.id,
        $response.contact[],
      )

    else:
      # send help
      discard await b.sendMessage(
        response.chat.id,
        "check the virtual keyboard",
        replyMarkup = singleReply(
          KeyboardButton(text: "send your contact", requestContact: true)
      ))

  return true

let bot = newTeleBot(API_KEY)

while true:
  try:
    bot.onUpdate(updateHandler)
    bot.poll(timeout=300)
  except:
    echo getCurrentExceptionMsg()
    continue

import telebot, asyncdispatch, logging
from strutils import strip

import ../src/telebot/private/utils

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc commandHandler(b: Telebot, c: Command): Future[bool] {.gcsafe, async.} =
  let perms = ChatPermissions(
    canSendMessages: true,
    canSendAudios: true,
    canSendOtherMessages: true,
    canAddWebPagePreviews: true)

  var json  = ""
  marshal(perms, json)
  echo json
  discard await restrictChatMember(b, $c.message.chat.id, 50535480, perms)

  discard await getChatMember(b, $c.message.chat.id, 50535480)


when isMainModule:
  let bot = newTeleBot(API_KEY)
  bot.onCommand("perms", commandHandler)
  bot.poll(timeout=300)

import ../telebot, asyncdispatch, logging, options, sam
from strutils import strip

import ../telebot/utils

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc commandHandler(b: Telebot, c: Command) {.async.} =
  let perms = ChatPermissions(
    canSendMessages: some(true),
    canSendMediaMessages: some(true),
    canSendOtherMessages: some(true),
    canAddWebPagePreviews: some(true))

  var json  = ""
  marshal(perms, json)
  echo json
  discard await restrictChatMember(b, $c.message.chat.id, 50535480, perms)

  discard await getChatMember(b, $c.message.chat.id, 50535480)


when isMainModule:
  let bot = newTeleBot(API_KEY)
  bot.onCommand("perms", commandHandler)
  bot.poll(timeout=300)

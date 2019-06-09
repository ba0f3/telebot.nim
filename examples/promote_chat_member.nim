import ../telebot, asyncdispatch, logging, options, sam
from strutils import strip

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc promoteHandler(b: Telebot, c: Command) {.async.} =
    try:
        echo waitFor b.promoteChatMember($c.message.chat.id, c.message.fromUser.get().id,
            canChangeInfo=true,
            canPostMessages = true,
            canEditMessages = true,
            canDeleteMessages = true,
            canInviteUsers = true,
            canRestrictMembers = true,
            canPinMessages = true,
            canPromoteMembers = true
        )
    except:
        discard

when isMainModule:
    let bot = newTeleBot(API_KEY)

    bot.onCommand("promote", promoteHandler)
    bot.poll(timeout=300)

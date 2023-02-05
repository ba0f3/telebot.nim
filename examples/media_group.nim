import telebot, asyncdispatch, options, logging, os, strutils


const API_KEY = strip(slurp("secret.key"))


addHandler(newConsoleLogger(fmtStr="$levelname, [$time] "))

proc updateHandler(bot: TeleBot, e: Update): Future[bool] {.async.} =
  var media: seq[InputMediaPhoto]
  media.add(newInputMediaPhoto("file://" & getAppDir() & "/sample.jpg", "test photo"))
  let messages = await bot.sendMediaGroup(e.message.get.chat.id, media)

  if messages.len  > 0:
    var editedPhoto = newInputMediaPhoto("file://" & getAppDir() & "/sample.jpg", "edited photo")
    echo await bot.editMessageMedia(editedPhoto, $e.message.get.chat.id, messages[0].messageId)

let bot = newTeleBot(API_KEY)

bot.onUpdate(updateHandler)
bot.poll(timeout=500)

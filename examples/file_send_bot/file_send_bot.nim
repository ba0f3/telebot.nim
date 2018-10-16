# This Bot Sends itself as Document file, responds on chat with source file to download.
import telebot, asyncdispatch, options, os

const API_KEY = slurp("secret.key")


proc updateHandler(bot: TeleBot, e: Update) {.async.} =
  let this_file = "file://" & getCurrentDir() & "/file_send_bot.nim"

  var document = newDocument(e.message.get.chat.id, this_file)
  document.caption = this_file
  discard await bot.send(document)

let bot = newTeleBot(API_KEY)
bot.onUpdate(updateHandler)
bot.poll(timeout=666)

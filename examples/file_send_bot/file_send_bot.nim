# This Bot Sends itself as Document file, responds on chat with source file to download.
import telebot, asyncdispatch, options, os

const API_KEY = ""  # Add your API Key here.


proc handleUpdate(bot: TeleBot): UpdateCallback =
  let this_file = "file://" & getCurrentDir() & "/file_send_bot.nim"
  proc cb(e: Update) {.async.} =
    var document = newDocument(e.message.get.chat.id, this_file)
    document.caption = this_file
    discard await bot.send(document)
  result = cb

let bot = newTeleBot(API_KEY)
bot.onUpdate(handleUpdate(bot))
bot.poll(666)

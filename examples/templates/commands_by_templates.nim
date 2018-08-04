import asyncdispatch, httpclient, logging, options, strutils, os
import telebot

const API_KEY = ""  # Add your API Key here.


template handlerizer(body: untyped): untyped =
  proc cb(e: Command) {.async.} =
    body
    var msg = newMessage(e.message.chat.id, text_message)
    msg.disableNotification = true
    msg.parseMode = "markdown"
    discard bot.send(msg)
  result = cb

template handlerizerPhoto(body: untyped): untyped =
  proc cb(e: Command) {.async.} =
    body
    var msg = newPhoto(e.message.chat.id, photo_path)
    msg.caption = photo_caption
    msg.disableNotification = true
    discard await bot.send(msg)
  result = cb

template handlerizerLocation(body: untyped): untyped =
  proc cb(e: Command) {.async.} =
    body
    let
      geo_uri = "*GEO URI:* geo:$1,$2    ".format(latitud, longitud)
      osm_url = "*OSM URL:* https://www.openstreetmap.org/?mlat=$1&mlon=$2".format(latitud, longitud)
    var
      msg = newMessage(e.message.chat.id,  geo_uri & osm_url)
      geo_msg = newLocation(e.message.chat.id, longitud, latitud)
    msg.disableNotification = true
    geo_msg.disableNotification = true
    msg.parseMode = "markdown"
    discard bot.send(geo_msg)
    discard bot.send(msg)
  result = cb

template handlerizerDocument(body: untyped): untyped =
  proc cb(e: Command) {.async.} =
    body
    var document = newDocument(e.message.chat.id, document_file_path)
    document.caption = document_caption.strip
    document.disableNotification = true
    discard await bot.send(document)
  result = cb


proc textHandler(bot: Telebot): CommandCallback =
  handlerizer():
    var text_message = "This is my _message_, with *Markdown*, Emoji 👻 and `code`."

proc photoHandler(bot: Telebot): CommandCallback =
  let my_photo_file_path = "file://" & getCurrentDir() & "/sample.jpg"
  handlerizerPhoto():
    let
      photo_path = my_photo_file_path
      photo_caption = "This is my photo caption."

proc locationHandler(bot: Telebot): CommandCallback =
  handlerizerLocation():
    let
      latitud = 55.5
      longitud = 42.0

proc documentHandler(bot: Telebot): CommandCallback =
  let this_file = "file://" & getCurrentDir() & "/commands_by_templates.nim"
  handlerizerDocument():
    let
      document_file_path = this_file
      document_caption = "This is my document caption."


let bot = newTeleBot(API_KEY)                    # Commands:
bot.onCommand("text", textHandler(bot))          # /text
bot.onCommand("photo", photoHandler(bot))        # /photo
bot.onCommand("location", locationHandler(bot))  # /location
bot.onCommand("document", documentHandler(bot))  # /document
bot.poll(666)

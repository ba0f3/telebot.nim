# This Bot receives any Document file, responds on chat with file metadata and file contents.
import telebot, asyncdispatch, options, strformat, httpclient, json
from strutils import strip


const API_KEY = slurp("../secret.key").strip()


proc buildFile(file_id: string) =
  let
    metadata_url = fmt"https://api.telegram.org/bot{API_KEY}/getFile?file_id={file_id}"
    body = await newAsyncHttpClient().getContent(metadata_url) # file_id > file_path
    file_path = parseJson(body)["result"]["file_path"].getStr()
    download_url = fmt"https://api.telegram.org/file/bot{API_KEY}/{file_path}"


proc updateHandler(bot: TeleBot, e: Update): Future[bool] {.async.} =
  let
    url_getfile = fmt"https://api.telegram.org/bot{API_KEY}/getFile?file_id="
    api_file = fmt"https://api.telegram.org/file/bot{API_KEY}/"

  if not e.message:
    return true
  var response = e.message.get
  if response.document.isSome:
    let
      document = response.document.get
      file_name = document.file_name.get
      mime_type = document.mime_type.get
      file_id = document.file_id
      file_size = document.file_size.get
      responz_body = await newAsyncHttpClient().getContent(url_getfile & file_id) # file_id > file_path
      file_path = parseJson(responz_body)["result"]["file_path"].getStr()
      responx = await newAsyncHttpClient().get(api_file & file_path)  # file_path > file
      file_content = await responx.body
      msg0_text = fmt"file_name: {file_name}, mime_type: {mime_type}, file_id: {file_id}, file_size: {file_size}, file_path: {file_path}"

    discard await bot.sendMessage(response.chat.id, msg0_text)
    discard await bot.sendMessage(response.chat.id, file_content)

let bot = newTeleBot(API_KEY)

bot.onUpdate(updateHandler)
bot.poll(timeout=666)

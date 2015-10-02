import asyncdispatch

proc makeRequestAsync(endpoint: string, data: MultipartData = nil): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  let r = await client.post(endpoint, multipart=data)
  if r.status.startsWith("200"):
    var obj = parseJson(r.body)
    if obj["ok"].bval == true:
      result = obj["result"]
  else:
    raise newException(IOError, r.status)
  client.close()

proc getMeAsync*(b: TeleBot): Future[User] {.async.} =
  ## Returns basic information about the bot in form of a ``User`` object.
  let endpoint  = API_URL % [b.token, "getMe"]
  let res = await makeRequestAsync(endpoint)
  result = parseUser(res)

proc sendMessageAsync*(b: TeleBot, chatId: int, text: string, disableWebPagePreview = false, replyToMessageId = 0, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  let endpoint = API_URL % [b.token, "sendMessage"]
  var data = newMultipartData()
  data["chat_id"] = $chatId
  data["text"] = text
  if disableWebPagePreview:
    data["disable_web_page_preview"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if not replyMarkup.isNil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequestAsync(endpoint, data)
  result = parseMessage(res)

proc forwardMessageAsync*(b: TeleBot, chatId: int, fromChatId: int, messageId: int): Future[Message] {.async.} =
  let endpoint = API_URL % [b.token, "forwardMessage"]
  var data = newMultipartData()
  data["chat_id"] = $chatId
  data["from_chat_id"] = $fromChatId
  data["message_id"] = $messageId

  let res = await makeRequestAsync(endpoint, data)
  result = parseMessage(res)

proc sendFileAsync(b: TeleBot, m: string, chatId: int, key, val: string, resend = false, rtmId = 0, rM: KeyboardMarkup = nil): Future[Message] {.async.} =
  let endpoint = API_URL % [b.token, m]

  var data = newMultipartData()
  data["chat_id"] = $chatId

  if resend:
    data[key] = val
  else:
    if val.startsWith("http"):
      let u = parseUri(val)
      var (_, _, ext) = u.path.splitFile()
      let tmp = mktemp(suffix=ext)
      downloadFile(val, tmp)
      data.addFiles({key: tmp})
      tmp.removeFile
    else:
      data.addFiles({key: val})

  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not rM.isNil:
    data["reply_markup"] = $rM

  let res = await makeRequestAsync(endpoint, data)
  result = parseMessage(res)

proc sendPhotoAsync*(b: TeleBot, chatId: int, photo: string, resend = false, cap = "", rtmId = 0, rM: KeyboardMarkup = nil): Future[Message] {.async.} =
  result = await b.sendFileAsync("sendPhoto", chatId, "photo", photo, resend, rtmId, rM)

proc sendAudioAsync*(b: TeleBot, chatId: int, audio: string, resend = false, rtmId = 0, rM: KeyboardMarkup = nil): Future[Message] {.async.} =
  result = await b.sendFileAsync("sendAudio", chatId, "audio", audio, resend, rtmId, rM)

proc sendDocumentAsync*(b: TeleBot, chatId: int, document: string, resend = false, rtmId = 0, rM: KeyboardMarkup = nil): Future[Message] {.async.} =
  result = await b.sendFileAsync("sendDocument", chatId, "document", document, resend, rtmId, rM)

proc sendStickerAsync*(b: TeleBot, chatId: int, sticker: string, resend = false, rtmId = 0, rM: KeyboardMarkup = nil): Future[Message] {.async.} =
  result = await b.sendFileAsync("sendSticker", chatId, "sticker", sticker, resend, rtmId, rM)

proc sendVideoAsync*(b: TeleBot, chatId: int, video: string, resend = false, rtmId = 0, rM: KeyboardMarkup = nil): Future[Message] {.async.} =
  result = await b.sendFileAsync("sendVideo", chatId, "video", video, resend, rtmId, rM)

proc sendLocationAsync*(b: TeleBot, chatId: int, lat, long: float, rtmId = 0, rM: KeyboardMarkup = nil): Future[Message] {.async.} =
  let endpoint = API_URL % [b.token, "sendLocation"]

  var data = newMultipartData()
  data["chat_id"] = $chatId
  data["longitude"] = $long
  data["latitude"] = $lat

  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not rM.isNil:
    data["reply_markup"] = $rM

  let res = await makeRequestAsync(endpoint, data)
  result = parseMessage(res)

proc sendChatActionAsync*(b: TeleBot, chatId: int, action: string): Future[void] {.async.} =
  let endpoint = API_URL % [b.token, "sendChatAction"]
  var data = newMultipartData()
  data["chat_id"] = $chatId
  data["action"] = action

  discard makeRequestAsync(endpoint, data)

proc getUserProfilePhotosAsync*(b: TeleBot, userId: int, offset = 0, limit = 100): Future[UserProfilePhotos] {.async.} =
  let endpoint = API_URL % [b.token, "getUserProfilePhotos"]
  var data = newMultipartData()
  data["user_id"] = $userId
  data["limit"] = $limit

  if offset != 0:
    data["offset"] = $offset
  let res = await makeRequestAsync(endpoint, data)
  result = parseUserProfilePhotos(res)

proc getUpdatesAsync*(b: TeleBot, offset, limit, timeout = 0): Future[seq[Update]] {.async.} =
  let endpoint = API_URL % [b.token, "getUpdates"]
  var data = newMultipartData()

  if offset != 0:
    data["offset"] = $offset
  else:
    data["offset"] = $(b.lastUpdateId+1)
  if limit != 0:
    data["limit"] = $limit
  if timeout != 0:
    data["timeout"] = $timeout

  let res = await makeRequestAsync(endpoint, data)
  result = parseUpdates(b, res)

proc setWebhookAsync*(b: TeleBot, url: string) {.async.} =
  let endpoint = API_URL % [b.token, "setWebhook"]
  var data = newMultipartData()
  data["url"] = url

  discard await makeRequestAsync(endpoint, data)

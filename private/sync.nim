proc makeRequest(endpoint: string, data: MultipartData = nil): JsonNode =
  let body = postContent(endpoint, multipart=data)
  let obj = parseJson(body)
  if obj["ok"].bval == true:
    result = obj["result"]

proc getMe*(b: Telebot): User =
  let endpoint  = API_URL % [b.token, "getMe"]
  let body = makeRequest(endpoint)
  result = parseUser(body)

proc sendMessage*(b: TeleBot, chatId: int, text: string, disableWebPagePreview = false, replyToMessageId = 0, replyMarkup: KeyboardMarkup = nil): Message =
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

  let res = makeRequest(endpoint, data)
  result = parseMessage(res)

proc forwardMessage*(b: TeleBot, chatId: int, fromChatId: int, messageId: int): Message=
  let endpoint = API_URL % [b.token, "forwardMessage"]
  var data = newMultipartData()
  data["chat_id"] = $chatId
  data["from_chat_id"] = $fromChatId
  data["message_id"] = $messageId

  let res = makeRequest(endpoint, data)
  result = parseMessage(res)

proc sendFile(b: TeleBot, m: string, chatId: int, key, val: string, resend = false, rtmId = 0, rM: KeyboardMarkup = nil): Message=
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

  let res = makeRequest(endpoint, data)
  result = parseMessage(res)

proc sendPhoto*(b: TeleBot, chatId: int, photo: string, resend = false, cap = "", rtmId = 0, rM: KeyboardMarkup = nil): Message=
  result = b.sendFile("sendPhoto", chatId, "photo", photo, resend, rtmId, rM)

proc sendAudio*(b: TeleBot, chatId: int, audio: string, resend = false, rtmId = 0, rM: KeyboardMarkup = nil): Message=
  result = b.sendFile("sendAudio", chatId, "audio", audio, resend, rtmId, rM)

proc sendDocument*(b: TeleBot, chatId: int, document: string, resend = false, rtmId = 0, rM: KeyboardMarkup = nil): Message=
  result = b.sendFile("sendDocument", chatId, "document", document, resend, rtmId, rM)

proc sendSticker*(b: TeleBot, chatId: int, sticker: string, resend = false, rtmId = 0, rM: KeyboardMarkup = nil): Message =
  result = b.sendFile("sendSticker", chatId, "sticker", sticker, resend, rtmId, rM)

proc sendVideo*(b: TeleBot, chatId: int, video: string, resend = false, rtmId = 0, rM: KeyboardMarkup = nil): Message=
  result = b.sendFile("sendVideo", chatId, "video", video, resend, rtmId, rM)

proc sendLocation*(b: TeleBot, chatId: int, lat, long: float, rtmId = 0, rM: KeyboardMarkup = nil): Message=
  let endpoint = API_URL % [b.token, "sendLocation"]

  var data = newMultipartData()
  data["chat_id"] = $chatId
  data["longitude"] = $long
  data["latitude"] = $lat

  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not rM.isNil:
    data["reply_markup"] = $rM

  let res = makeRequest(endpoint, data)
  result = parseMessage(res)

proc sendChatAction*(b: TeleBot, chatId: int, action: string)  =
  let endpoint = API_URL % [b.token, "sendChatAction"]
  var data = newMultipartData()
  data["chat_id"] = $chatId
  data["action"] = action

  discard makeRequest(endpoint, data)

proc getUserProfilePhotos*(b: TeleBot, userId: int, offset = 0, limit = 100): UserProfilePhotos =
  let endpoint = API_URL % [b.token, "getUserProfilePhotos"]
  var data = newMultipartData()
  data["user_id"] = $userId
  data["limit"] = $limit

  if offset != 0:
    data["offset"] = $offset
  let res = makeRequest(endpoint, data)
  result = parseUserProfilePhotos(res)

proc getUpdates*(b: TeleBot, offset, limit, timeout = 0): seq[Update] =
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

  let res = makeRequest(endpoint, data)
  result = parseUpdates(b, res)

proc setWebhook*(b: TeleBot, url: string) =
  let endpoint = API_URL % [b.token, "setWebhook"]
  var data = newMultipartData()
  data["url"] = url

  discard makeRequest(endpoint, data)

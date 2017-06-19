import asyncdispatch, common, utils, strutils


type
  BaseMessage  = object
    chatId*: int


proc getMe*(b: TeleBot): Future[User] {.async.} =
  ## Returns basic information about the bot in form of a ``User`` object.
  END_POINT("getMe")
  let res = await makeRequest(endpoint % b.token)
  result = getUser(res)

proc sendMessage*(b: TeleBot, chatId, text: string, disableWebPagePreview = false, disableNotification = false, replyToMessageId = 0, replyMarkup: string = nil, parseMode: string = nil): Future[Message] {.async.} =
  END_POINT("sendMessage")
  var
    data = newMultipartData()
    retry = retry
  data["chat_id"] = chatId
  data["text"] = text
  if disableWebPagePreview:
    data["disable_web_page_preview"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if not replyMarkup.isNilOrEmpty:
    data["reply_markup"] = replyMarkup
  if not parseMode.isNilOrEmpty:
    data["parse_mode"] = parseMode

  try:
    let res = await makeRequest(endpoint % b.token, data)
    result = getMessage(res)
    break
  except:
    echo "Got exception ", repr(getCurrentException()), " with message: ", getCurrentExceptionMsg()

proc forwardMessage*(b: TeleBot, chatId, fromChatId: string, messageId: int, disableNotification = false): Future[Message] {.async.} =
  END_POINT("forwardMessage")
  var data = newMultipartData()

  data["chat_id"] = chatId
  data["from_chat_id"] = fromChatId
  data["message_id"] = $messageId

  if disableNotification:
    data["disable_notification"] = "true"

  let res = await makeRequest(endpoint % b.token, data)
  result = getMessage(res)

proc sendPhoto*(b: TeleBot, chatId: string, inputFile, fileIdOrUrl, caption = "", disableNotification = false, rtmId = 0, replyMarkup: string = nil): Future[Message] {.async.} =
  END_POINT("sendPhoto")
  var data = newMultiPartData()
  data["chat_id"] = chatId
  if not inputFile.isNilOrEmpty:
    data.addFiles({"photo": inputFile})
  else:
    data["photo"] = fileIdOrUrl
  if not caption.isNilOrEmpty:
    data["caption"] = caption
  if disableNotification:
    data["disable_notification"] = "true"
  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not replyMarkup.isNilOrEmpty:
      data["reply_markup"] = replyMarkup

  let res = await makeRequest(endpoint % b.token, data)
  result = getMessage(res)


proc sendAudio*(b: TeleBot, chatId: string, inputFile, fileIdOrUrl, caption = "", duration = 0, performer = "", title = "", disableNotification = false, rtmId = 0, replyMarkup: string = nil): Future[Message] {.async.} =
  END_POINT("sendAudio")
  var data = newMultiPartData()
  data["chat_id"] = chatId
  if not inputFile.isNilOrEmpty:
    data.addFiles({"audio": inputFile})
  else:
    data["audio"] = fileIdOrUrl
  if not caption.isNilOrEmpty:
    data["caption"] = caption
  if duration > 0:
    data["duration"] = $duration
  if not performer.isNilOrEmpty:
    data["performer"] = performer
  if not title.isNilOrEmpty:
    data["title"] = title
  if disableNotification:
    data["disable_notification"] = "true"
  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not replyMarkup.isNilOrEmpty:
      data["reply_markup"] = replyMarkup

  let res = await makeRequest(endpoint % b.token, data)
  result = getMessage(res)

proc sendDocument*(b: TeleBot, chatId: string, inputFile, fileIdOrUrl, caption = "", disableNotification = false, rtmId = 0, replyMarkup: string = nil): Future[Message] {.async.} =
  END_POINT("sendDocument")
  var data = newMultiPartData()
  data["chat_id"] = chatId
  if not inputFile.isNilOrEmpty:
    data.addFiles({"document": inputFile})
  else:
    data["document"] = fileIdOrUrl
  if not caption.isNilOrEmpty:
    data["caption"] = caption
  if disableNotification:
    data["disable_notification"] = "true"
  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not replyMarkup.isNilOrEmpty:
      data["reply_markup"] = replyMarkup

  let res = await makeRequest(endpoint % b.token, data)
  result = getMessage(res)

proc sendSticker*(b: TeleBot, chatId: string, inputFile, fileIdOrUrl = "", disableNotification = false, rtmId = 0, replyMarkup: string = nil): Future[Message] {.async.} =
  END_POINT("sendSticker")
  var data = newMultiPartData()
  data["chat_id"] = chatId
  if not inputFile.isNilOrEmpty:
    data.addFiles({"sticker": inputFile})
  else:
    data["sticker"] = fileIdOrUrl
  if disableNotification:
    data["disable_notification"] = "true"
  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not replyMarkup.isNilOrEmpty:
      data["reply_markup"] = replyMarkup

  let res = await makeRequest(endpoint % b.token, data)
  result = getMessage(res)

proc sendVideo*(b: TeleBot, chatId: string, inputFile, fileIdOrUrl = "", duration, width, height = 0, caption = "", disableNotification = false, rtmId = 0, replyMarkup: string = nil): Future[Message] {.async.} =
  END_POINT("sendVideo")
  var data = newMultiPartData()
  data["chat_id"] = chatId
  if not inputFile.isNilOrEmpty:
    data.addFiles({"video": inputFile})
  else:
    data["video"] = fileIdOrUrl
  if not caption.isNilOrEmpty:
    data["caption"] = caption
  if duration > 0:
    data["duration"] = $duration
  if width > 0:
    data["width"] = $width
  if height > 0:
    data["height"] = $height
  if disableNotification:
    data["disable_notification"] = "true"
  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not replyMarkup.isNilOrEmpty:
      data["reply_markup"] = replyMarkup

  let res = await makeRequest(endpoint % b.token, data)
  result = getMessage(res)

proc sendVoice*(b: TeleBot, chatId: string, inputFile, fileIdOrUrl, caption = "", duration = 0, disableNotification = false, rtmId = 0, replyMarkup: string = nil): Future[Message] {.async.} =
  END_POINT("sendVoice")
  var data = newMultiPartData()
  data["chat_id"] = chatId
  if not inputFile.isNilOrEmpty:
    data.addFiles({"voice": inputFile})
  else:
    data["voice"] = fileIdOrUrl
  if not caption.isNilOrEmpty:
    data["caption"] = caption
  if duration > 0:
    data["duration"] = $duration
  if disableNotification:
    data["disable_notification"] = "true"
  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not replyMarkup.isNilOrEmpty:
      data["reply_markup"] = replyMarkup

  let res = await makeRequest(endpoint % b.token, data)
  result = getMessage(res)

proc sendVideoNote*(b: TeleBot, chatId: string, inputFile, fileIdOrUrl = "", duration, width, height = 0, disableNotification = false, rtmId = 0, replyMarkup: string = nil): Future[Message] {.async.} =
  END_POINT("sendVideoNote")
  var data = newMultiPartData()
  data["chat_id"] = chatId
  if not inputFile.isNilOrEmpty:
    data.addFiles({"video_note": inputFile})
  else:
    data["video_note"] = fileIdOrUrl
  if duration > 0:
    data["duration"] = $duration
  if width > 0:
    data["width"] = $width
  if height > 0:
    data["height"] = $height
  if disableNotification:
    data["disable_notification"] = "true"
  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not replyMarkup.isNilOrEmpty:
      data["reply_markup"] = replyMarkup

  let res = await makeRequest(endpoint % b.token, data)
  result = getMessage(res)

proc sendLocation*(b: TeleBot, chatId: string, lat, long: float, disableNotification = false, rtmId = 0, replyMarkup: string = nil): Future[Message] {.async.} =
  END_POINT("sendLocation")

  var data = newMultipartData()
  data["chat_id"] = chatId
  data["longitude"] = $long
  data["latitude"] = $lat
  if disableNotification:
    data["disable_notification"] = "true"
  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not replyMarkup.isNil:
    data["reply_markup"] = replyMarkup

  let res = await makeRequest(endpoint % b.token, data)
  result = getMessage(res)

proc sendVenue*(b: TeleBot, chatId: string, lat, long: float, title, address: string, foursquareId = "", disableNotification = false, rtmId = 0, replyMarkup: string = nil): Future[Message] {.async.} =
  END_POINT("sendVenue")

  var data = newMultipartData()
  data["chat_id"] = chatId
  data["longitude"] = $long
  data["latitude"] = $lat
  data["title"] = title
  data["address"] = address
  if not foursquareId.isNilOrEmpty:
    data["foursquare_id"] = foursquareId
  if disableNotification:
    data["disable_notification"] = "true"
  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not replyMarkup.isNil:
    data["reply_markup"] = replyMarkup

  let res = await makeRequest(endpoint % b.token, data)
  result = getMessage(res)

proc sendContact*(b: TeleBot, chatId: string, phoneNumber, firstName: string, lastName = "", disableNotification = false, rtmId = 0, replyMarkup: string = nil): Future[Message] {.async.} =
  END_POINT("sendVenue")

  var data = newMultipartData()
  data["chat_id"] = chatId
  data["phone_number"] = phoneNumber
  data["first_name"] = firstName
  if not lastName.isNilOrEmpty:
    data["last_name"] = lastName
  if disableNotification:
    data["disable_notification"] = "true"
  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not replyMarkup.isNil:
    data["reply_markup"] = replyMarkup

  let res = await makeRequest(endpoint % b.token, data)
  result = getMessage(res)

proc sendChatAction*(b: TeleBot, chatId, action: string): Future[void] {.async.} =
  END_POINT("sendChatAction")
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["action"] = action

  discard makeRequest(endpoint % b.token, data)

proc getUserProfilePhotos*(b: TeleBot, userId: int, offset = 0, limit = 100): Future[UserProfilePhotos] {.async.} =
  END_POINT("getUserProfilePhotos")
  var data = newMultipartData()
  data["user_id"] = $userId
  data["limit"] = $limit

  if offset != 0:
    data["offset"] = $offset
  let res = await makeRequest(endpoint % b.token, data)
  result = getUserProfilePhotos(res)

proc getFile*(b: TeleBot, fileId: string): Future[types.File] {.async.} =
  END_POINT("getFile")
  var data = newMultipartData()
  data["file_id"] = fileId
  let res = await makeRequest(endpoint % b.token, data)
  result = getFile(res)

proc kickChatMember*(b: TeleBot, chatId: string, userId: int): Future[bool] {.async.} =
  END_POINT("kickChatMember")
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  let res = await makeRequest(endpoint % b.token, data)
  result = res.bval

proc unbanChatMember*(b: TeleBot, chatId: string, userId: int): Future[bool] {.async.} =
  END_POINT("unbanChatMember")
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  let res = await makeRequest(endpoint % b.token, data)
  result = res.bval

proc leaveChat*(b: TeleBot, chatId: string): Future[bool] {.async.} =
  END_POINT("leaveChat")
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(endpoint % b.token, data)
  result = res.bval

proc getChat*(b: TeleBot, chatId: string): Future[Chat] {.async.} =
  END_POINT("getChat")
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(endpoint % b.token, data)
  result = getChat(res)

proc getChatAdministrators*(b: TeleBot, chatId: string): Future[seq[ChatMember]] {.async.} =
  END_POINT("getChatAdministrators")
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(endpoint % b.token, data)
  result = @[]
  for m in res:
    result.add(m.getChatMember())

proc getChatMemberCount*(b: TeleBot, chatId: string): Future[int] {.async.} =
  END_POINT("getChatMemberCount")
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(endpoint % b.token, data)
  result = res.num.int

proc getChatMEMBER*(b: TeleBot, chatId: string, userId: int): Future[ChatMember] {.async.} =
  END_POINT("getChatMember")
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  let res = await makeRequest(endpoint % b.token, data)
  result = getChatMember(res)

proc answerCallbackQuery*(b: TeleBot, callbackQueryId: string, text = "", showAlert = false, url = "",  cacheTime = 0): Future[bool] {.async.} =
  END_POINT("answerCallbackQuery")
  var data = newMultipartData()
  data["callback_query_id"] = callbackQueryId
  if not text.isNilOrEmpty:
    data["text"] = text
  if showAlert:
    data["show_alert"] = "true"
  if not url.isNilOrEmpty:
    data["url"] = url
  if cacheTime > 0:
    data["cache_time"] = $cacheTime

  let res = await makeRequest(endpoint % b.token, data)
  result = res.bval

proc getUpdates*(b: TeleBot, offset, limit, timeout = 0, allowedUpdates: seq[string] = nil): Future[seq[Update]] {.async.} =
  END_POINT("getUpdates")
  var data = newMultipartData()

  if offset != 0:
    data["offset"] = $offset
  else:
    data["offset"] = $(b.lastUpdateId+1)
  if limit != 0:
    data["limit"] = $limit
  if timeout != 0:
    data["timeout"] = $timeout
  if allowedUpdates != nil:
    data["allowed_updates"] = $allowedUpdates

  let res = await makeRequest(endpoint % b.token, data)
  result = processUpdates(b, res)

import asyncdispatch, common, utils, strutils, logging

magic Message:
  chatId: int
  text: string
  parseMode: string {.optional.}
  disableWebPagePreview: bool {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: string {.optional.}


magic Photo:
  chatId: int
  photo: string
  caption: string {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: string {.optional.}

magic Audio:
  chatId: int
  audio: string
  caption: string {.optional.}
  duration: int {.optional.}
  performer: string {.optional.}
  title: string {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: string {.optional.}

magic Document:
  chatId: int
  document: string
  caption: string {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: string {.optional.}

magic Sticker:
  chatId: int
  sticker: string
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: string {.optional.}
  
magic Video:
  chatId: int
  video: string
  duration: int {.optional.}
  width: int {.optional.}
  height: int {.optional.}
  caption: string {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: string {.optional.}

magic Voice:
  chatId: int
  voice: string
  caption: string {.optional.}
  duration: int {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: string {.optional.}

magic VideoNote:
  chatId: int
  videoNote: string
  duration: int {.optional.}
  length: int {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: string {.optional.}

magic Location:
  chatId: int
  latitude: int
  longitude: int
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: string {.optional.}

magic Venue:
  chatId: int
  latitude: int
  longitude: int
  title: string
  address: string
  foursquareId: string {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: string {.optional.}

magic Contact:
  chatId: int
  phoneNumber: string
  firstName: string
  lastName: string {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: string {.optional.}
  
proc getMe*(b: TeleBot): Future[User] {.async.} =
  ## Returns basic information about the bot in form of a ``User`` object.
  END_POINT("getMe")
  let res = await makeRequest(endpoint % b.token)
  result = unmarshal(res, User)

  
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
  result = unmarshal(res, UserProfilePhotos)

proc getFile*(b: TeleBot, fileId: string): Future[types.File] {.async.} =
  END_POINT("getFile")
  var data = newMultipartData()
  data["file_id"] = fileId
  let res = await makeRequest(endpoint % b.token, data)
  result = unmarshal(res, types.File)

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
  result = unmarshal(res, Chat)

proc getChatAdministrators*(b: TeleBot, chatId: string): Future[seq[ChatMember]] {.async.} =
  END_POINT("getChatAdministrators")
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(endpoint % b.token, data)
  result = @[]
  for m in res:
    result.add(unmarshal(m, ChatMember))

proc getChatMemberCount*(b: TeleBot, chatId: string): Future[int] {.async.} =
  END_POINT("getChatMemberCount")
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(endpoint % b.token, data)
  result = res.num.int

proc getChatMember*(b: TeleBot, chatId: string, userId: int): Future[ChatMember] {.async.} =
  END_POINT("getChatMember")
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  let res = await makeRequest(endpoint % b.token, data)
  result = unmarshal(res, ChatMember)

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

  if offset > 0:
    data["offset"] = $offset
  elif b.lastUpdateId > 0:
    data["offset"] = $(b.lastUpdateId+1)
  if limit > 0:
    data["limit"] = $limit
  if timeout > 0:
    data["timeout"] = $timeout
  if allowedUpdates != nil:
    data["allowed_updates"] = $allowedUpdates

  let res = await makeRequest(endpoint % b.token, data)
  result = @[]
  for item in res.items:
    var update = unmarshal(item, Update)
    if update.updateId > b.lastUpdateId:
      b.lastUpdateId = update.updateId
    result.add(update)

proc answerInlineQuery*[T](b: TeleBot, id: string, results: seq[T], cacheTime = 0, isPersonal = false, nextOffset = "", switchPmText = "", switchPmParameter = ""): Future[bool] {.async.} =
  const endpoint = API_URL & "answerInlineQuery"

  if results.isNil or results.len == 0:
    return false

  var data = newMultipartData()
  d("inline_query_id", id)
  data["inline_query_id"] = id
  var s = ""
  marshal(results, s)
  d("results", s)
  data["results"] = s

  let res = await makeRequest(endpoint % b.token, data)
  result = res.bval

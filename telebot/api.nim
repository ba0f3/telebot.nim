import httpclient, json, asyncdispatch, utils, strutils, options, strtabs

magic Message:
  chatId: int
  text: string
  parseMode: string {.optional.}
  disableWebPagePreview: bool {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Photo:
  chatId: int
  photo: string
  caption: string {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Audio:
  chatId: int
  audio: string
  caption: string {.optional.}
  duration: int {.optional.}
  performer: string {.optional.}
  title: string {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Document:
  chatId: int
  document: string
  caption: string {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Sticker:
  chatId: int
  sticker: string
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Video:
  chatId: int
  video: string
  duration: int {.optional.}
  width: int {.optional.}
  height: int {.optional.}
  caption: string {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Voice:
  chatId: int
  voice: string
  caption: string {.optional.}
  duration: int {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic VideoNote:
  chatId: int
  videoNote: string
  duration: int {.optional.}
  length: int {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Location:
  chatId: int
  latitude: int
  longitude: int
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Venue:
  chatId: int
  latitude: int
  longitude: int
  title: string
  address: string
  foursquareId: string {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Contact:
  chatId: int
  phoneNumber: string
  firstName: string
  lastName: string {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

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

proc kickChatMember*(b: TeleBot, chatId: string, userId: int, untilDate = 0): Future[bool] {.async.} =
  END_POINT("kickChatMember")
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  if untilDate > 0:
    data["until_date"] = $untilDate
  let res = await makeRequest(endpoint % b.token, data)
  result = res.bval

proc unbanChatMember*(b: TeleBot, chatId: string, userId: int): Future[bool] {.async.} =
  END_POINT("unbanChatMember")
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  let res = await makeRequest(endpoint % b.token, data)
  result = res.bval

proc restrictChatMember*(b: TeleBot, chatId: string, userId: int, untilDate = 0, canSendMessages = false, canSendMediaMessages = false, canSendOtherMessages = false, canAddWebPagePreviews = false): Future[bool] {.async.} =
  END_POINT("restrictChatMember")
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  if untilDate > 0:
    data["until_date"] = $untilDate
  if canSendMessages:
    data["can_send_messages"] = "true"
  if canSendMediaMessages:
    data["can_send_media_messages"] = "true"
  if canSendOtherMessages:
    data["can_send_other_messages"] = "true"
  if canAddWebPagePreviews:
    data["can_add_web_page_previews"] = "true"
  let res = await makeRequest(endpoint % b.token, data)
  result = res.bval

proc promoteChatMember*(b: TeleBot, chatId: string, userId: int, canChangeInfo = false, canPostMessages = false, canEditMessages = false, canDeleteMessages = false, canInviteUsers = false, canRestrictMembers = false, canPinMessages = false, canPromoteMebers = false): Future[bool] {.async.} =
  END_POINT("promoteChatMember")
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  if canChangeInfo:
    data["can_change_info"] = "true"
  if canPostMessages:
    data["can_post_messages"] = "true"
  if canEditMessages:
    data["can_edit_messages"] = "true"
  if canDeleteMessages:
    data["can_delete_messages"] = "true"
  if canInviteUsers:
    data["can_invite_users"] = "true"
  if canRestrictMembers:
    data["can_restrict_members"] = "true"
  if canPinMessages:
    data["can_pin_messages"] = "true"
  if canPromoteMebers:
    data["can_promote_members"] = "true"    
  let res = await makeRequest(endpoint % b.token, data)
  result = res.bval

proc exportChatInviteLink*(b: TeleBot, chatId: string): Future[string] {.async.} =
  END_POINT("exportChatInviteLink")
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(endpoint % b.token, data)
  result = res.getStr

proc setChatPhoto*(b: TeleBot, chatId: string, photo: InputFile): Future[bool] {.async.} =
  END_POINT("setChatPhoto")
  var data = newMultipartData()
  data["chat_id"] = chatId
  data.addFiles({"photo": photo})
  let res = await makeRequest(endpoint % b.token, data)
  result = res.bval

proc deleteChatPhoto*(b: TeleBot, chatId: string): Future[bool] {.async.} =
  END_POINT("deleteChatPhoto")
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(endpoint % b.token, data)
  result = res.bval

proc setChatTitle*(b: TeleBot, chatId: string, title: string): Future[bool] {.async.} =
  END_POINT("setChatTitle")
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["title"] = title
  let res = await makeRequest(endpoint % b.token, data)
  result = res.bval  

proc setChatDescription*(b: TeleBot, chatId: string, description = ""): Future[bool] {.async.} =
  END_POINT("setChatDescription")
  var data = newMultipartData()
  data["chat_id"] = chatId
  if description.len > 0:
    data["description"] = description
  let res = await makeRequest(endpoint % b.token, data)
  result = res.bval

proc pinChatMessage*(b: TeleBot, chatId: string, messageId: int, disableNotification = false): Future[bool] {.async.} =
  END_POINT("pinChatMessage")
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["message_id"] = $messageId
  if disableNotification:
    data["disable_notification"] = "true"
  let res = await makeRequest(endpoint % b.token, data)
  result = res.bval  

proc unpinChatMessage*(b: TeleBot, chatId: string): Future[bool] {.async.} =
  END_POINT("unpinChatMessage")
  var data = newMultipartData()
  data["chat_id"] = chatId
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
  if text.len > 0:
    data["text"] = text
  if showAlert:
    data["show_alert"] = "true"
  if url.len > 0:
    data["url"] = url
  if cacheTime > 0:
    data["cache_time"] = $cacheTime

  let res = await makeRequest(endpoint % b.token, data)
  result = res.bval

proc getUpdates*(b: TeleBot, offset, limit, timeout = 0, allowedUpdates: seq[string] = nil): Future[void] {.async.} =
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
  for item in res.items:
    var update = unmarshal(item, Update)
    if update.updateId > b.lastUpdateId:
      b.lastUpdateId = update.updateId
    await b.updateEmitter.emit("update", update)

    if update.hasCommand():
      var userCommands = update.getCommands()
      for key in userCommands.keys():
        var cmd: Command
        cmd.message = update.message.get()
        cmd.params = userCommands[key]
        await b.commandEmitter.emit(key, cmd)


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
  
proc poll*(b: TeleBot, timeout: int32 = 0) =
  while true:
    waitFor b.getUpdates(timeout=timeout)

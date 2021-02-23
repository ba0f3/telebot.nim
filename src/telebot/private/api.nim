import httpclient, sam, asyncdispatch, utils, strutils, options, strtabs
from tables import hasKey, `[]`
import types, keyboard

proc sendMessage*(b: TeleBot, chatId: int64, text: string, parseMode = "", entities: seq[MessageEntity] = @[],
                  disableWebPagePreview = false, disableNotification = false, replyToMessageId = 0,
                  allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data["text"] = text
  if parseMode.len != 0:
    data["parse_mode"] = parseMode
  if entities.len != 0:
    var json = ""
    marshal(entities, json)
    data["entities"] = json
  if disableWebPagePreview:
    data["disable_web_page_preview"]  = "true"
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc sendPhoto*(b: TeleBot, chatId: int64, photo: string, caption = "", parseMode = "",
                captionEntities: seq[MessageEntity] = @[], disableNotification = false, replyToMessageId = 0,
                allowSendingWithoutReply = false,replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data.addData("photo", photo, true)
  if caption.len != 0:
    data["caption"] = caption
  if parseMode.len != 0:
    data["parse_mode"] = parseMode
  if captionEntities.len != 0:
    var json = ""
    marshal(captionEntities, json)
    data["caption_entities"] = json
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc sendAudio*(b: TeleBot, chatId: int64, audio: string, caption = "", parseMode = "", captionEntities: seq[MessageEntity] = @[],
                duration = 0, performer = "", title = "", thumb = "", disableNotification = false, replyToMessageId = 0,
                allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data.addData("audio", audio, true)
  if caption.len != 0:
    data["caption"] = caption
  if parseMode.len != 0:
    data["parse_mode"] = parseMode
  if captionEntities.len != 0:
    var json = ""
    marshal(captionEntities, json)
    data["caption_entities"] = json
  if duration != 0:
    data["duration"] = $duration
  if performer.len != 0:
    data["performer"] = performer
  if title.len != 0:
    data["title"] = title
  if thumb.len != 0:
    data.addData("thumb", thumb, true)
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc sendDocument*(b: TeleBot, chatId: int64, document: string, thumb = "", caption = "",
                   disableContentTypeDetection = false, parseMode = "", captionEntities: seq[MessageEntity] = @[], disableNotification = false,
                   replyToMessageId = 0, allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data.addData("document", document, true)
  if thumb.len != 0:
    data.addData("thumb", thumb, true)
  if caption.len != 0:
    data["caption"] = caption
  if disableContentTypeDetection:
    data["disableContentTypeDetection"] = "true"
  if parseMode.len != 0:
    data["parse_mode"] = parseMode
  if captionEntities.len != 0:
    var json = ""
    marshal(captionEntities, json)
    data["caption_entities"] = json
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc sendSticker*(b: TeleBot, chatId: int64, sticker: string, disableNotification = false, replyToMessageId = 0,
                  allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data.addData("sticker", sticker, true)
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc sendVideo*(b: TeleBot, chatId: int64, video: string, duration = 0, width = 0, height = 0, thumb = "", caption = "",
                parseMode = "", captionEntities: seq[MessageEntity] = @[], supportsStreaming = false, disableNotification = false,
                replyToMessageId = 0, allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data.addData("video", video, true)
  if duration != 0:
    data["duration"] = $duration
  if width != 0:
    data["width"] = $width
  if height != 0:
    data["height"] = $height
  if thumb.len != 0:
    data.addData("thumb", thumb, true)
  if caption.len != 0:
    data["caption"] = caption
  if parseMode.len != 0:
    data["parse_mode"] = parseMode
  if captionEntities.len != 0:
    var json = ""
    marshal(captionEntities, json)
    data["caption_entities"] = json
  if supportsStreaming:
    data["supports_streaming"] = "true"
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc sendVoice*(b: TeleBot, chatId: int64, voice: string, caption = "", parseMode = "", captionEntities: seq[MessageEntity] = @[],
                duration = 0, disableNotification = false, replyToMessageId = 0,
                allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data.addData("voice", voice, true)
  if caption.len != 0:
    data["caption"] = caption
  if parseMode.len != 0:
    data["parse_mode"] = parseMode
  if captionEntities.len != 0:
    var json = ""
    marshal(captionEntities, json)
    data["caption_entities"] = json
  if duration != 0:
    data["duration"] = $duration
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc sendVideoNote*(b: TeleBot, chatId: int64, videoNote: string, duration = 0, length = 0, thumb = "",
                    disableNotification = false, replyToMessageId = 0,
                    allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data.addData("video_note", videoNote, true)
  if duration != 0:
    data["duration"] = $duration
  if length != 0:
    data["length"] = $length
  if thumb.len != 0:
    data.addData("thumb", thumb, true)
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc sendLocation*(b: TeleBot, chatId: int64, latitude: float, longitude: float, livePeriod = 0,
                   heading = 0, proximityAlertRadius = 0, disableNotification = false,
                   replyToMessageId = 0, allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data["latitude"] = $latitude
  data["longitude"] = $longitude
  if livePeriod != 0:
    data["live_period"] = $livePeriod
  if heading != 0:
    data["heading"] = $heading
  if proximityAlertRadius != 0:
    data["proximity_alert_radius"] = $proximityAlertRadius
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc sendVenue*(b: TeleBot, chatId: int64, latitude: float, longitude: float, address: string, foursquareId = "", foursquareType = "",
                googlePlaceId = "", googlePlaceType = "", disableNotification = false, replyToMessageId = 0,
                allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data["latitude"] = $latitude
  data["longitude"] = $longitude
  if address.len != 0:
    data["address"] = address
  if foursquareId.len != 0:
    data["foursquare_id"] = foursquareId
  if foursquareType.len != 0:
    data["foursquare_type"] = foursquareType
  if googlePlaceId.len != 0:
    data["google_place_id"] = googlePlaceId
  if googlePlaceType.len != 0:
    data["google_place_type"] = googlePlaceType
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc sendContact*(b: TeleBot, chatId: int64, phoneNumber: string, firstName: string, lastName = "", vcard = "",
                  disableNotification = false, replyToMessageId = 0,
                  allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data["phone_number"] = phoneNumber
  data["first_name"] = firstName
  if lastName.len != 0:
    data["last_name"] = lastName
  if vcard.len != 0:
    data["vcard"] = vcard
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc sendInvoice*(b: TeleBot, chatId: int64, title: string, description: string, payload: string, providerToken: string, startParameter: string,
                  currency: string, prices: seq[LabeledPrice], providerData = "", photoUrl = "", photoSize = 0, photoWidth = 0, photoHeight = 0,
                  needName = false, needPhoneNumber = false, needEmail = false, needShippingAddress = false, sendPhoneNumberToProvider = false,
                  sendEmailToProvider = false, isFlexible = false,
                  disableNotification = false, replyToMessageId = 0, allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data["title"] = title
  data["description"] = description
  data["payload"] = payload
  data["provider_token"] = providerToken
  data["start_parameter"] = startParameter
  data["currency"] = currency
  var json = ""
  marshal(prices, json)
  data["prices"] = json
  if providerData.len != 0:
    data["provider_data"] = providerData
  if photoUrl.len != 0:
    data["photo_url"] = photoUrl
  if photoSize != 0:
    data["photo_size"] = $photoSize
  if photoWidth != 0:
    data["photo_width"] = $photoWidth
  if photoHeight != 0:
    data["photo_height"] = $photoHeight
  if needName:
    data["need_name"] = "true"
  if needPhoneNumber:
    data["need_phone_number"] = "true"
  if needEmail:
    data["need_email"] = "true"
  if needShippingAddress:
    data["need_shipping_address"] = "true"
  if sendPhoneNumberToProvider:
    data["send_phone_number_to_provider"] = "true"
  if sendEmailToProvider:
    data["send_email_to_provider"] = "true"
  if isFlexible:
    data["is_flexible"] = "true"
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc sendAnimation*(b: TeleBot, chatId: int64, animation: string, duration = 0, width = 0, height = 0, thumb = "",
                   caption = "", parseMode = "", captionEntities: seq[MessageEntity] = @[], disableNotification = false, replyToMessageId = 0,
                   allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data.addData("animation", animation, true)
  if duration != 0:
    data["duration"] = $duration
  if width != 0:
    data["width"] = $width
  if height != 0:
    data["height"] = $height
  if thumb.len != 0:
    data.addData("thumb", thumb, true)
  if caption.len != 0:
    data["caption"] = caption
  if parseMode.len != 0:
    data["parse_mode"] = parseMode
  if captionEntities.len != 0:
    var json = ""
    marshal(captionEntities, json)
    data["caption_entities"] = json
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc sendPoll*(b: TeleBot, chatId: int64, question: string, options: seq[string], isAnonymous = false, kind = "",
               allowsMultipleAnswers = false, correctOptionId = 0, explanation = "", explanationParseMode = "",
               explanationEntities: seq[MessageEntity] = @[], openPeriod = 0, closeDate = 0, isClosed = false, disableNotification = false,
               replyToMessageId = 0, allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data["question"] = question
  data["options"] = $$options
  if isAnonymous:
    data["is_anonymous"] = "true"
  if kind.len != 0:
    data["type"] = kind
  if allowsMultipleAnswers:
    data["allows_multiple_answers"] = "true"
  if correctOptionId != 0:
    data["correct_option_id"] = $correctOptionId
  if explanation.len != 0:
    data["explanation"] = explanation
  if explanationParseMode.len != 0:
    data["explanation_parse_mode"] = explanationParseMode
  if explanationEntities.len != 0:
    var json = ""
    marshal(explanationEntities, json)
    data["explanation_entities"] = json
  if openPeriod != 0:
    data["open_period"] = $openPeriod
  if closeDate != 0:
    data["close_date"] = $closeDate
  if isClosed:
    data["is_closed"] = "true"
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc sendDice*(b: TeleBot, chatId: int64, emoji = "", disableNotification = false, replyToMessageId = 0,
               allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if emoji.len != 0:
    data["emoji"] = emoji
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc getMe*(b: TeleBot): Future[User] {.async.} =
  ## Returns basic information about the bot in form of a ``User`` object.
  let res = await makeRequest(b, procName)
  result = unmarshal(res, User)

proc logOut*(b: TeleBot): Future[bool] {.async.} =
  let res = await makeRequest(b, procName)
  result = unmarshal(res, bool)

proc close*(b: TeleBot): Future[bool] {.async.} =
  let res = await makeRequest(b, procName)
  result = unmarshal(res, bool)

proc forwardMessage*(b: TeleBot, chatId, fromChatId: string, messageId: int, disableNotification = false): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = chatId
  data["from_chat_id"] = fromChatId
  data["message_id"] = $messageId

  if disableNotification:
    data["disable_notification"] = "true"

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc copyMessage*(b: TeleBot, chatId, fromChatId: string, messageId: int, caption = "", parseMode = "",
                  captionEntities: seq[MessageEntity] = @[], disableNotification = false,
                  replyToMessageId = 0, allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[MessageId] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = chatId
  data["from_chat_id"] = fromChatId
  data["message_id"] = $messageId
  if caption.len != 0:
    data["caption"] = caption
  if parseMode.len != 0:
    data["parse_mode"] = parseMode
  if captionEntities.len != 0:
    var json = ""
    marshal(captionEntities, json)
    data["caption_entities"] = json
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = unmarshal(res, MessageId)


proc sendChatAction*(b: TeleBot, chatId, action: string): Future[void] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["action"] = action

  discard makeRequest(b, procName, data)

proc getUserProfilePhotos*(b: TeleBot, userId: int, offset = 0, limit = 100): Future[UserProfilePhotos] {.async.} =
  var data = newMultipartData()
  data["user_id"] = $userId
  data["limit"] = $limit

  if offset != 0:
    data["offset"] = $offset
  let res = await makeRequest(b, procName, data)
  result = unmarshal(res, UserProfilePhotos)

proc getFile*(b: TeleBot, fileId: string): Future[types.File] {.async.} =
  var data = newMultipartData()
  data["file_id"] = fileId
  let res = await makeRequest(b, procName, data)
  result = unmarshal(res, types.File)

proc kickChatMember*(b: TeleBot, chatId: string, userId: int, untilDate = 0): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  if untilDate > 0:
    data["until_date"] = $untilDate
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc unbanChatMember*(b: TeleBot, chatId: string, userId: int, onlyIfBanned = false): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  if onlyIfBanned:
    data["only_if_banned"] = "true"
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc restrictChatMember*(b: TeleBot, chatId: string, userId: int, permissions: ChatPermissions, untilDate = 0): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  var json  = ""
  marshal(permissions, json)
  data["permissions"] = json
  if untilDate > 0:
    data["until_date"] = $untilDate
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc promoteChatMember*(b: TeleBot, chatId: string, userId: int, isAnonymous = false, canChangeInfo = false,
                        canPostMessages = false, canEditMessages = false, canDeleteMessages = false,
                        canInviteUsers = false, canRestrictMembers = false, canPinMessages = false, canPromoteMembers = false): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  if isAnonymous:
    data["is_anonymous"] = "true"
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
  if canPromoteMembers:
    data["can_promote_members"] = "true"
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc setChatPermissions*(b: TeleBot, chatId: string, permissions: ChatPermissions): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  var json  = ""
  marshal(permissions, json)
  data["permissions"] = json
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc exportChatInviteLink*(b: TeleBot, chatId: string): Future[string] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, procName, data)
  result = res.toStr

proc setChatPhoto*(b: TeleBot, chatId: string, photo: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data.addData("photo", photo, true)
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc deleteChatPhoto*(b: TeleBot, chatId: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc setChatTitle*(b: TeleBot, chatId: string, title: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["title"] = title
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc setChatDescription*(b: TeleBot, chatId: string, description = ""): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  if description.len > 0:
    data["description"] = description
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc pinChatMessage*(b: TeleBot, chatId: string, messageId: int, disableNotification = false): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["message_id"] = $messageId
  if disableNotification:
    data["disable_notification"] = "true"
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc unpinChatMessage*(b: TeleBot, chatId: string, messageId = 0): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  if messageId > 0:
    data["message_id"] = $messageId
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc unpinAllChatMessages*(b: TeleBot, chatId: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, procName, data)
  result = res.toBool


proc leaveChat*(b: TeleBot, chatId: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc getChat*(b: TeleBot, chatId: string): Future[Chat] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, procName, data)
  result = unmarshal(res, Chat)

proc getChatAdministrators*(b: TeleBot, chatId: string): Future[seq[ChatMember]] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, procName, data)
  result = @[]
  for m in res:
    result.add(unmarshal(m, ChatMember))

proc getChatMemberCount*(b: TeleBot, chatId: string): Future[int] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, procName, data)
  result = res.toInt

proc getChatMember*(b: TeleBot, chatId: string, userId: int): Future[ChatMember] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  let res = await makeRequest(b, procName, data)
  result = unmarshal(res, ChatMember)

proc getStickerSet*(b: TeleBot, name: string): Future[StickerSet] {.async.} =
  var data = newMultipartData()
  data["name"] = name
  let res = await makeRequest(b, procName, data)
  result = unmarshal(res, StickerSet)

proc uploadStickerFile*(b: TeleBot, userId: int, pngSticker: string): Future[types.File] {.async.} =
  var data = newMultipartData()
  data["user_id"] = $userId
  data.addData("png_sticker", pngSticker, true)
  let res = await makeRequest(b, procName, data)
  result = unmarshal(res, types.File)

proc createNewStickerSet*(b: TeleBot, userId: int, name: string, title: string, pngSticker: string, tgsSticker: string,
                          emojis: string, containsMasks = false, maskPosition: Option[MaskPosition]): Future[bool] {.async.} =
  var data = newMultipartData()
  data["user_id"] = $userId
  data["name"] = name
  data["title"] = title
  if pngSticker.len != 0:
    data.addData("png_sticker", pngSticker, true)
  elif tgsSticker.len != 0:
    data.addData("tgs_sticker", tgsSticker, true)
  else:
    raise newException(ValueError, "Either png_sticker or tgs_sticker must be set")
  data["emojis"] = emojis
  if containsMasks:
    data["contains_masks"] = "true"
  if maskPosition.isSome():
    var tmp = ""
    maskPosition.marshal(tmp)
    data["mask_position"] = tmp
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc addStickerToSet*(b: TeleBot, userId: int, name: string, pngSticker: string, tgsSticker: string, emojis: string, maskPosition: Option[MaskPosition]): Future[bool] {.async.} =
  var data = newMultipartData()
  data["user_id"] = $userId
  data["name"] = name
  if pngSticker.len != 0:
    data.addData("png_sticker", pngSticker, true)
  elif tgsSticker.len != 0:
    data.addData("tgs_sticker", tgsSticker, true)
  else:
    raise newException(ValueError, "Either png_sticker or tgs_sticker must be set")
  data["emojis"] = emojis
  if maskPosition.isSome():
    var tmp = ""
    maskPosition.marshal(tmp)
    data["mask_position"] = tmp
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc setStickerPositionInSet*(b: TeleBot, sticker: string, position: int): Future[bool] {.async.} =
  var data = newMultipartData()
  data["sticker"] = sticker
  data["position"] = $position
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc deleteStickerFromSet*(b: TeleBot, sticker: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["sticker"] = sticker
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc setStickerSetThumb*(b: TeleBot, name: string, userId: int, thumb = ""): Future[bool] {.async.} =
  var data = newMultipartData()
  data["name"] = name
  data["user_id"] = $userId
  if thumb.len != 0:
    data.addData("thumb", thumb, true)

  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc setChatStickerSet*(b: TeleBot, chatId: string, stickerSetname: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["sticker_set_name"] = stickerSetname
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc deleteChatStickerSet*(b: TeleBot, chatId: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc editMessageLiveLocation*(b: TeleBot, latitude: float, longitude: float, chatId = "",
                              messageId = 0, inlineMessageId = "", horizontalAccuracy = 0.0,
                              heading = 0, proximityAlertRadius = 0, replyMarkup: KeyboardMarkup = nil): Future[bool] {.async.} =
  var data = newMultipartData()
  data["latiude"] = $latitude
  data["longitude"] = $longitude
  if chatId.len != 0:
    data["chat_id"] = chat_id
  if messageId != 0:
    data["message_id"] = $messageId
  if inlineMessageId.len != 0:
    data["inline_message_id"] = inlineMessageId
  if horizontalAccuracy != 0.0:
    data["horizontal_accuracy"] = $horizontalAccuracy
  if heading != 0:
    data["heading"] = $heading
  if proximityAlertRadius != 0:
    data["proximity_alert_radius"] = $proximityAlertRadius
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc stopMessageLiveLocation*(b: TeleBot, chatId = "", messageId = 0, inlineMessageId = "", replyMarkup: KeyboardMarkup = nil): Future[bool] {.async.} =
  var data = newMultipartData()
  if chatId.len != 0:
    data["chat_id"] = chat_id
  if messageId != 0:
    data["message_id"] = $messageId
  if inlineMessageId.len != 0:
    data["inline_message_id"] = inlineMessageId
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc sendMediaGroup*(b: TeleBot, chatId: string, media: seq[InputMediaSet], disableNotification = false, allowSendingWithoutReply = false, replyToMessageId = 0): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  for m in media:
    uploadInputMedia(data, m)
  var json  = ""
  marshal(media, json)
  data["media"] = json
  if disableNotification:
    data["disable_notification"] = "true"
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId

  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc editMessageMedia*(b: TeleBot, media: InputMediaSet, chatId = "", messageId = 0, inlineMessageId = "", replyMarkup: KeyboardMarkup = nil): Future[Option[Message]] {.async.} =
  var data = newMultipartData()
  if chatId.len > 0:
    data["chat_id"] = chat_id
  if messageId != 0:
    data["message_id"] = $messageId
  if inlineMessageId.len != 0:
    data["inline_message_id"] = inlineMessageId

  uploadInputMedia(data, media)
  var json  = ""
  marshal(media, json)
  data["media"] = json
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  if res.isPrimitive:
    result = none(Message)
  else:
    result = some(unmarshal(res, Message))

proc editMessageText*(b: TeleBot, text: string, chatId = "", messageId = 0, inlineMessageId = "", parseMode = "", entities: seq[MessageEntity] = @[],
                      replyMarkup: KeyboardMarkup = nil, disableWebPagePreview=false): Future[Option[Message]] {.async.} =
  var data = newMultipartData()
  if chatId.len > 0:
    data["chat_id"] = chat_id
  if messageId != 0:
    data["message_id"] = $messageId
  if inlineMessageId.len != 0:
    data["inline_message_id"] = inlineMessageId
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup
  if parseMode != "":
    data["parse_mode"] = parseMode
  if entities.len != 0:
    var json = ""
    marshal(entities, json)
    data["entities"] = json
  if disableWebPagePreview == true:
    data["disable_web_page_preview"] = "true"

  data["text"] = text

  let res = await makeRequest(b, procName, data)
  if res.isPrimitive:
    result = none(Message)
  else:
    result = some(unmarshal(res, Message))

proc editMessageCaption*(b: TeleBot, caption = "", chatId = "", messageId = 0, inlineMessageId = "", parseMode="",
                         captionEntities: seq[MessageEntity] = @[], replyMarkup: KeyboardMarkup = nil): Future[Option[Message]] {.async.} =
  var data = newMultipartData()
  if chatId.len > 0:
    data["chat_id"] = chat_id
  if messageId != 0:
    data["message_id"] = $messageId
  if inlineMessageId.len != 0:
    data["inline_message_id"] = inlineMessageId
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup
  if parseMode != "":
    data["parse_mode"] = parseMode
  if captionEntities.len != 0:
    var json = ""
    marshal(captionEntities, json)
    data["caption_entities"] = json
  data["caption"] = caption

  let res = await makeRequest(b, procName, data)
  if res.isPrimitive:
    result = none(Message)
  else:
    result = some(unmarshal(res, Message))

proc editMessageReplyMarkup*(b: TeleBot, chatId = "", messageId = 0, inlineMessageId = "", replyMarkup: KeyboardMarkup = nil): Future[Option[Message]] {.async.} =
  var data = newMultipartData()
  if chatId.len > 0:
    data["chat_id"] = chat_id
  if messageId != 0:
    data["message_id"] = $messageId
  if inlineMessageId.len != 0:
    data["inline_message_id"] = inlineMessageId
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  if res.isPrimitive:
    result = none(Message)
  else:
    result = some(unmarshal(res, Message))

proc stopPoll*(b: TeleBot, chatId = "", messageId = 0, inlineMessageId = "", replyMarkup: KeyboardMarkup = nil): Future[Option[Poll]] {.async.} =
  var data = newMultipartData()
  if chatId.len > 0:
    data["chat_id"] = chat_id
  if messageId != 0:
    data["message_id"] = $messageId
  if inlineMessageId.len != 0:
    data["inline_message_id"] = inlineMessageId
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  if res.isPrimitive:
    result = none(Poll)
  else:
    result = some(unmarshal(res, Poll))

proc deleteMessage*(b: Telebot, chatId: string, messageId: int): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chat_id
  data["message_id"] = $messageId

  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc answerCallbackQuery*(b: TeleBot, callbackQueryId: string, text = "", showAlert = false, url = "",  cacheTime = 0): Future[bool] {.async.} =
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

  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc setMyCommands*(b: TeleBot, commands: seq[BotCommand]): Future[bool] {.async.} =
  var data = newMultipartData()
  var json  = ""
  marshal(commands, json)
  data["commands"] = json

  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc getMyCommands*(b: TeleBot): Future[seq[BotCommand]] {.async.} =
  let res = await makeRequest(b, procName)
  result = unmarshal(res, seq[BotCommand])

proc answerInlineQuery*[T](b: TeleBot, id: string, results: seq[T], cacheTime = 0, isPersonal = false, nextOffset = "", switchPmText = "", switchPmParameter = ""): Future[bool] {.async.} =
  const endpoint = API_URL & "answerInlineQuery"
  if results.len == 0:
    return false

  var data = newMultipartData()
  d("inline_query_id", id)
  data["inline_query_id"] = id
  var s = ""
  marshal(results, s)
  d("results", s)
  data["results"] = s
  if cacheTime != 0:
    data["cache_time"] = $cacheTime
  if isPersonal:
    data["is_personal"] = "true"
  if nextOffset.len > 0:
    data["next_offset"] = nextOffset
  if switchPmText.len > 0:
    data["switch_pm_text"] = switchPmText
  if switchPmParameter.len > 0:
    data["switch_pm_parameter"] = switchPmParameter

  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc setChatAdministratorCustomTitle*(b: TeleBot, chatId: string, userId: int, customTitle: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  data["custom_title"] = customTitle
  let res = await makeRequest(b, procName, data)
  result = res.toBool

proc getUpdates*(b: TeleBot, offset, limit = 0, timeout = 50, allowedUpdates: seq[string] = @[]): Future[JsonNode] {.async.} =
  var data = newMultipartData()

  if offset > 0:
    data["offset"] = $offset
  elif b.lastUpdateId > 0:
    data["offset"] = $(b.lastUpdateId+1)
  if limit > 0:
    data["limit"] = $limit
  if timeout > 0:
    data["timeout"] = $timeout
  if allowedUpdates.len > 0:
    data["allowed_updates"] = $allowedUpdates

  result = await makeRequest(b, procName, data)

  if result.len > 0:
    b.lastUpdateId = result[result.len - 1]["update_id"].toInt

proc handleUpdate*(b: TeleBot, update: Update) {.async.} =
  # stop process other callbacks if a callback returns true
  var stop = false
  if update.inlineQuery.isSome:
    for cb in b.inlineQueryCallbacks:
      stop = await cb(b, update.inlineQuery.get)
      if stop: break
  elif update.hasCommand(b.username):
    var cmd = Command(
      command: command,
      message: message,
      params: params
    )
    if b.commandCallbacks.hasKey(command):
      for cb in b.commandCallbacks[command]:
        stop = await cb(b, cmd)
        if stop: break
    elif b.catchallCommandCallback != nil:
      stop = await b.catchallCommandCallback(b, cmd)
  if not stop:
    for cb in b.updateCallbacks:
      stop = await cb(b, update)
      if stop: break

proc cleanUpdates*(b: TeleBot) {.async.} =
  var updates = await b.getUpdates(timeout=0)
  while updates.len >= 100:
    updates = await b.getUpdates()

proc loop(b: TeleBot, timeout = 50, offset, limit = 0) {.async.} =
  try:
    let me = waitFor b.getMe()
    b.id = me.id
    if me.username.isSome:
      b.username = me.username.get().toLowerAscii()
  except IOError, OSError:
    d("Unable to fetch my info ", getCurrentExceptionMsg())

  while true:
    let updates = await b.getUpdates(timeout=timeout, offset=offset, limit=limit)
    for item in updates:
      let update = unmarshal(item, Update)
      asyncCheck b.handleUpdate(update)

proc poll*(b: TeleBot, timeout = 50, offset, limit = 0, clean = false) =
  if clean:
    waitFor b.cleanUpdates()
  waitFor loop(b, timeout, offset, limit)

proc pollAsync*(b: TeleBot, timeout = 50, offset, limit = 0, clean = false) {.async.} =
  if clean:
    await b.cleanUpdates()
  await loop(b, timeout, offset, limit)


proc sendGame*(b: TeleBot, chatId: int, gameShortName: string, disableNotification = false, replyToMessageId = 0,
               allowSendingWithoutReply = false, replyMarkup: InlineKeyboardMarkup): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data["game_short_name"] = gameShortName
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc setGameScore*(b: TeleBot, userId: int, score: int, force = false, disableEditMessage = false,
                   chatId = 0, inlineMessageId = 0): Future[Message] {.async.} =

  var data = newMultipartData()

  data["user_id"] = $chatId
  data["score"] = $score
  if force:
    data["force"] = "true"
  if disableEditMessage:
    data["disable_edit_message"] = "true"
  if chatId != 0:
    data["chat_id"] = $chatId
  if inlineMessageId != 0:
    data["inline_message_id"] = $inlineMessageId
  let res = await makeRequest(b, procName, data)
  result = getMessage(res)

proc getGameHighScores*(b: TeleBot, userId: int, chatId = 0, messageId = 0, inlineMessageId = 0): Future[seq[GameHighScore]] {.async.} =
  var data = newMultipartData()

  data["user_id"] = $chatId
  if chatId != 0:
    data["chat_id"] = $chatId
  if messageId != 0:
    data["message_id"] = $messageId
  if inlineMessageId != 0:
    data["inline_message_id"] = $inlineMessageId
  let res = await makeRequest(b, procName, data)
  result = unmarshal(res, seq[GameHighScore])
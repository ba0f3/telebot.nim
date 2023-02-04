import httpclient, json, asyncdispatch, utils, strutils, options, strtabs
from tables import hasKey, `[]`
import types, keyboard

proc sendMessage*(b: TeleBot, chatId: ChatId, text: string, messageThreadId = 0, parseMode = "", entities: seq[MessageEntity] = @[],
                  disableWebPagePreview = false, disableNotification = false, protectContent = false, replyToMessageId = 0,
                  allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
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
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc sendPhoto*(b: TeleBot, chatId: ChatId, photo: string, messageThreadId = 0, caption = "", parseMode = "",
                captionEntities: seq[MessageEntity] = @[], hasSpoiler = false, disableNotification = false, protectContent = false,
                replyToMessageId = 0, allowSendingWithoutReply = false,replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
  data.addData("photo", photo, true)
  if caption.len != 0:
    data["caption"] = caption
  if parseMode.len != 0:
    data["parse_mode"] = parseMode
  if captionEntities.len != 0:
    var json = ""
    marshal(captionEntities, json)
    data["caption_entities"] = json
  if hasSpoiler:
    data["has_spoiler"] = "true"
  if disableNotification:
    data["disable_notification"] = "true"
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc sendAudio*(b: TeleBot, chatId: ChatId, audio: string, messageThreadId = 0, caption = "", parseMode = "", captionEntities: seq[MessageEntity] = @[],
                duration = 0, performer = "", title = "", thumb = "", disableNotification = false, protectContent = false, replyToMessageId = 0,
                allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
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
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc sendDocument*(b: TeleBot, chatId: ChatId, document: string, messageThreadId = 0, thumb = "", caption = "",
                   disableContentTypeDetection = false, parseMode = "", captionEntities: seq[MessageEntity] = @[], disableNotification = false,
                   protectContent = false, replyToMessageId = 0, allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
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
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc sendSticker*(b: TeleBot, chatId: ChatId, sticker: string, messageThreadId = 0, disableNotification = false, protectContent = false, replyToMessageId = 0,
                  allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
  data.addData("sticker", sticker, true)
  if disableNotification:
    data["disable_notification"] = "true"
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc sendVideo*(b: TeleBot, chatId: ChatId, video: string, messageThreadId = 0, duration = 0, width = 0, height = 0, thumb = "", caption = "",
                parseMode = "", captionEntities: seq[MessageEntity] = @[], hasSpoiler = false, supportsStreaming = false, disableNotification = false,
                protectContent = false, replyToMessageId = 0, allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
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
  if hasSpoiler:
    data["has_spoiler"] = "true"
  if supportsStreaming:
    data["supports_streaming"] = "true"
  if disableNotification:
    data["disable_notification"] = "true"
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc sendVoice*(b: TeleBot, chatId: ChatId, voice: string, messageThreadId = 0, caption = "", parseMode = "", captionEntities: seq[MessageEntity] = @[],
                duration = 0, disableNotification = false, protectContent = false, replyToMessageId = 0,
                allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
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
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc sendVideoNote*(b: TeleBot, chatId: ChatId, videoNote: string, messageThreadId = 0, duration = 0, length = 0, thumb = "",
                    disableNotification = false, protectContent = false, replyToMessageId = 0,
                    allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
  data.addData("video_note", videoNote, true)
  if duration != 0:
    data["duration"] = $duration
  if length != 0:
    data["length"] = $length
  if thumb.len != 0:
    data.addData("thumb", thumb, true)
  if disableNotification:
    data["disable_notification"] = "true"
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc sendLocation*(b: TeleBot, chatId: ChatId, latitude: float, longitude: float, messageThreadId = 0, livePeriod = 0,
                   heading = 0, proximityAlertRadius = 0, disableNotification = false, protectContent = false,
                   replyToMessageId = 0, allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
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
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc sendVenue*(b: TeleBot, chatId: ChatId, latitude: float, longitude: float, address: string,
                messageThreadId = 0, foursquareId = "", foursquareType = "",
                googlePlaceId = "", googlePlaceType = "", disableNotification = false, protectContent = false, replyToMessageId = 0,
                allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
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
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc sendContact*(b: TeleBot, chatId: ChatId, phoneNumber: string, firstName: string, lastName = "", vcard = "",
                  messageThreadId = 0, disableNotification = false, protectContent = false, replyToMessageId = 0,
                  allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
  data["phone_number"] = phoneNumber
  data["first_name"] = firstName
  if lastName.len != 0:
    data["last_name"] = lastName
  if vcard.len != 0:
    data["vcard"] = vcard
  if disableNotification:
    data["disable_notification"] = "true"
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc sendInvoice*(b: TeleBot, chatId: ChatId, title: string, description: string, payload: string, providerToken: string, currency: string,
                  messageThreadId = 0,
                  prices: seq[LabeledPrice], maxTipAmount = 0, suggestedTipAmounts: seq[int] = @[], startParameter = "",
                  providerData = "", photoUrl = "", photoSize = 0, photoWidth = 0, photoHeight = 0,
                  needName = false, needPhoneNumber = false, needEmail = false, needShippingAddress = false, sendPhoneNumberToProvider = false,
                  sendEmailToProvider = false, isFlexible = false, disableNotification = false, protectContent = false, replyToMessageId = 0,
                  allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
  data["title"] = title
  data["description"] = description
  data["payload"] = payload
  data["provider_token"] = providerToken
  data["currency"] = currency
  var json = ""
  marshal(prices, json)
  data["prices"] = json
  if maxTipAmount != 0:
    data["max_tip_amount"] = $maxTipAmount
  if suggestedTipAmounts.len != 0:
    json = ""
    marshal(suggestedTipAmounts, json)
    data["suggested_top_amounts"] = json
  if startParameter.len != 0:
    data["start_parameter"] = startParameter
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
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc createInvoiceLink*(b: TeleBot, title: string, description: string, payload: string, providerToken: string, currency: string, prices: seq[LabeledPrice], maxTipAmount = 0,
                        suggestedTipAmounts: seq[int] = @[], providerData = "", photoUrl = "", photoSize = 0, photoWidth = 0, photoHeight = 0,
                        needName = false, needPhoneNumber = false, needEmail = false, needShippingAddress = false,
                        sendPhoneNumberToProvider = false, sendEmailToProvider = false, isFlexible = false): Future[string] {.async.} =
  var data = newMultipartData()
  data["title"] = title
  data["description"] = description
  data["payload"] = payload
  data["provider_token"] = providerToken
  data["currency"] = currency
  var  json = ""
  marshal(prices, json)
  data["prices"] = json
  data["max_tip_amount"] = $maxTipAmount
  if suggestedTipAmounts.len != 0:
    json = ""
    marshal(suggestedTipAmounts, json)
    data["suggested_top_amounts"] = json
  if providerData.len > 0:
    data["provider_data"] = providerData
  if photoUrl.len > 0:
    data["photo_url"] = photoUrl
  if photoSize > 0:
    data["photo_size"] = $photoSize
  if photoWidth > 0:
    data["photo_width"] = $photoWidth
  if photoHeight > 0:
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

  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getStr


proc sendAnimation*(b: TeleBot, chatId: ChatId, animation: string, messageThreadId = 0, duration = 0, width = 0, height = 0, thumb = "",
                   caption = "", parseMode = "", captionEntities: seq[MessageEntity] = @[], hasSpoiler = false,
                   disableNotification = false, protectContent = false, replyToMessageId = 0,
                   allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
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
  if hasSpoiler:
    data["has_spoiler"] = "true"
  if disableNotification:
    data["disable_notification"] = "true"
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc sendPoll*(b: TeleBot, chatId: ChatId, question: string, options: seq[string], messageThreadId = 0, isAnonymous = false, kind = "",
               allowsMultipleAnswers = false, correctOptionId = 0, explanation = "", explanationParseMode = "",
               explanationEntities: seq[MessageEntity] = @[], openPeriod = 0, closeDate = 0, isClosed = false, disableNotification = false,
               protectContent = false, replyToMessageId = 0, allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
  data["question"] = question
  var tmp = ""
  marshal(options, tmp)
  data["options"] = tmp
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
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc sendDice*(b: TeleBot, chatId: ChatId, messageThreadId = 0, emoji = "", disableNotification = false, protectContent = false, replyToMessageId = 0,
               allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
  if emoji.len != 0:
    data["emoji"] = emoji
  if disableNotification:
    data["disable_notification"] = "true"
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc getMe*(b: TeleBot): Future[User] {.async.} =
  ## Returns basic information about the bot in form of a ``User`` object.
  let res = await makeRequest(b, PROC_NAME)
  result = unmarshal(res, User)

proc logOut*(b: TeleBot): Future[bool] {.async.} =
  let res = await makeRequest(b, PROC_NAME)
  result = unmarshal(res, bool)

proc close*(b: TeleBot): Future[bool] {.async.} =
  let res = await makeRequest(b, PROC_NAME)
  result = unmarshal(res, bool)

proc forwardMessage*(b: TeleBot, chatId, fromChatId: string, messageId: int, messageThreadId = 0, disableNotification = false, protectContent = false): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
  data["from_chat_id"] = fromChatId
  data["message_id"] = $messageId

  if disableNotification:
    data["disable_notification"] = "true"
  if protectContent:
    data["protect_content"] = "true"
  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc copyMessage*(b: TeleBot, chatId, fromChatId: string, messageId: int, messageThreadId = 0, caption = "", parseMode = "",
                  captionEntities: seq[MessageEntity] = @[], disableNotification = false, protectContent = false,
                  replyToMessageId = 0, allowSendingWithoutReply = false, replyMarkup: KeyboardMarkup = nil): Future[MessageId] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
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
  if protectContent:
    data["protect_content"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, MessageId)


proc sendChatAction*(b: TeleBot, chatId: ChatId, action: ChatAction, messageThreadId = 0): Future[void] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
  data["action"] = toLowerAscii($action)

  discard makeRequest(b, PROC_NAME, data)

proc getUserProfilePhotos*(b: TeleBot, userId: int, offset = 0, limit = 100): Future[UserProfilePhotos] {.async.} =
  var data = newMultipartData()
  data["user_id"] = $userId
  data["limit"] = $limit

  if offset != 0:
    data["offset"] = $offset
  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, UserProfilePhotos)

proc getFile*(b: TeleBot, fileId: string): Future[types.File] {.async.} =
  var data = newMultipartData()
  data["file_id"] = fileId
  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, types.File)

proc banChatMember*(b: TeleBot, chatId: string, userId: int, untilDate = 0, revokeMessages = false): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  if untilDate > 0:
    data["until_date"] = $untilDate
  if revokeMessages:
    data["revoke_messages"] = "true"
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool()

proc kickChatMember*(b: TeleBot, chatId: string, userId: int, untilDate = 0, revokeMessages = false): Future[bool] {.async, inline, deprecated: "Use banChatMember instead".} =
  result = await banChatMember(b, chatId, userId, untilDate, revokeMessages)

proc unbanChatMember*(b: TeleBot, chatId: string, userId: int, onlyIfBanned = false): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  if onlyIfBanned:
    data["only_if_banned"] = "true"
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool()

proc restrictChatMember*(b: TeleBot, chatId: string, userId: int, permissions: ChatPermissions, useIndependentChatPermissions = false, untilDate = 0): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  var json  = ""
  marshal(permissions, json)
  data["permissions"] = json
  if useIndependentChatPermissions:
    data["use_independent_chat_permissions"] = "true"
  if untilDate > 0:
    data["until_date"] = $untilDate
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc promoteChatMember*(b: TeleBot, chatId: string, userId: int, isAnonymous = false, canManageChat = false, canChangeInfo = false,
                        canPostMessages = false, canEditMessages = false, canDeleteMessages = false, canManageVideoChats = false,
                        canInviteUsers = false, canRestrictMembers = false, canPinMessages = false, canPromoteMembers = false,
                        canManageTopics = false): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  if isAnonymous:
    data["is_anonymous"] = "true"
  if canManageChat:
    data["can_manage_chat"] = "true"
  if canChangeInfo:
    data["can_change_info"] = "true"
  if canPostMessages:
    data["can_post_messages"] = "true"
  if canEditMessages:
    data["can_edit_messages"] = "true"
  if canDeleteMessages:
    data["can_delete_messages"] = "true"
  if canManageVideoChats:
    data["can_manage_video_chats"] = "true"
  if canInviteUsers:
    data["can_invite_users"] = "true"
  if canRestrictMembers:
    data["can_restrict_members"] = "true"
  if canPinMessages:
    data["can_pin_messages"] = "true"
  if canPromoteMembers:
    data["can_promote_members"] = "true"
  if canManageTopics:
    data["can_manage_topics"] = "true"
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc setChatPermissions*(b: TeleBot, chatId: string, permissions: ChatPermissions, useIndependentChatPermissions = false): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  var json  = ""
  marshal(permissions, json)
  data["permissions"] = json
  if useIndependentChatPermissions:
    data["use_independent_chat_permissions"] = "true"
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc exportChatInviteLink*(b: TeleBot, chatId: string): Future[string] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getStr

proc setChatPhoto*(b: TeleBot, chatId: string, photo: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data.addData("photo", photo, true)
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc deleteChatPhoto*(b: TeleBot, chatId: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc setChatTitle*(b: TeleBot, chatId: string, title: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["title"] = title
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc setChatDescription*(b: TeleBot, chatId: string, description = ""): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  if description.len > 0:
    data["description"] = description
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc pinChatMessage*(b: TeleBot, chatId: string, messageId: int, disableNotification = false): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["message_id"] = $messageId
  if disableNotification:
    data["disable_notification"] = "true"
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc unpinChatMessage*(b: TeleBot, chatId: string, messageId = 0): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  if messageId > 0:
    data["message_id"] = $messageId
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc unpinAllChatMessages*(b: TeleBot, chatId: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool


proc leaveChat*(b: TeleBot, chatId: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc getChat*(b: TeleBot, chatId: string): Future[Chat] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, Chat)

proc getChatAdministrators*(b: TeleBot, chatId: string): Future[seq[ChatMember]] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, PROC_NAME, data)
  result = @[]
  for m in res:
    result.add(unmarshal(m, ChatMember))

proc getChatMemberCount*(b: TeleBot, chatId: string): Future[int] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getInt

proc getChatMembersCount*(b: TeleBot, chatId: string): Future[int] {.async, inline, deprecated: "Use getChatMemberCount instead".} =
  result = await getChatMemberCount(b, chatId)

proc getChatMember*(b: TeleBot, chatId: string, userId: int): Future[ChatMember] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, ChatMember)

proc getStickerSet*(b: TeleBot, name: string): Future[StickerSet] {.async.} =
  var data = newMultipartData()
  data["name"] = name
  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, StickerSet)

proc getCustomEmojiStickers*(b: TeleBot, customEmojiIds: seq[string]): Future[seq[Sticker]] {.async.} =
  var data = newMultipartData()
  data["custom_emoji_ids"] = $customEmojiIds
  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, seq[Sticker])

proc uploadStickerFile*(b: TeleBot, userId: int, pngSticker: string): Future[types.File] {.async.} =
  var data = newMultipartData()
  data["user_id"] = $userId
  data.addData("png_sticker", pngSticker, true)
  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, types.File)

proc createNewStickerSet*(b: TeleBot, userId: int, name, title, emojis: string, pngSticker, tgsSticker, webmSticker, stickerType = "",
                          containsMasks = false, maskPosition: Option[MaskPosition]): Future[bool] {.async.} =
  var data = newMultipartData()
  data["user_id"] = $userId
  data["name"] = name
  data["title"] = title
  data["emojis"] = emojis
  if pngSticker.len != 0:
    data.addData("png_sticker", pngSticker, true)
  elif tgsSticker.len != 0:
    data.addData("tgs_sticker", tgsSticker, true)
  elif webmSticker.len != 0:
    data.addData("webm_sticker", webmSticker, true)
  else:
    raise newException(ValueError, "png_sticker, tgs_sticker or webm_sticker must be set")
  if stickerType.len != 0:
    data["sticker_type"] = stickerType
  if maskPosition.isSome():
    var tmp = ""
    maskPosition.marshal(tmp)
    data["mask_position"] = tmp
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc addStickerToSet*(b: TeleBot, userId: int, name: string, pngSticker, tgsSticker, webmSticker, emojis: string, maskPosition: Option[MaskPosition]): Future[bool] {.async.} =
  var data = newMultipartData()
  data["user_id"] = $userId
  data["name"] = name
  if pngSticker.len != 0:
    data.addData("png_sticker", pngSticker, true)
  elif tgsSticker.len != 0:
    data.addData("tgs_sticker", tgsSticker, true)
  elif webmSticker.len != 0:
    data.addData("webm_sticker", tgsSticker, true)
  else:
    raise newException(ValueError, "png_sticker, tgs_sticker or webm_sticker must be set")
  data["emojis"] = emojis
  if maskPosition.isSome():
    var tmp = ""
    maskPosition.marshal(tmp)
    data["mask_position"] = tmp
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc setStickerPositionInSet*(b: TeleBot, sticker: string, position: int): Future[bool] {.async.} =
  var data = newMultipartData()
  data["sticker"] = sticker
  data["position"] = $position
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc deleteStickerFromSet*(b: TeleBot, sticker: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["sticker"] = sticker
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc setStickerSetThumb*(b: TeleBot, name: string, userId: int, thumb = ""): Future[bool] {.async.} =
  var data = newMultipartData()
  data["name"] = name
  data["user_id"] = $userId
  if thumb.len != 0:
    data.addData("thumb", thumb, true)

  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc setChatStickerSet*(b: TeleBot, chatId: string, stickerSetname: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["sticker_set_name"] = stickerSetname
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc deleteChatStickerSet*(b: TeleBot, chatId: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc getForumTopicIconStickers*(b: TeleBot): Future[seq[Sticker]] {.async.} =
  let res = await makeRequest(b, PROC_NAME)
  result = unmarshal(res, seq[Sticker])

proc createForumTopic*(b: TeleBot, chatId: string, name: string, iconColor = 0, iconCustomEmojiId = ""): Future[ForumTopic] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["name"] = name
  if iconColor > 0:
    data["icon_color"] = $iconColor
  if iconCustomEmojiId.len > 0:
    data["icon_custom_emoji_id"] = iconCustomEmojiId
  let res = await makeRequest(b, PROC_NAME)
  result = unmarshal(res, ForumTopic)

proc editForumTopic*(b: TeleBot, chatId: string, messageThreadId: int, name = "", iconCustomEmojiId = ""): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["message_thread_id"] = $messageThreadId
  if name.len > 0:
    data["name"] = name
  if iconCustomEmojiId.len > 0:
    data["icon_custom_emoji_id"] = iconCustomEmojiId
  let res = await makeRequest(b, PROC_NAME)
  result = unmarshal(res, bool)

proc closeForumTopic*(b: TeleBot, chatId: string, messageThreadId: int): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["message_thread_id"] = $messageThreadId
  let res = await makeRequest(b, PROC_NAME)
  result = unmarshal(res, bool)

proc reopenForumTopic*(b: TeleBot, chatId: string, messageThreadId: int): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["message_thread_id"] = $messageThreadId
  let res = await makeRequest(b, PROC_NAME)
  result = unmarshal(res, bool)

proc deleteForumTopic*(b: TeleBot, chatId: string, messageThreadId: int): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["message_thread_id"] = $messageThreadId
  let res = await makeRequest(b, PROC_NAME)
  result = unmarshal(res, bool)

proc unpinAllForumTopicMessages*(b: TeleBot, chatId: string, messageThreadId: int): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["message_thread_id"] = $messageThreadId
  let res = await makeRequest(b, PROC_NAME)
  result = unmarshal(res, bool)



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

  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

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

  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc sendMediaGroup*(b: TeleBot, chatId: string, media: seq[InputMediaSet], messageThreadId = 0, disableNotification = false, allowSendingWithoutReply = false, replyToMessageId = 0): Future[seq[Message]] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
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

  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, seq[Message])

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

  let res = await makeRequest(b, PROC_NAME, data)
  if res.kind == JBool:
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

  let res = await makeRequest(b, PROC_NAME, data)
  if res.kind == JBool:
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

  let res = await makeRequest(b, PROC_NAME, data)
  if res.kind == JBool:
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

  let res = await makeRequest(b, PROC_NAME, data)
  if res.kind == JBool:
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

  let res = await makeRequest(b, PROC_NAME, data)
  if res.kind == JBool:
    result = none(Poll)
  else:
    result = some(unmarshal(res, Poll))

proc deleteMessage*(b: Telebot, chatId: string, messageId: int): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chat_id
  data["message_id"] = $messageId

  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

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

  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc setMyCommands*(b: TeleBot, commands: seq[BotCommand], scope = COMMAND_SCOPE_DEFAULT, chatId = "", userId = 0, languageCode = ""): Future[bool] {.async.} =
  var data = newMultipartData()
  var json  = ""
  marshal(commands, json)
  data["commands"] = json

  case scope
  of COMMAND_SCOPE_DEFAULT:
    discard
  of COMMAND_SCOPE_ALL_PRIVATE_CHATS, COMMAND_SCOPE_ALL_GROUP_CHATS, COMMAND_SCOPE_ALL_CHAT_ADMINISTARTORS:
    json = "{\"type\": \"$#}\"" % [$scope]
  of COMMAND_SCOPE_CHAT, COMMAND_SCOPE_CHAT_ADMINISTARTORS:
    json = "{\"type\": \"$#\", \"chat_id\": \"$#\"}" % [$scope, $chatId]
  of COMMAND_SCOPE_CHAT_MEMBER:
    json = "{\"type\": \"$#\", \"chat_id\": \"$#\", \"user_id\": $#}" % [$scope, $chatId, $userId]

  if scope != COMMAND_SCOPE_DEFAULT:
    data["scope"] = json

  if languageCode.len != 0:
    data["language_code"] = languageCode

  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc getMyCommands*(b: TeleBot, scope = COMMAND_SCOPE_DEFAULT, chatId = "", userId = 0, languageCode = ""): Future[seq[BotCommand]] {.async.} =
  var data = newMultipartData()

  var json = ""
  case scope
  of COMMAND_SCOPE_DEFAULT:
    discard
  of COMMAND_SCOPE_ALL_PRIVATE_CHATS, COMMAND_SCOPE_ALL_GROUP_CHATS, COMMAND_SCOPE_ALL_CHAT_ADMINISTARTORS:
    json = "{\"type\": \"$#\"" % [$scope]
  of COMMAND_SCOPE_CHAT, COMMAND_SCOPE_CHAT_ADMINISTARTORS:
    json = "{\"type\": \"$#\", \"chat_id\": \"$#\"}" % [$scope, $chatId]
  of COMMAND_SCOPE_CHAT_MEMBER:
    json = "{\"type\": \"$#\", \"chat_id\": \"$#\", \"user_id\": $#}" % [$scope, $chatId, $userId]

  if scope != COMMAND_SCOPE_DEFAULT:
    data["scope"] = json

  if languageCode.len != 0:
    data["language_code"] = languageCode

  let res = await makeRequest(b, PROC_NAME, data)

  result = unmarshal(res, seq[BotCommand])

proc deleteMyCommands*(b: TeleBot, scope = COMMAND_SCOPE_DEFAULT, chatId = "", userId = 0, languageCode = ""): Future[bool] {.async.} =
  var data = newMultipartData()

  var json = ""
  case scope
  of COMMAND_SCOPE_DEFAULT:
    discard
  of COMMAND_SCOPE_ALL_PRIVATE_CHATS, COMMAND_SCOPE_ALL_GROUP_CHATS, COMMAND_SCOPE_ALL_CHAT_ADMINISTARTORS:
    json = "{\"type\": \"$#\"" % [$scope]
  of COMMAND_SCOPE_CHAT, COMMAND_SCOPE_CHAT_ADMINISTARTORS:
    json = "{\"type\": \"$#\", \"chat_id\": \"$#\"}" % [$scope, $chatId]
  of COMMAND_SCOPE_CHAT_MEMBER:
    json = "{\"type\": \"$#\", \"chat_id\": \"$#\", \"user_id\": $#}" % [$scope, $chatId, $userId]

  if scope != COMMAND_SCOPE_DEFAULT:
    data["scope"] = json

  if languageCode.len != 0:
    data["language_code"] = languageCode

  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc answerInlineQuery*[T: InlineQueryResult](b: TeleBot, id: string, results: seq[T], cacheTime = 0, isPersonal = false, nextOffset = "", switchPmText = "", switchPmParameter = ""): Future[bool] {.async.} =
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

  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc setChatAdministratorCustomTitle*(b: TeleBot, chatId: string, userId: int, customTitle: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["user_id"] = $userId
  data["custom_title"] = customTitle
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc banChatSenderChat*(b: TeleBot, chatId: string, senderChatId: int, untilDate = 0): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["sender_chat_id"] = $senderChatId
  if untilDate > 0:
    data["until_date"] = $untilDate
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc unbanChatSenderChat*(b: TeleBot, chatId: string, senderChatId: int): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  data["sender_chat_id"] = $senderChatId
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

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

  result = await makeRequest(b, PROC_NAME, data)

  if result.len > 0:
    b.lastUpdateId = result[result.len - 1]["update_id"].getInt

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


proc sendGame*(b: TeleBot, chatId: ChatId, gameShortName: string, messageThreadId = 0, disableNotification = false, replyToMessageId = 0,
               allowSendingWithoutReply = false, replyMarkup: InlineKeyboardMarkup): Future[Message] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if messageThreadId > 0:
    data["message_thread_id"] = $messageThreadId
  data["game_short_name"] = gameShortName
  if disableNotification:
    data["disable_notification"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if allowSendingWithoutReply:
    data["allow_sending_without_reply"] = "true"
  if replyMarkup != nil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc setGameScore*(b: TeleBot, userId: int, score: int, force = false, disableEditMessage = false,
                   chatId = 0, inlineMessageId = 0): Future[Message] {.async.} =

  var data = newMultipartData()

  data["user_id"] = $userId
  data["score"] = $score
  if force:
    data["force"] = "true"
  if disableEditMessage:
    data["disable_edit_message"] = "true"
  if chatId != 0:
    data["chat_id"] = $chatId
  if inlineMessageId != 0:
    data["inline_message_id"] = $inlineMessageId
  let res = await makeRequest(b, PROC_NAME, data)
  result = getMessage(res)

proc getGameHighScores*(b: TeleBot, userId: int, chatId = 0, messageId = 0, inlineMessageId = 0): Future[seq[GameHighScore]] {.async.} =
  var data = newMultipartData()

  data["user_id"] = $userId
  if chatId != 0:
    data["chat_id"] = $chatId
  if messageId != 0:
    data["message_id"] = $messageId
  if inlineMessageId != 0:
    data["inline_message_id"] = $inlineMessageId
  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, seq[GameHighScore])

proc createChatInviteLink*(b: Telebot, chatId: ChatId, name = "", expireDate = 0, memberLimit = 0, createsJoinRequest = false): Future[ChatInviteLink] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  if name.len > 0:
    data["name"] = name
  if expireDate > 0:
    data["expire_date"] = $expireDate
  if memberLimit > 0:
    data["member_limit"] = $memberLimit
  if createsJoinRequest:
    data["creates_join_request"] = "true"

  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, seq[ChatInviteLink])

proc editChatInviteLink*(b: Telebot, chatId: ChatId, inviteLink: string, name = "", expireDate = 0, memberLimit = 0, createsJoinRequest = false): Future[ChatInviteLink] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data["invite_link"] = invite_link
  if name.len > 0:
    data["name"] = name
  if expireDate > 0:
    data["expire_date"] = $expireDate
  if memberLimit > 0:
    data["member_limit"] = $memberLimit
  if createsJoinRequest:
    data["creates_join_request"] = "true"

  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, seq[ChatInviteLink])

proc revokeChatInviteLink*(b: Telebot, chatId: ChatId, inviteLink: string): Future[ChatInviteLink] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data["invite_link"] = invite_link

  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, seq[ChatInviteLink])

proc approveChatJoinRequest*(b: Telebot, chatId: ChatId, userId: int): Future[bool] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data["user_id"] = $user_id

  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, bool)

proc declineChatJoinRequest*(b: Telebot, chatId: ChatId, userId: int): Future[bool] {.async.} =
  var data = newMultipartData()

  data["chat_id"] = $chatId
  data["user_id"] = $user_id

  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, bool)


proc answerWebAppQuery*(b: Telebot, webAppQueryId: string, res: InlineQueryResult): Future[SentWebAppMessage] {.async.} =
  var data = newMultipartData()

  data["web_app_query_id"] = webAppQueryId
  var s = ""
  marshal(res, s)
  data["result"] = s

  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, SentWebAppMessage)

proc setChatMenuButon*(b: TeleBot, chatId: string, menuButton: MenuButton): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  var s = ""
  marshal(menuButton, s)
  data["menu_buton"] = s
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc getChatMenuButon*(b: TeleBot, chatId: string): Future[MenuButton] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = chatId
  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, MenuButton)

proc setMyDefaultAdministratorRights*(b: TeleBot, rights: ChatAdministratorRights, forChannels = false): Future[bool] {.async.} =
  var data = newMultipartData()

  var s = ""
  marshal(rights, s)
  data["rights"] = s
  if forChannels:
    data["for_channels"] = "True"
  let res = await makeRequest(b, PROC_NAME, data)
  result = res.getBool

proc getMyDefaultAdministratorRights*(b: TeleBot, forChannels = false): Future[ChatAdministratorRights] {.async.} =
  var data = newMultipartData()
  if forChannels:
    data["for_channels"] = "True"
  let res = await makeRequest(b, PROC_NAME, data)
  result = unmarshal(res, ChatAdministratorRights)

proc editGeneralForumTopic*(b: TeleBot, chatId: ChatId, name: string): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = $chatId
  data["name"] = name
  let res = await makeRequest(b, PROC_NAME)
  result = unmarshal(res, bool)

proc closeGeneralForumTopic*(b: TeleBot, chatId: ChatId): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = $chatId
  let res = await makeRequest(b, PROC_NAME)
  result = unmarshal(res, bool)

proc reopenGeneralForumTopic*(b: TeleBot, chatId: ChatId): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = $chatId
  let res = await makeRequest(b, PROC_NAME)
  result = unmarshal(res, bool)

proc hideGeneralForumTopic*(b: TeleBot, chatId: ChatId): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = $chatId
  let res = await makeRequest(b, PROC_NAME)
  result = unmarshal(res, bool)

proc unhideGeneralForumTopic*(b: TeleBot, chatId: ChatId): Future[bool] {.async.} =
  var data = newMultipartData()
  data["chat_id"] = $chatId
  let res = await makeRequest(b, PROC_NAME)
  result = unmarshal(res, bool)
import httpclient, json, asyncdispatch, utils, strutils, strtabs, logging
import types
from tables import hasKey, `[]`
from keyboard import `$`

proc sendMessage*(b: TeleBot, chatId: ChatId, text: string, messageEffectId = 0, businessConnectionId = 0, messageThreadId = 0, parseMode = "", entities: seq[MessageEntity] = @[],
                  linkPreviewOptions: LinkPreviewOptions = nil, disableNotification = false, protectContent = false, replyParameters: ReplyParameters = nil,
                  allowPaidBroadcast = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc sendPhoto*(b: TeleBot, chatId: ChatId, photo: InputFileOrString, messageEffectId = 0, businessConnectionId = 0, messageThreadId = 0, caption = "", parseMode = "",
                captionEntities: seq[MessageEntity] = @[], showCaptionAboveMedia = false, hasSpoiler = false, disableNotification = false, protectContent = false,
                replyParameters: ReplyParameters = nil, allowPaidBroadcast = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc sendAudio*(b: TeleBot, chatId: ChatId, audio: InputFileOrString, messageEffectId = 0, businessConnectionId = 0, messageThreadId = 0, caption = "", parseMode = "", captionEntities: seq[MessageEntity] = @[],
                duration = 0, performer = "", title = "", thumbnail: InputFileOrString = "", disableNotification = false, protectContent = false, replyParameters: ReplyParameters = nil,
                allowPaidBroadcast = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc sendDocument*(b: TeleBot, chatId: ChatId, document: InputFileOrString, messageEffectId = 0, businessConnectionId = 0, messageThreadId = 0, thumbnail: InputFileOrString = "", caption = "",
                   disableContentTypeDetection = false, parseMode = "", captionEntities: seq[MessageEntity] = @[], disableNotification = false,
                   protectContent = false, replyParameters: ReplyParameters = nil, allowPaidBroadcast = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc sendSticker*(b: TeleBot, chatId: ChatId, sticker: InputFileOrString, emoji = "", messageEffectId = 0, businessConnectionId = 0, messageThreadId = 0, disableNotification = false, protectContent = false, replyParameters: ReplyParameters = nil,
                  allowPaidBroadcast = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc sendVideo*(b: TeleBot, chatId: ChatId, video: InputFileOrString, messageEffectId = 0, businessConnectionId = 0, messageThreadId = 0, duration = 0, width = 0, height = 0, thumbnail: InputFileOrString = "",
                cover: InputFileOrString = "", startTimestamp = 0, caption = "",
                parseMode = "", captionEntities: seq[MessageEntity] = @[], showCaptionAboveMedia = false, hasSpoiler = false, supportsStreaming = false, disableNotification = false,
                protectContent = false, replyParameters: ReplyParameters = nil, allowPaidBroadcast = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc sendVoice*(b: TeleBot, chatId: ChatId, voice: InputFileOrString, messageEffectId = 0, businessConnectionId = 0, messageThreadId = 0, caption = "", parseMode = "", captionEntities: seq[MessageEntity] = @[],
                duration = 0, disableNotification = false, protectContent = false, replyParameters: ReplyParameters = nil,
                allowPaidBroadcast = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc sendVideoNote*(b: TeleBot, chatId: ChatId, videoNote: InputFileOrString, messageEffectId = 0, businessConnectionId = 0, messageThreadId = 0, duration = 0, length = 0, thumbnail: InputFileOrString = "",
                    disableNotification = false, protectContent = false, replyParameters: ReplyParameters = nil,
                    allowPaidBroadcast = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc sendLocation*(b: TeleBot, chatId: ChatId, latitude: float, longitude: float, messageEffectId = 0, businessConnectionId = 0, messageThreadId = 0, livePeriod = 0,
                   heading = 0, proximityAlertRadius = 0, disableNotification = false, protectContent = false,
                   replyParameters: ReplyParameters = nil, allowPaidBroadcast = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc sendVenue*(b: TeleBot, chatId: ChatId, latitude: float, longitude: float, address: string, messageEffectId = 0, businessConnectionId = 0,
                messageThreadId = 0, foursquareId = "", foursquareType = "",
                googlePlaceId = "", googlePlaceType = "", disableNotification = false, protectContent = false, replyParameters: ReplyParameters = nil,
                allowPaidBroadcast = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc sendContact*(b: TeleBot, chatId: ChatId, phoneNumber: string, firstName: string, lastName = "", vcard = "",
                  messageEffectId = 0,
                  businessConnectionId = 0, messageThreadId = 0, disableNotification = false, protectContent = false, replyParameters: ReplyParameters = nil,
                  allowPaidBroadcast = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc sendInvoice*(b: TeleBot, chatId: ChatId, title: string, description: string, payload: string, providerToken: string, currency: string,
                  messageThreadId = 0,
                  prices: seq[LabeledPrice], maxTipAmount = 0, suggestedTipAmounts: seq[int] = @[], startParameter = "",
                  providerData = "", photoUrl = "", photoSize = 0, photoWidth = 0, photoHeight = 0,
                  needName = false, needPhoneNumber = false, needEmail = false, needShippingAddress = false, sendPhoneNumberToProvider = false,
                  sendEmailToProvider = false, isFlexible = false, disableNotification = false, protectContent = false, replyParameters: ReplyParameters = nil,
                  allowPaidBroadcast = false, replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc createInvoiceLink*(b: TeleBot, title: string, description: string, payload: string, providerToken: string, currency: string, prices: seq[LabeledPrice], businessConnectionId =  "", subscriptionPeriod = 0, maxTipAmount = 0,
                        suggestedTipAmounts: seq[int] = @[], providerData = "", photoUrl = "", photoSize = 0, photoWidth = 0, photoHeight = 0,
                        needName = false, needPhoneNumber = false, needEmail = false, needShippingAddress = false,
                        sendPhoneNumberToProvider = false, sendEmailToProvider = false, isFlexible = false): Future[string] {.api, async.}

proc sendAnimation*(b: TeleBot, chatId: ChatId, animation: InputFileOrString, messageEffectId = 0, businessConnectionId = 0, messageThreadId = 0, duration = 0, width = 0, height = 0, thumbnail: InputFileOrString = "",
                   caption = "", parseMode = "", captionEntities: seq[MessageEntity] = @[], showCaptionAboveMedia = false, hasSpoiler = false,
                   disableNotification = false, protectContent = false, replyParameters: ReplyParameters = nil,
                  replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc sendPoll*(b: TeleBot, chatId: ChatId, question: string, options: seq[InputPollOption], messageThreadId = 0,
               messageEffectId = 0,
               questionParseMode = "", questionEntities: seq[MessageEntity] = @[], isAnonymous = false, kind = "",
               allowsMultipleAnswers = false, correctOptionId = 0, explanation = "", explanationParseMode = "",
               explanationEntities: seq[MessageEntity] = @[], openPeriod = 0, closeDate = 0, isClosed = false, disableNotification = false,
               protectContent = false, replyParameters: ReplyParameters = nil, replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc sendDice*(b: TeleBot, chatId: ChatId, messageThreadId = 0, emoji = "", disableNotification = false, protectContent = false, replyParameters: ReplyParameters = nil,
               messageEffectId = 0, replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc getMe*(b: TeleBot): Future[User] {.api, async.}
  ## Returns basic information about the bot in form of a `User` object.
  ##
  ## This method can be used to verify the bot's token is valid.
  ##
  ## Returns:
  ##   * `Future[User]`: A Future that resolves to a `User` object containing information about the bot.
  ##                      If the request fails (e.g., invalid token), the Future will be rejected with an error.
  ##
  ## Example:
  ## ```nim
  ## let bot = newTeleBot("YOUR_BOT_TOKEN")
  ## let me = waitFor bot.getMe()
  ## echo "Bot username: ", me.username
  ## ```

proc logOut*(b: TeleBot): Future[bool] {.api, async.}
  ## Use this method to log out from the Telegram Bot API server before
  ## concluding any activity, or when the bot becomes inactive.
  ##
  ## Returns:
  ##   * `Future[bool]`: A Future that resolves to `true` on success, and `false` otherwise.
  ##
  ## Example:
  ## ```nim
  ## let bot = newTeleBot("YOUR_BOT_TOKEN")
  ## let loggedOut = waitFor bot.logOut()
  ## if loggedOut:
  ##   echo "Bot logged out successfully"
  ## else:
  ##   echo "Failed to log out bot"
  ## ```

proc close*(b: TeleBot): Future[bool] {.api, async.}

proc forwardMessage*(b: TeleBot, chatId, fromChatId: string, messageId: int, messageThreadId = 0, disableNotification = false, protectContent = false): Future[Message] {.api, async.}

proc forwardMessages*(b: TeleBot, chatId, fromChatId: string, messageIds: seq[int], videoStartTimestamp = 0, messageThreadId = 0, disableNotification = false, protectContent = false): Future[Message] {.api, async.}

proc copyMessage*(b: TeleBot, chatId, fromChatId: string, messageId: int,  videoStartTimestamp = 0, messageThreadId = 0, caption = "", parseMode = "",
                  captionEntities: seq[MessageEntity] = @[], disableNotification = false, protectContent = false, showCaptionAboveMedia = false,
                  replyParameters: ReplyParameters = nil, allowPaidBroadcast = false, replyMarkup: KeyboardMarkup = nil): Future[MessageId] {.api, async.}

proc copyMessages*(b: TeleBot, chatId, fromChatId: string, messageIds: seq[int], messageThreadId = 0, caption = "", parseMode = "",
                  captionEntities: seq[MessageEntity] = @[], disableNotification = false, protectContent = false,
                  replyParameters: ReplyParameters = nil, replyMarkup: KeyboardMarkup = nil): Future[MessageId] {.api, async.}

proc sendChatAction*(b: TeleBot, chatId: ChatId, action: ChatAction, businessConnectionId = 0, messageThreadId = 0): Future[void] {.api, async.}

proc setMessageReaction*(b: TeleBot, chatId: ChatId, messageId: int, reaction: seq[ReactionType] = @[], isBig = false): Future[bool] {.api, async.}

proc getUserProfilePhotos*(b: TeleBot, userId: int, offset = 0, limit = 100): Future[UserProfilePhotos] {.api, async.}

proc getFile*(b: TeleBot, fileId: string): Future[FileObj] {.api, async.}

proc setUserEmojiStatus*(b: TeleBot, userId: int, emojiStatusCustomEmojiId = "", emojiStatusExpirationDate = 0): Future[bool] {.api, async.}

proc banChatMember*(b: TeleBot, chatId: ChatId, userId: int, untilDate = 0, revokeMessages = false): Future[bool] {.api, async.}

proc kickChatMember*(b: TeleBot, chatId: ChatId, userId: int, untilDate = 0, revokeMessages = false): Future[bool] {.async, inline, deprecated: "Use banChatMember instead".} =
  result = await banChatMember(b, chatId, userId, untilDate, revokeMessages)

proc unbanChatMember*(b: TeleBot, chatId: ChatId, userId: int, onlyIfBanned = false): Future[bool] {.api, async.}

proc restrictChatMember*(b: TeleBot, chatId: ChatId, userId: int, permissions: ChatPermissions, useIndependentChatPermissions = false, untilDate = 0): Future[bool] {.api, async.}

proc promoteChatMember*(b: TeleBot, chatId: ChatId, userId: int, isAnonymous = false, canManageChat = false, canChangeInfo = false,
                        canPostMessages = false, canEditMessages = false, canDeleteMessages = false,
                        canPostStories = false, canEditStories = false, canDeleteStories = false, canManageVideoChats = false,
                        canInviteUsers = false, canRestrictMembers = false, canPinMessages = false, canPromoteMembers = false,
                        canManageTopics = false): Future[bool] {.api, async.}

proc setChatPermissions*(b: TeleBot, chatId: ChatId, permissions: ChatPermissions, useIndependentChatPermissions = false): Future[bool] {.api, async.}

proc exportChatInviteLink*(b: TeleBot, chatId: ChatId): Future[string] {.api, async.}

proc setChatPhoto*(b: TeleBot, chatId: ChatId, photo: string): Future[bool] {.api, async.}

proc deleteChatPhoto*(b: TeleBot, chatId: ChatId): Future[bool] {.api, async.}

proc setChatTitle*(b: TeleBot, chatId: ChatId, title: string): Future[bool] {.api, async.}

proc setChatDescription*(b: TeleBot, chatId: ChatId, description = ""): Future[bool] {.api, async.}

proc pinChatMessage*(b: TeleBot, chatId: ChatId, messageId: int, businessConnectionId = 0, disableNotification = false): Future[bool] {.api, async.}

proc unpinChatMessage*(b: TeleBot, chatId: ChatId, businessConnectionId = 0, messageId = 0): Future[bool] {.api, async.}

proc unpinAllChatMessages*(b: TeleBot, chatId: ChatId): Future[bool] {.api, async.}

proc leaveChat*(b: TeleBot, chatId: ChatId): Future[bool] {.api, async.}

proc getChat*(b: TeleBot, chatId: ChatId): Future[ChatFullInfo] {.api, async.}

proc getChatAdministrators*(b: TeleBot, chatId: ChatId): Future[seq[ChatMember]] {.api, async.}

proc getChatMemberCount*(b: TeleBot, chatId: ChatId): Future[int] {.api, async.}

proc getChatMembersCount*(b: TeleBot, chatId: ChatId): Future[int] {.async, inline, deprecated: "Use getChatMemberCount instead".} =
  result = await getChatMemberCount(b, chatId)

proc getChatMember*(b: TeleBot, chatId: ChatId, userId: int): Future[ChatMember] {.api, async.}

proc getStickerSet*(b: TeleBot, name: string): Future[StickerSet] {.api, async.}

proc getCustomEmojiStickers*(b: TeleBot, customEmojiIds: seq[string]): Future[seq[Sticker]] {.api, async.}

proc uploadStickerFile*(b: TeleBot, userId: int, sticker: InputFileOrString, stickerFormat: string): Future[FileObj] {.api, async.}

proc createNewStickerSet*(b: TeleBot, userId: int, name, title: string, stickers: seq[InputSticker], stickerType = "", needsRepainting = false): Future[bool] {.api, async.}

proc addStickerToSet*(b: TeleBot, userId: int, name: string, sticker: InputSticker): Future[bool] {.api, async.}

proc setStickerPositionInSet*(b: TeleBot, sticker: string, position: int): Future[bool] {.api, async.}

proc deleteStickerFromSet*(b: TeleBot, sticker: string): Future[bool] {.api, async.}

proc replaceStickerInSet*(b: TeleBot, userId: int, name: string, oldSticker: string, sticker: InputSticker): Future[bool] {.api, async.}

proc setStickerSetThumbnail*(b: TeleBot, name: string, userId: int, thumbnail: InputFileOrString = "", format = ""): Future[bool] {.api, async.}

proc setChatStickerSet*(b: TeleBot, chatId: ChatId, stickerSetname: string): Future[bool] {.api, async.}

proc deleteChatStickerSet*(b: TeleBot, chatId: ChatId): Future[bool] {.api, async.}

proc getForumTopicIconStickers*(b: TeleBot): Future[seq[Sticker]] {.api, async.}

proc createForumTopic*(b: TeleBot, chatId: ChatId, name: string, iconColor = 0, iconCustomEmojiId = ""): Future[ForumTopic] {.api, async.}

proc editForumTopic*(b: TeleBot, chatId: ChatId, messageThreadId: int, name = "", iconCustomEmojiId = ""): Future[bool] {.api, async.}

proc closeForumTopic*(b: TeleBot, chatId: ChatId, messageThreadId: int): Future[bool] {.api, async.}

proc reopenForumTopic*(b: TeleBot, chatId: ChatId, messageThreadId: int): Future[bool] {.api, async.}

proc deleteForumTopic*(b: TeleBot, chatId: ChatId, messageThreadId: int): Future[bool] {.api, async.}

proc unpinAllForumTopicMessages*(b: TeleBot, chatId: ChatId, messageThreadId: int): Future[bool] {.api, async.}

proc editMessageLiveLocation*(b: TeleBot, latitude: float, longitude: float, chatId = "",
                              businessConnectionId = "",
                              messageId = 0, inlineMessageId = "", livePeriod = 0, horizontalAccuracy = 0.0,
                              heading = 0, proximityAlertRadius = 0, replyMarkup: KeyboardMarkup = nil): Future[bool] {.api, async.}

proc stopMessageLiveLocation*(b: TeleBot, businessConnectionId = "", chatId = "", messageId = 0, inlineMessageId = "", replyMarkup: KeyboardMarkup = nil): Future[bool] {.api, async.}

proc sendMediaGroup*(b: TeleBot, chatId: ChatId, media: seq[InputMediaSet], businessConnectionId = 0, messageThreadId = 0, disableNotification = false,replyParameters: ReplyParameters = nil): Future[seq[Message]] {.api, async.}

proc editMessageMedia*(b: TeleBot, media: InputMediaSet, businessConnectionId = "", chatId = "", messageId = 0, inlineMessageId = "", replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc editMessageText*(b: TeleBot, text: string, chatId: ChatId = DefaultChatId, messageId = 0, inlineMessageId = "", parseMode = "", entities: seq[MessageEntity] = @[],
                      replyMarkup: KeyboardMarkup = nil, linkPreviewOptions: LinkPreviewOptions = nil): Future[Message] {.api, async.}

proc editMessageCaption*(b: TeleBot, businessConnectionId = "", caption = "", chatId = "", messageId = 0, inlineMessageId = "", parseMode="",
                         showCaptionAboveMedia = false,
                         captionEntities: seq[MessageEntity] = @[], replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc editMessageReplyMarkup*(b: TeleBot, businessConnectionId = "", chatId = "", messageId = 0, inlineMessageId = "", replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

proc stopPoll*(b: TeleBot, businessConnectionId = "", chatId = "", messageId = 0, inlineMessageId = "", replyMarkup: KeyboardMarkup = nil): Future[Poll] {.api, async.}

proc deleteMessage*(b: TeleBot, chatId: ChatId, messageId: int): Future[bool] {.api, async.}

proc deleteMessages*(b: TeleBot, chatId: ChatId, messageIds: seq[int]): Future[bool] {.api, async.}

proc answerCallbackQuery*(b: TeleBot, callbackQueryId: string, text = "", showAlert = false, url = "",  cacheTime = 0): Future[bool] {.api, async.}

proc getUserChatBoosts*(b: TeleBot, chatId: ChatId, userId: int): Future[UserChatBoosts] {.api, async.}

proc getBusinessConnection*(b: TeleBot, businessConnectionId: string): Future[BusinessConnection] {.api, async.}

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

proc setMyName*(b: TeleBot, name = "", languageCode = ""): Future[bool] {.api, async.}

proc getMyName*(b: TeleBot, languageCode = ""): Future[BotName] {.api, async.}

proc setMyDescription*(b: TeleBot, description = "", languageCode = ""): Future[bool] {.api, async.}

proc getMyDescription*(b: TeleBot, languageCode = ""): Future[BotDescription] {.api, async.}

proc setMyShortDescription*(b: TeleBot, shortDescription = "", languageCode = ""): Future[bool] {.api, async.}

proc getMyShortDescription*(b: TeleBot, languageCode = ""): Future[BotShortDescription] {.api, async.}

proc setStickerEmojiList*(b: TeleBot, sticker: string, emojiList: seq[string]): Future[bool] {.api, async.}

proc setStickerKeywords*(b: TeleBot, sticker: string, keywords: seq[string]): Future[bool] {.api, async.}

proc setStickerMaskPosition*(b: TeleBot, sticker: string, maskPosition: MaskPosition = nil): Future[bool] {.api, async.}

proc setStickerSetTitle*(b: TeleBot, name, title: string): Future[bool] {.api, async.}

proc setCustomEmojiStickerSetThumbnail*(b: TeleBot, name: string, customEmojiId = ""): Future[bool] {.api, async.}

proc deleteStickerSet*(b: TeleBot, name: string): Future[bool] {.api, async.}

proc getAvailableGifts*(b: TeleBot): Future[Gifts] {.api, async.}

proc sendGift*(b: TeleBot, giftId: int, userId = 0, chatId: ChatId = 0, payForUpgrade = false, text = "", textParseMode = "", textEntities = seq[MessageEntity]): Future[bool] {.api, async.}

proc verifyUser*(b: TeleBot, userId: int, customDescription = ""): Future[bool] {.api, async.}

proc verifyChat*(b: TeleBot, userId: int, customDescription = ""): Future[bool] {.api, async.}

proc removeUserVerification*(b: TeleBot, userId: int): Future[bool] {.api, async.}

proc removeChatVerification*(b: TeleBot, chatId: ChatId): Future[bool] {.api, async.}

proc answerInlineQuery*[T: InlineQueryResult](b: TeleBot, inlineQueryId: string, results: seq[T], cacheTime = 0, isPersonal = false, nextOffset = "", button: InlineQueryResultsButton = nil): Future[bool] {.api, async.}

proc setChatAdministratorCustomTitle*(b: TeleBot, chatId: ChatId, userId: int, customTitle: string): Future[bool] {.api, async.}

proc banChatSenderChat*(b: TeleBot, chatId: ChatId, senderChatId: int, untilDate = 0): Future[bool] {.api, async.}

proc unbanChatSenderChat*(b: TeleBot, chatId: ChatId, senderChatId: int): Future[bool] {.api, async.}

proc getUpdates*(b: TeleBot, offset = 0, limit = 0, timeout = 50, allowedUpdates: seq[string] = @[]): Future[JsonNode] {.async.} =
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

  result = await makeRequest(b, PROC_NAME, data, timeoutMs = (timeout + 10) * 1000)

  if result.len > 0:
    b.lastUpdateId = result[result.len - 1]["update_id"].getInt

proc handleUpdate*(b: TeleBot, update: Update) {.async.} =
  # stop process other callbacks if a callback returns true
  var stop = false
  if update.inlineQuery != nil:
    for cb in b.inlineQueryCallbacks:
      stop = await cb(b, update.inlineQuery)
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

proc loop(b: TeleBot, timeout = 50, offset = 0, limit = 0) {.async.} =
  try:
    let me = waitFor b.getMe()
    b.id = me.id
    if me.username.len > 0:
      b.username = me.username.toLowerAscii()
  except IOError, OSError:
    d("Unable to fetch my info ", getCurrentExceptionMsg())

  while true:
    let updates = try:
                    await b.getUpdates(timeout=timeout, offset=offset, limit=limit)
                  except IOError as e:
                    warn e.msg
                    %[]
    for item in updates:
      let update = unmarshal(item, Update)
      asyncCheck b.handleUpdate(update)

proc poll*(b: TeleBot, timeout = 50, offset = 0, limit = 0, clean = false) =
  if clean:
    waitFor b.cleanUpdates()
  waitFor loop(b, timeout, offset, limit)

proc pollAsync*(b: TeleBot, timeout = 50, offset = 0, limit = 0, clean = false) {.async.} =
  if clean:
    await b.cleanUpdates()
  await loop(b, timeout, offset, limit)


proc sendGame*(b: TeleBot, chatId: ChatId, gameShortName: string, businessConnectionId = 0, messageThreadId = 0, disableNotification = false, replyParameters: ReplyParameters = nil,
               replyMarkup: InlineKeyboardMarkup): Future[Message] {.api, async.}

proc setGameScore*(b: TeleBot, userId: int, score: int, force = false, disableEditMessage = false,
                   chatId = 0, inlineMessageId = 0): Future[Message] {.api, async.}


proc getGameHighScores*(b: TeleBot, userId: int, chatId = 0, messageId = 0, inlineMessageId = 0): Future[seq[GameHighScore]] {.api, async.}

proc createChatInviteLink*(b: Telebot, chatId: ChatId, name = "", expireDate = 0, memberLimit = 0, createsJoinRequest = false): Future[ChatInviteLink] {.api, async.}

proc editChatInviteLink*(b: Telebot, chatId: ChatId, inviteLink: string, name = "", expireDate = 0, memberLimit = 0, createsJoinRequest = false): Future[ChatInviteLink] {.api, async.}

proc createChatSubscriptionInviteLink*(b: Telebot, chatId: ChatId, subscriptionPeriod: int, subscriptionPrice: int, name = ""): Future[ChatInviteLink] {.api, async.}

proc editChatSubscriptionInviteLink*(b: Telebot, chatId: ChatId, inviteLink: string, name = ""): Future[ChatInviteLink] {.api, async.}

proc revokeChatInviteLink*(b: Telebot, chatId: ChatId, inviteLink: string): Future[ChatInviteLink] {.api, async.}

proc approveChatJoinRequest*(b: Telebot, chatId: ChatId, userId: int): Future[bool] {.api, async.}

proc declineChatJoinRequest*(b: Telebot, chatId: ChatId, userId: int): Future[bool] {.api, async.}

proc answerWebAppQuery*(b: Telebot, webAppQueryId: string, res: InlineQueryResult): Future[SentWebAppMessage] {.api, async.}

proc savePreparedInlineMessage*(b: TeleBot, userId: int, res: InlineQueryResult, allowUserChats = false, allowBotChats = false, allowGroupChats = false, allowChannelChats = false): Future[PreparedInlineMessage] {.api, async.}

proc setChatMenuButon*(b: TeleBot, chatId: ChatId, menuButton: MenuButton): Future[bool] {.api, async.}

proc getChatMenuButon*(b: TeleBot, chatId: ChatId): Future[MenuButton] {.api, async.}

proc setMyDefaultAdministratorRights*(b: TeleBot, rights: ChatAdministratorRights, forChannels = false): Future[bool] {.api, async.}

proc getMyDefaultAdministratorRights*(b: TeleBot, forChannels = false): Future[ChatAdministratorRights] {.api, async.}

proc editGeneralForumTopic*(b: TeleBot, chatId: ChatId, name: string): Future[bool] {.api, async.}

proc closeGeneralForumTopic*(b: TeleBot, chatId: ChatId): Future[bool] {.api, async.}

proc reopenGeneralForumTopic*(b: TeleBot, chatId: ChatId): Future[bool] {.api, async.}

proc hideGeneralForumTopic*(b: TeleBot, chatId: ChatId): Future[bool] {.api, async.}

proc unhideGeneralForumTopic*(b: TeleBot, chatId: ChatId): Future[bool] {.api, async.}

proc unpinAllGeneralForumTopicMessages*(b: TeleBot, chatId: ChatId): Future[bool] {.api, async.}


#------------------
# Payments
#------------------

proc answerPreCheckoutQuery*(b: TeleBot, preCheckoutQueryId: string, ok: bool, errorMessage = ""): Future[bool] {.api, async.}

proc getStarTransactions*(b: TeleBot, offset = 0, limit = 0): Future[StarTransactions] {.api, async.}

proc refundStarPayment*(b: TeleBot, userId: int, telegramPaymentChargeId: int): Future[bool] {.api, async.}

proc editUserStarSubscription*(b: TeleBot, userId: int, telegramPaymentChargeId: int, isCanceled = true): Future[bool] {.api, async.}

proc sendPaidMedia*(b: TeleBot, chatId: ChatId, starCount: int, media: seq[InputPaidMedia], businessConnectionId = 0, payload = "", caption = "", parseMode = "", captionEntities: seq[MessageEntity] = @[], showCaptionAboveMedia = false, disableNotification = false, protectContent = false, replyParameters: ReplyParameters = nil,  replyMarkup: KeyboardMarkup = nil): Future[Message] {.api, async.}

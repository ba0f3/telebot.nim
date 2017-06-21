import types, json, strutils, utils, optional



proc getUser*(n: JsonNode): User {.inline.} =
  result = unmarshal(n, User)

proc getChat*(n: JsonNode): Chat {.inline.} =
  result = unmarshal(n, Chat)

proc getAudio*(n: JsonNode): Audio {.inline.} =
  result = unmarshal(n, Audio)

proc getPhotoSize*(n: JsonNode): PhotoSize {.inline.} =
  result = unmarshal(n, PhotoSize)

proc getPhoto*(n: JsonNode): seq[PhotoSize] =
  result = @[]
  for x in n:
    result.add(getPhotoSize(x))

proc getDocument*(n: JsonNode): Document {.inline.} =
  result = unmarshal(n, Document)

proc getSticker*(n: JsonNode): Sticker {.inline.} =
  result = unmarshal(n, Sticker)

proc getVideo*(n: JsonNode): Video {.inline.} =
  result = unmarshal(n, Video)

proc getVoice*(n: JsonNode): Voice {.inline.} =
  result = unmarshal(n, Voice)

proc getVideoNote*(n: JsonNode): VideoNote {.inline.} =
  result = unmarshal(n, VideoNote)

proc getContact*(n: JsonNode): Contact {.inline.} =
  result = unmarshal(n, Contact)

proc getLocation(n: JsonNode): Location {.inline.} =
  result = unmarshal(n, Location)

proc getVenue(n: JsonNode): Venue {.inline.} =
  result = unmarshal(n, Venue)

proc getUserProfilePhotos*(n: JsonNode): UserProfilePhotos {.inline.} =
  result.totalCount = n["total_count"].num.int
  result.photos = @[]
  for x in n["photos"]:
    result.photos.add(getPhoto(x))

proc getMessageEntity(n: JsonNode): MessageEntity {.inline.} =
  result = unmarshal(n, MessageEntity)

proc getGame*(n: JsonNode): Game {.inline.} =
  result = unmarshal(n, Game)
  
proc getInvoice(n: JsonNode): Invoice {.inline.} =
  result = unmarshal(n, Invoice)

proc getFile*(n: JsonNode): types.File {.inline.} =
  result = unmarshal(n, types.File)

proc getChatMember*(n: JsonNode): ChatMember {.inline.} =
  result = unmarshal(n, ChatMember)

proc getSuccessfulPayment(n: JsonNode): SuccessfulPayment {.inline.} =
  ## TODO
  discard

proc getMessage*(n: JsonNode): Message {.inline.} =
  result = unmarshal(n, Message)

discard """
proc getMessage*(n: JsonNode): Message {.inline.} =
  result.messageId = n["message_id"].num.int
  if n.hasKey("from"):
    result.fromUser = getUser(n["from"])
  result.date = n["date"].num.int
  result.chat = getChat(n["chat"])

  if n.hasKey("forward_from"):
    result.forwardFrom = getUser(n["forward_from"])
  if n.hasKey("forward_from_chat"):
    result.forwardFromChat = getChat(n["forward_from_chat"])
  if n.hasKey("forward_from_messafe_id"):
    result.forwardFromMessageId = n["forward_from_message_id"].num.int
  if n.hasKey("forward_date"):
    result.forwardDate = n["forward_date"].num.int
  if n.hasKey("reply_to_message"):
    result.replyToMessage = getMessage(n["reply_to_message"])
  if n.hasKey("edit_date"):
    result.editDate = n["edit_date"].num.int
  if n.hasKey("text"):
    result.kind = kText
    result.text = n["text"].str
    if n.hasKey("entities"):
      result.entities = @[]
      for e in n["entities"]:
        result.entities.add(e.getMessageEntity())
  elif n.hasKey("audio"):
    result.kind = kAudio
    result.audio = getAudio(n["audio"])
  elif n.hasKey("document"):
    result.kind = kDocument
    result.document = getDocument(n["document"])
    if n.hasKey("caption"):
      result.caption = $n["caption"]
  elif n.hasKey("game"):
    result.kind = kGame
    result.game = n["game"].getGame()
  elif n.hasKey("photo"):
    result.kind = kPhoto
    result.photo = getPhoto(n["photo"])
    if n.hasKey("caption"):
      result.caption = $n["caption"]
  elif n.hasKey("sticker"):
    result.kind = kSticker
    result.sticker = getSticker(n["sticker"])
  elif n.hasKey("video"):
    result.kind = kVideo
    result.video = getVideo(n["video"])
  elif n.hasKey("voice"):
    result.kind = kVoice
    result.voice = getVoice(n["voice"])
    if n.hasKey("caption"):
      result.caption = $n["caption"]
  elif n.hasKey("video_note"):
    result.kind = kVideoNote
    result.videoNote = getVideoNote(n["video_note"])
  elif n.hasKey("contact"):
    result.kind = kContact
    result.contact = getContact(n["contact"])
  elif n.hasKey("location"):
    result.kind = kLocation
    result.location = getLocation(n["location"])
  elif n.hasKey("venue"):
    result.kind = kVenue
    result.venue = n["venue"].getVenue()
  elif n.hasKey("new_chat_member") or n.hasKey("new_chat_members"):
    result.kind = kNewChatMember
    result.newChatMember = getUser(n["new_chat_member"])
    result.newChatMembers = @[]
    for u in n["new_chat_members"]:
      result.newChatMembers.add(u.getUser())
  elif n.hasKey("left_chat_member"):
    result.kind = kLeftChatMember
    result.leftChatMember = getUser(n["left_chat_member"])
  elif n.hasKey("new_chat_title"):
    result.kind = kNewChatTitle
    result.newChatTitle = $n["new_chat_title"]
  elif n.hasKey("new_chat_photo"):
    result.kind = kNewChatPhoto
    result.newChatPhoto = getPhoto(n["new_chat_photo"])
  elif n.hasKey("delete_chat_photo"):
    result.kind = kDeleteChatPhoto
  elif n.hasKey("group_chat_created"):
    result.kind = kGroupChatCreated
  elif n.hasKey("supergroup_chat_created"):
    result.kind = kSuperGroupChatCreated
  elif n.hasKey("channel_chat_created"):
    result.kind = kChannelChatCreated
  elif n.hasKey("migrate_to_chat_id"):
    result.kind = kMigrateToChatId
    result.migrateToChatId = n["migrate_to_chat_id"].num.int
  elif n.hasKey("migrate_from_chat_id"):
    result.kind = kMigrateFromChatId
    result.migrateFromChatId = n["migrate_from_chat_id"].num.int
  elif n.hasKey("pinned_message"):
    result.kind = kPinnedMessage
    result.pinnedMessage = n["pinned_message"].getMessage()
  elif n.hasKey("invoice"):
    result.kind = kInvoice
    result.invoice = n["invoice"].getInvoice()
  elif n.hasKey("successful_payment"):
    result.kind = kSuccessfulPayment
    result.successfulPayment = n["successful_payment"].getSuccessfulPayment()
"""

proc processUpdates*(b: TeleBot, n: JsonNode): seq[Update] =
  result = @[]
  var u: Update
  for x in n:
    u.updateId = x["update_id"].num.int
    if u.updateId > b.lastUpdateId:
      b.lastUpdateId = u.updateId

    if x.hasKey("message"):
      u.kind = kMessage
      u.message = getMessage(x["message"])
    elif x.hasKey("edited_message"):
      u.kind = kEditedMessage
      u.editedMessage = getMessage(x["edited_message"])
    elif x.hasKey("channel_post"):
      u.kind = kChannelPost
      u.editedMessage = getMessage(x["channel_post"])
    elif x.hasKey("edited_channel_post"):
      u.kind = kEditedChannelPost
      u.editedMessage = getMessage(x["edited_channel_post"])
    elif x.hasKey("inline_query"):
      u.kind = kInlineQuery
      #u.editedMessage = getInlineQuery(x["inline_query"])
    elif x.hasKey("chosen_inline_query"):
      u.kind = kChosenInlineQuery
      #u.editedMessage = getChosenInlineResult(x["chosen_inline_query"])
    elif x.hasKey("callback_query"):
      u.kind = kCallbackQuery
      #u.editedMessage = getCallbackQuery(x["callback_query"])
    elif x.hasKey("shipping_query"):
      u.kind = kShippingQuery
      #u.editedMessage = getShippingQuery(x["shipping_query"])
    elif x.hasKey("pre_checkout_query"):
      u.kind = kPreCheckoutQuery
      #u.editedMessage = getPreCheckoutQuery(x["pre_checkout_query"])


    result.add(u)


proc `$`*(k: KeyboardButton): string =
  var j = newJObject()
  j["text"] = %k.text
  if $k.requestContact:
    j["request_contact"] = %true
  if $k.requestLocation:
    j["request_location"] = %true

  result = $j

proc `$`*(k: ReplyKeyboardMarkup): string =
  var j = newJObject()
  j["selective"] = %k.selective
  var kb = newJArray()
  for x in k.keyboard:
    var n = newJArray()
    for y in x:
      n.add(%y)
    kb.add(n)

  j["keyboard"] = kb
  j["resize_keyboard"] = %k.resizeKeyboard
  j["one_time_keyboard"] = %k.oneTimeKeyboard

  result = $j

proc initReplyKeyboardMarkup*(kb: seq[seq[KeyboardButton]]): ReplyKeyboardMarkup =
  result.keyboard = kb

proc `$`*(k: ReplyKeyboardRemove): string =
  return "{'remove_keyboard': true, 'selective':" & $$k.selective & "}"

proc `$`*(k: ForceReply): string =
  result = "{'remove_keyboard': true, 'selective':" & $$k.selective & "}"


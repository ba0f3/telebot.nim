import types, json, strutils


proc getUser*(n: JsonNode): User =
  result.id = n["id"].num.int
  result.firstName = $n["first_name"]
  if n.hasKey("last_name"):
    result.lastName = $n["last_name"]
  if n.hasKey("username"):
    result.username = $n["username"]
  if n.hasKey("language_code"):
    result.languageCode = $n["username"]

proc getChat*(n: JsonNode): Chat =
  result.id = n["id"].num.int
  result.kind = $n["type"]
  if n.hasKey("title"):
    result.title = $n["title"]
  if n.hasKey("username"):
    result.username = $n["username"]
  if n.hasKey("first_name"):
    result.firstName = $n["first_name"]
  if n.hasKey("last_name"):
    result.lastName = $n["last_name"]
  if n.hasKey("all_members_are_administrators"):
    result.allMembersAreAdministrators = n["all_members_are_administrators"].bval

proc getAudio*(n: JsonNode): Audio =
  result.fileId = n["file_id"].str
  result.duration = n["duration"].num.int
  if n.hasKey("mime_type"):
    result.mimeType = n["mime_type"].str
  if n.hasKey("file_size"):
    result.fileSize = n["file_size"].num.int

proc getPhotoSize*(n: JsonNode): PhotoSize =
  if n.hasKey("file_id"):
    result.fileId = n["file_id"].str
    result.width = n["width"].num.int
    result.height = n["height"].num.int
    if n.hasKey("file_size"):
      result.fileSize = n["file_size"].num.int

proc getPhoto*(n: JsonNode): seq[PhotoSize] =
  result = @[]
  for x in n:
    result.add(getPhotoSize(x))

proc getDocument*(n: JsonNode): Document =
  result.fileId = n["file_id"].str
  if n.hasKey("thumb"):
    result.thumb = getPhotoSize(n["thumb"])
  if n.hasKey("file_name"):
    result.fileName = n["file_name"].str
  if n.hasKey("mime_type"):
    result.mimeType = n["mime_type"].str
  if n.hasKey("file_size"):
    result.fileSize = n["file_size"].num.int

proc getSticker*(n: JsonNode): Sticker =
  result.fileId = n["file_id"].str
  result.width = n["width"].num.int
  result.height = n["height"].num.int
  if n.hasKey("thumb"):
    result.thumb = getPhotoSize(n["thumb"])
  if n.hasKey("file_size"):
    result.fileSize = n["file_size"].num.int

proc getVideo*(n: JsonNode): Video =
  result.fileId = n["file_id"].str
  result.width = n["width"].num.int
  result.height = n["height"].num.int
  result.duration = n["duration"].num.int
  if n.hasKey("thumb"):
    result.thumb = getPhotoSize(n["thumb"])
  if n.hasKey("mime_type"):
    result.mimeType = n["mime_type"].str
  if n.hasKey("file_size"):
    result.fileSize = n["file_size"].num.int

proc getVoice*(n: JsonNode): Voice =
  result.fileId = n["file_id"].str
  result.duration = n["duration"].num.int
  if n.hasKey("mime_type"):
    result.mimeType = n["mime_type"].str
  if n.hasKey("file_size"):
    result.fileSize = n["file_size"].num.int

proc getVideoNote*(n: JsonNode): VideoNote =
  result.fileId = $n["file_id"]
  result.length = n["length"].num.int
  result.duration = n["duration"].num.int
  if n.hasKey("thumb"):
    result.thumb = getPhotoSize(n["thumb"])
  if n.hasKey("file_size"):
    result.fileSize = n["file_size"].num.int

proc getContact*(n: JsonNode): Contact =
  result.phoneNumber = n["phone_number"].str
  result.firstName = n["first_name"].str
  if n.hasKey("last_name"):
    result.lastName = n["last_name"].str
  if n.hasKey("user_id"):
    result.userId = n["user_id"].str

proc getLocation(n: JsonNode): Location =
  result.longitude = n["longitude"].fnum
  result.latitude = n["latitude"].fnum

proc getVenue(n: JsonNode): Venue =
  result.location = n["location"].getLocation()
  result.title = $n["title"]
  result.address = $n["address"]
  if n.hasKey("foursquare_id"):
    result.foursquareId = $n["foursquare_id"]

proc getUserProfilePhotos*(n: JsonNode): UserProfilePhotos =
  result.totalCount = n["total_count"].num.int
  result.photos = @[]
  for x in n["photos"]:
    result.photos.add(getPhoto(x))

proc getMessageEntity(n: JsonNode): MessageEntity =
  result.kind = $n["type"]
  result.offset = n["offset"].num.int
  result.length = n["length"].num.int
  if n.hasKey("url"):
    result.url = $n["url"]
  if n.hasKey("user"):
    result.user = n["user"].getUser()

proc getGame*(n: JsonNode): Game =
  result.title = $n["title"]
  result.description = $n["description"]
  result.photo = n["photo"].getPhoto()
  if n.hasKey("text"):
    result.text = $n["text"]
  if n.hasKey("text_entities"):
    result.textEntities = @[]
    for e in n["text_entities"]:
      result.textEntities.add(e.getMessageEntity())

proc getInvoice(n: JsonNode): Invoice =
  result.title = $n["title"]
  result.description = $n["description"]
  if n.hasKey("start_parametter"):
    result.startParameter = $n["start_parameter"]
  if n.hasKey("currency"):
    result.currency = $n["currency"]
  if n.hasKey("total_amount"):
    result.totalAmount = n["total_amount"].num.int

proc getFile*(n: JsonNode): types.File =
  result.fileId = $n["file_id"]
  if n.hasKey("file_size"):
    result.fileSize = n["file_size"].num.int
  if n.hasKey("file_path"):
    result.filePath = $n["file_path"]

proc getChatMember*(n: JsonNode): ChatMember =
  result.user = n["user"].getUser()
  result.status = $n["status"]

proc getSuccessfulPayment(n: JsonNode): SuccessfulPayment =
  ## TODO
  discard

proc getMessage*(n: JsonNode): Message =
  new(result)
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

proc processUpdates*(b: TeleBot, n: JsonNode): seq[Update] =
  result = @[]
  var u: Update
  for x in n:
    u.updateId = x["update_id"].num.int
    if u.updateId > b.lastUpdateId:
      b.lastUpdateId = u.updateId
    u.message = getMessage(x["message"])
  result.add(u)


proc `$`*(k: KeyboardButton): string =
  var j = newJObject()
  j["text"] = %k.text
  if k.requestContact:
    j["request_contact"] = %true
  if k.requestLocation:
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

proc initReplyKeyboardMarkup*(kb: seq[seq[KeyboardButton]], rk = false, otk = false, s = false): ReplyKeyboardMarkup =
  result.keyboard = kb
  result.resizeKeyboard = rk
  result.oneTimeKeyboard = otk
  result.selective = s

proc ReplyKeyboardRemove*(s = false): string =
  var json = %*{"remove_keyboard": true, "selective": s }
  result = $json

proc ForceReply*(s = false): string =
  var json = %*{"force_reply": true, "selective": s }
  result = $json

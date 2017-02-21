import httpclient
import json
import strutils
import tempfile
import os
import uri

const
  API_URL = "https://api.telegram.org/bot$#/$#"

type
  TeleBot* = ref object
    token: string
    lastUpdateId: BiggestInt

  ChatKind* = enum
    kPrivateChat
    kGroupChat

  User* = object
    id*: int
    firstName*: string
    lastName*: string
    username*: string

  GroupChat* = object
    id*: int
    title*: string

  Chat* = object
    case kind*: ChatKind
    of kPrivateChat:
      user*: User
    of kGroupChat:
      group*: GroupChat

  PhotoSize* = object
    fileId*: string
    width*: int
    height*: int
    fileSize*: int

  Audio* = object
    fileId*: string
    duration*: int
    mimeType*: string
    fileSize*: int

  Document* = object
    fileId*: string
    thumb*: PhotoSize
    fileName*: string
    mimeType*: string
    fileSize*: int

  Sticker* = object
    fileId*: string
    width*: int
    height*: int
    thumb*: PhotoSize
    fileSize*: int

  Video* = object
    fileId*: string
    width*: int
    height*: int
    duration*: int
    thumb*: PhotoSize
    mimeType*: string
    fileSize*: int
    caption*: string

  Contact* = object
    phoneNumber*: string
    firstName*: string
    lastName*: string
    userId*: string

  Location* = object
    longitude*: float
    latitude*: float

  UserProfilePhotos* = object
    totalCount*: int
    photos*: seq[seq[PhotoSize]]

  KeyboardKind* = enum
    ReplyKeyboardHide
    ReplyKeyboardMarkup
    ForceReply

  KeyboardMarkup* = ref object
    selective*: bool
    case kind*: KeyboardKind
    of ReplyKeyboardMarkup:
      keyboard*: seq[seq[string]]
      resizeKeyboard*: bool
      oneTimeKeyboard*: bool
    of ReplyKeyboardHide:
      hideKeyboard*: bool
    of ForceReply:
      forceReply*: bool

  MessageKind* = enum
    kText
    kAudio
    kDocument
    kPhoto
    kSticker
    kVideo
    kContact
    kLocation
    kNewChatParticipant
    kLeftChatParticipant
    kNewChatTitle
    kNewChatPhoto
    kDeleteChatPhoto
    kGroupChatCreated


  Message* = ref object
    messageId*: int
    fromUser*: User
    date*: int
    chat*: Chat
    forwardFrom*: User
    forwardDate*: int
    replyToMessage*: Message
    case kind*: MessageKind
    of kText:
      text*: string
    of kAudio:
      audio*: Audio
    of kDocument:
      document*: Document
    of kPhoto:
      photo*: seq[PhotoSize]
    of kSticker:
      sticker*: Sticker
    of kVideo:
      video*: Video
    of kContact:
      contact*: Contact
    of kLocation:
      location*: Location
    of kNewChatParticipant:
      newChatParticipant*: User
    of kLeftChatParticipant:
      leftChatParticipant*: User
    of kNewChatTitle:
      newChatTitle*: string
    of kNewChatPhoto:
      newChatPhoto: seq[PhotoSize]
    of kDeleteChatPhoto:
      deleteChatPhoto: bool
    of kGroupChatCreated:
      groupChatCreated: bool

  Update* = object
    updateId*: int
    message*: Message

proc `$`*(k: KeyboardMarkup): string =
  var j = newJObject()
  j["selective"] = %k.selective
  case k.kind
  of ReplyKeyboardMarkup:
    var kb = newJArray()
    for x in k.keyboard:
      var n = newJArray()
      for y in x:
        n.add(%y)
      kb.add(n)

    j["keyboard"] = kb
    j["resize_keyboard"] = %k.resizeKeyboard
    j["one_time_keyboard"] = %k.oneTimeKeyboard
  of ReplyKeyboardHide:
    j["hide_keyboard"] = %k.hideKeyboard
  of ForceReply:
    j["force_reply"] = %k.forceReply
  result = $j

proc id*(c: Chat): int =
  case c.kind
  of kPrivateChat:
    result = c.user.id
  of kGroupChat:
    result = c.group.id

proc newReplyKeyboardMarkup*(kb: seq[seq[string]], rk = false, otk = false, s = false): KeyboardMarkup =
  new(result)
  result.kind = ReplyKeyboardMarkup
  result.keyboard = kb
  result.resizeKeyboard = rk
  result.oneTimeKeyboard = otk
  result.selective = s

proc newReplyKeyboardHide*(hide = true, s = false): KeyboardMarkup =
  new(result)
  result.kind = ReplyKeyboardHide
  result.hideKeyboard = hide
  result.selective = s

proc newForceReply*(f = true, s = false): KeyboardMarkup =
  new(result)
  result.kind = ForceReply
  result.forceReply = f
  result.selective = s

proc parseUser(n: JsonNode): User =
  result.id = n["id"].num.int
  result.firstName = n["first_name"].str
  if n.hasKey("last_name"):
    result.lastName = n["last_name"].str
  if n.hasKey("username"):
    result.username = n["username"].str

proc parseGroupChat(n: JsonNode): GroupChat =
  result.id = n["id"].num.int
  result.title = n["title"].str

proc parseChat(n: JsonNode): Chat =
  if n["id"].num.int > 0:
    result.kind = kPrivateChat
    result.user = parseUser(n)
  else:
    result.kind = kGroupChat
    result.group = parseGroupChat(n)

proc parseAudio(n: JsonNode): Audio =
  result.fileId = n["file_id"].str
  result.duration = n["duration"].num.int
  if n.hasKey("mime_type"):
    result.mimeType = n["mime_type"].str
  if n.hasKey("file_size"):
    result.fileSize = n["file_size"].num.int

proc parsePhotoSize(n: JsonNode): PhotoSize =
  if n.hasKey("file_id"):
    result.fileId = n["file_id"].str
    result.width = n["width"].num.int
    result.height = n["height"].num.int
    if n.hasKey("file_size"):
      result.fileSize = n["file_size"].num.int

proc parsePhoto(n: JsonNode): seq[PhotoSize] =
  result = @[]
  for x in n:
    result.add(parsePhotoSize(x))

proc parseDocument(n: JsonNode): Document =
  result.fileId = n["file_id"].str
  if n.hasKey("thumb"):
    result.thumb = parsePhotoSize(n["thumb"])
  if n.hasKey("file_name"):
    result.fileName = n["file_name"].str
  if n.hasKey("mime_type"):
    result.mimeType = n["mime_type"].str
  if n.hasKey("file_size"):
    result.fileSize = n["file_size"].num.int

proc parseSticker(n: JsonNode): Sticker =
  result.fileId = n["file_id"].str
  result.width = n["width"].num.int
  result.height = n["height"].num.int
  if n.hasKey("thumb"):
    result.thumb = parsePhotoSize(n["thumb"])
  if n.hasKey("file_size"):
    result.fileSize = n["file_size"].num.int

proc parseVideo(n: JsonNode): Video =
  result.fileId = n["file_id"].str
  result.width = n["width"].num.int
  result.height = n["height"].num.int
  result.duration = n["duration"].num.int
  if n.hasKey("thumb"):
    result.thumb = parsePhotoSize(n["thumb"])
  if n.hasKey("mime_type"):
    result.mimeType = n["mime_type"].str
  if n.hasKey("file_size"):
    result.fileSize = n["file_size"].num.int
  if n.hasKey("caption"):
    result.caption = n["caption"].str

proc parseContact(n: JsonNode): Contact =
  result.phoneNumber = n["phone_number"].str
  result.firstName = n["first_name"].str
  if n.hasKey("last_name"):
    result.lastName = n["last_name"].str
  if n.hasKey("user_id"):
    result.userId = n["user_id"].str

proc parseLocation(n: JsonNode): Location =
  result.longitude = n["longitude"].fnum
  result.latitude = n["latitude"].fnum

proc parseUserProfilePhotos(n: JsonNode): UserProfilePhotos =
  result.totalCount = n["total_count"].num.int
  result.photos = @[]
  for x in n["photos"]:
    result.photos.add(parsePhoto(x))

proc parseMessage(n: JsonNode): Message =
  new(result)
  result.messageId = n["message_id"].num.int
  result.fromUser = parseUser(n["from"])
  result.date = n["date"].num.int
  result.chat = parseChat(n["chat"])

  if n.hasKey("forward_from"):
    result.forwardFrom = parseUser(n["forward_from"])
  if n.hasKey("forward_date"):
    result.forwardDate = n["forward_date"].num.int
  if n.hasKey("reply_to_message"):
    result.replyToMessage = parseMessage(n["reply_to_message"])
  if n.hasKey("text"):
    result.kind = kText
    result.text = n["text"].str
  elif n.hasKey("audio"):
    result.kind = kAudio
    result.audio = parseAudio(n["audio"])
  elif n.hasKey("document"):
    result.kind = kDocument
    result.document = parseDocument(n["document"])
  elif n.hasKey("photo"):
    result.kind = kPhoto
    result.photo = parsePhoto(n["photo"])
  elif n.hasKey("sticker"):
    result.kind = kSticker
    result.sticker = parseSticker(n["sticker"])
  elif n.hasKey("video"):
    result.kind = kVideo
    result.video = parseVideo(n["video"])
  elif n.hasKey("contact"):
    result.kind = kContact
    result.contact = parseContact(n["contact"])
  elif n.hasKey("location"):
    result.kind = kLocation
    result.location = parseLocation(n["location"])
  elif n.hasKey("new_chat_participant"):
    result.kind = kNewChatParticipant
    result.newChatParticipant = parseUser(n["new_chat_participant"])
  elif n.hasKey("left_chat_participant"):
    result.kind = kLeftChatParticipant
    result.leftChatParticipant = parseUser(n["left_chat_participant"])
  elif n.hasKey("new_chat_title"):
    result.kind = kNewChatTitle
    result.newChatTitle = n["new_chat_title"].str
  elif n.hasKey("new_chat_photo"):
    result.kind = kNewChatPhoto
    result.newChatPhoto = parsePhoto(n["new_chat_photo"])
  elif n.hasKey("delete_chat_photo"):
    result.kind = kAudio
    result.deleteChatPhoto = n["delete_chat_photo"].bval
  elif n.hasKey("group_chat_created"):
    result.kind = kGroupChatCreated
    result.groupChatCreated = n["group_chat_created"].bval

proc parseUpdates(b: TeleBot, n: JsonNode): seq[Update] =
  result = @[]
  var u: Update
  for x in n:
    u.updateId = x["update_id"].num.int
    if u.updateId > b.lastUpdateId:
      b.lastUpdateId = u.updateId
    u.message = parseMessage(x["message"])
    result.add(u)

proc newTeleBot*(token: string): TeleBot =
  ## Init new Telegram Bot instance
  new(result)
  result.token = token
  result.lastUpdateId = 0

include private/sync
when not compileOption("threads"):
  include private/async

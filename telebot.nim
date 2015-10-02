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
  result.kind = ReplyKeyboardMarkup
  result.keyboard = kb
  result.resizeKeyboard = rk
  result.oneTimeKeyboard = otk
  result.selective = s

proc newReplyKeyboardHide*(hide = true, s = false): KeyboardMarkup =
  result.kind = ReplyKeyboardHide
  result.hideKeyboard = hide
  result.selective = s

proc newForceReply*(f = true, s = false): KeyboardMarkup =
  result.kind = ForceReply
  result.forceReply = f
  result.selective = s

proc parseUser(n: JsonNode): User =
  result.id = n["id"].num.int
  result.firstName = n["first_name"].str
  if not n["last_name"].isNil:
    result.lastName = n["last_name"].str
  if not n["username"].isNil:
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
  if not n["mime_type"].isNil:
    result.mimeType = n["mime_type"].str
  if not n["file_size"].isNil:
    result.fileSize = n["file_size"].num.int

proc parsePhotoSize(n: JsonNode): PhotoSize =
  if n.hasKey("file_id"):
    result.fileId = n["file_id"].str
    result.width = n["width"].num.int
    result.height = n["height"].num.int
    if not n["file_size"].isNil:
      result.fileSize = n["file_size"].num.int

proc parsePhoto(n: JsonNode): seq[PhotoSize] =
  result = @[]
  for x in n:
    result.add(parsePhotoSize(x))

proc parseDocument(n: JsonNode): Document =
  result.fileId = n["file_id"].str
  if n.hasKey("thumb"):
    result.thumb = parsePhotoSize(n["thumb"])
  if not n["file_name"].isNil:
    result.fileName = n["file_name"].str
  if not n["mime_type"].isNil:
    result.mimeType = n["mime_type"].str
  if not n["file_size"].isNil:
    result.fileSize = n["file_size"].num.int

proc parseSticker(n: JsonNode): Sticker =
  result.fileId = n["file_id"].str
  result.width = n["width"].num.int
  result.height = n["height"].num.int
  if n.hasKey("thumb"):
    result.thumb = parsePhotoSize(n["thumb"])
  if not n["file_size"].isNil:
    result.fileSize = n["file_size"].num.int

proc parseVideo(n: JsonNode): Video =
  result.fileId = n["file_id"].str
  result.width = n["width"].num.int
  result.height = n["height"].num.int
  result.duration = n["duration"].num.int
  if n.hasKey("thumb"):
    result.thumb = parsePhotoSize(n["thumb"])
  if not n["mime_type"].isNil:
    result.mimeType = n["mime_type"].str
  if not n["file_size"].isNil:
    result.fileSize = n["file_size"].num.int
  if not n["caption"].isNil:
    result.caption = n["caption"].str

proc parseContact(n: JsonNode): Contact =
  result.phoneNumber = n["phone_number"].str
  result.firstName = n["first_name"].str
  if not n["last_name"].isNil:
    result.lastName = n["last_name"].str
  if not n["user_id"].isNil:
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

  if not n["forward_from"].isNil:
    result.forwardFrom = parseUser(n["forward_from"])
  if not n["forward_date"].isNil:
    result.forwardDate = n["forward_date"].num.int
  if not n["reply_to_message"].isNil:
    result.replyToMessage = parseMessage(n["reply_to_message"])
  if not n["text"].isNil:
    result.kind = kText
    result.text = n["text"].str
  elif not n["audio"].isNil:
    result.kind = kAudio
    result.audio = parseAudio(n["audio"])
  elif not n["document"].isNil:
    result.kind = kDocument
    result.document = parseDocument(n["document"])
  elif not n["photo"].isNil:
    result.kind = kPhoto
    result.photo = parsePhoto(n["photo"])
  elif not n["sticker"].isNil:
    result.kind = kSticker
    result.sticker = parseSticker(n["sticker"])
  elif not n["video"].isNil:
    result.kind = kVideo
    result.video = parseVideo(n["video"])
  elif not n["contact"].isNil:
    result.kind = kContact
    result.contact = parseContact(n["contact"])
  elif not n["location"].isNil:
    result.kind = kLocation
    result.location = parseLocation(n["location"])
  elif not n["new_chat_participant"].isNil:
    result.kind = kNewChatParticipant
    result.newChatParticipant = parseUser(n["new_chat_participant"])
  elif not n["left_chat_participant"].isNil:
    result.kind = kLeftChatParticipant
    result.leftChatParticipant = parseUser(n["left_chat_participant"])
  elif not n["new_chat_title"].isNil:
    result.kind = kNewChatTitle
    result.newChatTitle = n["new_chat_title"].str
  elif not n["new_chat_photo"].isNil:
    result.kind = kNewChatPhoto
    result.newChatPhoto = parsePhoto(n["new_chat_photo"])
  elif not n["delete_chat_photo"].isNil:
    result.kind = kAudio
    result.deleteChatPhoto = n["delete_chat_photo"].bval
  elif not n["group_chat_created"].isNil:
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

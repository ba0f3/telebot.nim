import asyncdispatch
import httpclient
import json
import strutils
import tempfile
const
  API_URL = "https://api.telegram.org/bot$#/$#"

type
  TeleBot* = ref object of RootObj
    token: string
    lastUpdateId: BiggestInt

  ChatKind* = enum
    kPrivateChat
    kGroupChat

  User* = ref object of RootObj
    id*: int
    firstName*: string
    lastName*: string
    username*: string

  GroupChat* = ref object of RootObj
    id*: int
    title*: string

  Chat* = ref object of RootObj
    case kind*: ChatKind
    of kPrivateChat:
      user*: User
    of kGroupChat:
      group*: GroupChat

  PhotoSize* = ref object of RootObj
    fileId*: string
    width*: int
    height*: int
    fileSize*: int
      
  Audio* = ref object of RootObj
    fileId*: string
    duration*: int
    mimeType*: string
    fileSize*: int

  Document* = ref object of RootObj
    fileId*: string
    thumb*: PhotoSize
    fileName*: string
    mimeType*: string
    fileSize*: int

  Sticker* = ref object of RootObj
    fileId*: string
    width*: int
    height*: int
    thumb*: PhotoSize
    fileSize*: int
    
  Video* = ref object of RootObj
    fileId*: string  
    width*: int
    height*: int
    duration*: int
    thumb*: PhotoSize
    mimeType*: string
    fileSize*: int
    caption*: string
    
  Contact* = ref object of RootObj
    phoneNumber*: string
    firstName*: string
    lastName*: string
    userId*: string

  Location* = ref object of RootObj
    longitude*: float
    latitude*: float

  UserProfilePhotos* = ref object of RootObj
    totalCount*: int
    photos*: seq[seq[PhotoSize]]

  KeyboardKind* = enum
    ReplyKeyboardHide
    ReplyKeyboardMarkup
    ForceReply

  KeyboardMarkup* = ref object of RootObj
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
          

  Message* = ref object of RootObj
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
  Update* = ref object of RootObj
    updateId*: int
    message*: Message

proc `$`*(k: KeyboardMarkup): string =
  var j = newJObject()
  j["selective"] = %k.selective
  case k.kind  
  of ReplyKeyboardMarkup:
    var keyboard: seq[string] = @[]
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
  new(result)      
  result.id = n["id"].num.int
  result.firstName = n["first_name"].str
  if not n["last_name"].isNil:
    result.lastName = n["last_name"].str
  if not n["username"].isNil:
    result.username = n["username"].str

proc parseGroupChat(n: JsonNode): GroupChat =
  new(result)    
  result.id = n["id"].num.int
  result.title = n["title"].str
    
proc parseChat(n: JsonNode): Chat =
  new(result)
  if n["id"].num.int > 0:
    result.kind = kPrivateChat
    result.user = parseUser(n)
  else:
    result.kind = kGroupChat
    result.group = parseGroupChat(n)

proc parseAudio(n: JsonNode): Audio =
  new(result)
  result.fileId = n["file_id"].str
  result.duration = n["duration"].num.int
  if not n["mime_type"].isNil:
    result.mimeType = n["mime_type"].str
  if not n["file_size"].isNil:
    result.fileSize = n["file_size"].num.int

proc parsePhotoSize(n: JsonNode): PhotoSize =
  new(result)
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
  new(result)
  result.fileId = n["file_id"].str
  result.thumb = parsePhotoSize(n["thumb"])
  if not n["file_name"].isNil:
    result.fileName = n["file_name"].str
  if not n["mime_type"].isNil:
    result.mimeType = n["mime_type"].str
  if not n["file_size"].isNil:
    result.fileSize = n["file_size"].num.int

proc parseSticker(n: JsonNode): Sticker =
  new(result)
  result.fileId = n["file_id"].str
  result.width = n["width"].num.int
  result.height = n["height"].num.int  
  result.thumb = parsePhotoSize(n["thumb"])  
  if not n["file_size"].isNil:
    result.fileSize = n["file_size"].num.int

proc parseVideo(n: JsonNode): Video =
  new(result)
  result.fileId = n["file_id"].str
  result.width = n["width"].num.int
  result.height = n["height"].num.int
  result.duration = n["duration"].num.int  
  result.thumb = parsePhotoSize(n["thumb"])
  if not n["mime_type"].isNil:
    result.mimeType = n["mime_type"].str  
  if not n["file_size"].isNil:
    result.fileSize = n["file_size"].num.int
  if not n["caption"].isNil:
    result.caption = n["caption"].str

proc parseContact(n: JsonNode): Contact =
  new(result)
  result.phoneNumber = n["phone_number"].str
  result.firstName = n["first_name"].str
  if not n["last_name"].isNil:
    result.lastName = n["last_name"].str
  if not n["user_id"].isNil:
    result.userId = n["user_id"].str

proc parseLocation(n: JsonNode): Location =
  new(result)
  result.longitude = n["longitude"].fnum
  result.latitude = n["latitude"].fnum

proc parseUserProfilePhotos(n: JsonNode): UserProfilePhotos =
  new(result)
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
    new(u)    
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

proc makeRequest(endpoint: string, data: MultipartData = nil): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  let r = await client.post(endpoint, multipart=data)
  if r.status.startsWith("200"):    
    var obj = parseJson(r.body)
    if obj["ok"].bval == true:
      result = obj["result"]
  else:
    raise newException(IOError, r.status)    
  client.close()
    
  
proc getMe*(b: TeleBot): Future[User] {.async.} =
  ## Returns basic information about the bot in form of a ``User`` object.  
  let endpoint  = API_URL % [b.token, "getMe"]
  let res = await makeRequest(endpoint)
  result = parseUser(res)

proc sendMessage*(b: TeleBot, chatId: int, text: string, disableWebPagePreview = false, replyToMessageId = 0, replyMarkup: KeyboardMarkup = nil): Future[Message] {.async.} =
  let endpoint = API_URL % [b.token, "sendMessage"]
  var data = newMultipartData()  
  data["chat_id"] = $chatId
  data["text"] = text
  if disableWebPagePreview:
    data["disable_web_page_preview"] = "true"
  if replyToMessageId != 0:
    data["reply_to_message_id"] = $replyToMessageId
  if not replyMarkup.isNil:
    data["reply_markup"] = $replyMarkup

  let res = await makeRequest(endpoint, data)
  result = parseMessage(res)
    

proc forwardMessage*(b: TeleBot, chatId: int, fromChatId: int, messageId: int): Future[Message] {.async.} =
  let endpoint = API_URL % [b.token, "forwardMessage"]
  var data = newMultipartData()  
  data["chat_id"] = $chatId
  data["from_chat_id"] = $fromChatId
  data["message_id"] = $messageId

  let res = await makeRequest(endpoint, data)
  result = parseMessage(res)
    

proc sendPhoto*(b: TeleBot, chatId: int, photo: string, resend = false,cap = "", rtmId = 0, rM: KeyboardMarkup = nil): Future[Message] {.async.} =
  let endpoint = API_URL % [b.token, "sendPhoto"]
  var data = newMultipartData()
  data["chat_id"] = $chatId

  if resend:
    # resend file_id
    data["photo"] = photo
  else:
    if photo.startsWith("http"):
      var (_, _, ext) = photo.splitFile()
      let tmp = mktemp(suffix=ext)
      downloadFile(photo, tmp)
      data.addFiles({"photo": tmp})
      tmp.removeFile
    else:
      data.addFiles({"photo": photo})

  if cap != "":
    data["caption"] = cap
  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not rM.isNil:
    data["reply_markup"] = $rM

  let res = await makeRequest(endpoint, data)
  result = parseMessage(res)

proc sendFile(b: TeleBot, m: string, chatId: int, f: string, resend = false, rtmId = 0, rM: KeyboardMarkup = nil): Future[Message] {.async.} =
  let endpoint = API_URL % [b.token, m]

  var data = newMultipartData()
  data["chat_id"] = $chatId
  
  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not rM.isNil:
    data["reply_markup"] = $rM

  let res = await makeRequest(endpoint, data)
  result = parseMessage(res)

  
proc sendAudio*(b: TeleBot, chatId: int, audio: string, resend = false, rtmId = 0, rM: KeyboardMarkup = nil): Future[Message] {.async.} =
  result = await b.sendFile("sendAudio", chatId, audio, resend, rtmId, rM)

proc sendDocument*(b: TeleBot, chatId: int, audio: string, resend = false, rtmId = 0, rM: KeyboardMarkup = nil): Future[Message] {.async.} =
  result = await b.sendFile("sendDocument", chatId, audio, resend, rtmId, rM)

proc sendSticker*(b: TeleBot, chatId: int, audio: string, resend = false, rtmId = 0, rM: KeyboardMarkup = nil): Future[Message] {.async.} =
  result = await b.sendFile("sendSticker", chatId, audio, resend, rtmId, rM)

proc sendVideo*(b: TeleBot, chatId: int, audio: string, resend = false, rtmId = 0, rM: KeyboardMarkup = nil): Future[Message] {.async.} =
  result = await b.sendFile("sendVideo", chatId, audio, resend, rtmId, rM)

proc sendLocation*(b: TeleBot, chatId: int, lat, long: float, rtmId = 0, rM: KeyboardMarkup = nil): Future[Message] {.async.} =
  let endpoint = API_URL % [b.token, "sendLocation"]

  var data = newMultipartData()
  data["chat_id"] = $chatId
  data["longitude"] = $long
  data["latitude"] = $lat
  
  if rtmId != 0:
    data["reply_to_message_id"] = $rtmId
  if not rM.isNil:
    data["reply_markup"] = $rM

  let res = await makeRequest(endpoint, data)
  result = parseMessage(res)

proc sendChatAction*(b: TeleBot, chatId: int, action: string): Future[void] {.async.} =
  let endpoint = API_URL % [b.token, "sendChatAction"]
  var data = newMultipartData()
  data["chat_id"] = $chatId
  data["action"] = action

  discard makeRequest(endpoint, data)
  
proc getUserProfilePhotos*(b: TeleBot, userId: int, offset = 0, limit = 100): Future[UserProfilePhotos] {.async.} =
  let endpoint = API_URL % [b.token, "getUserProfilePhotos"]
  var data = newMultipartData()
  data["user_id"] = $userId
  data["limit"] = $limit
  
  if offset != 0:
    data["offset"] = $offset
  let res = await makeRequest(endpoint, data)
  result = parseUserProfilePhotos(res)

proc getUpdates*(b: TeleBot, offset, limit, timeout = 0): Future[seq[Update]] {.async.} =
  let endpoint = API_URL % [b.token, "getUpdates"]
  var data = newMultipartData()
  
  if offset != 0:
    data["offset"] = $offset
  else:
    data["offset"] = $(b.lastUpdateId+1)
  if limit != 0:
    data["limit"] = $limit
  if timeout != 0:
    data["timeout"] = $timeout

  let res = await makeRequest(endpoint, data)
  result = parseUpdates(b, res)

proc setWebhook*(b: TeleBot, url: string) {.async.} =
  let endpoint = API_URL % [b.token, "setWebhook"]
  var data = newMultipartData()  
  data["url"] = url
  
  discard await makeRequest(endpoint, data)
  

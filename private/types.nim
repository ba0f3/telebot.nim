import optional

type
  TelegramObject* = object of RootObj

  TeleBot* = ref object of TelegramObject
    token*: string
    lastUpdateId*: BiggestInt

  True = distinct bool
  
  User* = object of TelegramObject
    id*: int
    firstName*: string
    lastName*: Optional[string]
    username*: Optional[string]
    languageCode*: Optional[string]

  Chat* = object of TelegramObject
    id*: int
    kind*: string
    title*: Optional[string]
    username*: Optional[string]
    firstName*: Optional[string]
    lastName*: Optional[string]
    allMembersAreAdministrators*: Optional[bool]

  PhotoSize* = object of TelegramObject
    fileId*: string
    width*: int
    height*: int
    fileSize*: Optional[int]

  Audio* = object of TelegramObject
    fileId*: string
    duration*: int
    performer*: Optional[string]
    title*: Optional[string]
    mimeType*: Optional[string]
    fileSize*: Optional[int]

  Document* = object of TelegramObject
    fileId*: string
    thumb*: Optional[PhotoSize]
    fileName*: Optional[string]
    mimeType*: Optional[string]
    fileSize*: Optional[int]

  Sticker* = object of TelegramObject
    fileId*: string
    width*: int
    height*: int
    thumb*: Optional[PhotoSize]
    emoji*: Optional[string]
    fileSize*: OPtional[int]

  Video* = object of TelegramObject
    fileId*: string
    width*: int
    height*: int
    duration*: int
    thumb*: Optional[PhotoSize]
    mimeType*: Optional[string]
    fileSize*: Optional[int]

  Voice* = object of TelegramObject
    fileId*: string
    duration*: int
    mimeType*: Optional[string]
    fileSize*: Optional[int]

  VideoNote* = object of TelegramObject
    fileId*: string
    length*: int
    duration*: int
    thumb*: Optional[PhotoSize]
    fileSize*: Optional[int]

  Contact* = object of TelegramObject
    phoneNumber*: string
    firstName*: string
    lastName*: Optional[string]
    userId*: Optional[string]

  Location* = object of TelegramObject
    longitude*: float
    latitude*: float

  Venue* = object of TelegramObject
    location*: Location
    title*: string
    address*: string
    foursquareId*: Optional[string]

  UserProfilePhotos* = object of TelegramObject
    totalCount*: int
    photos*: seq[seq[PhotoSize]]

  File* = object of TelegramObject
    fileId*: string
    fileSize*: int
    filePath*: string

  KeyboardButton* = object of TelegramObject
    text*: string
    requestContact*: Optional[bool]
    requestLocation*: Optional[bool]

  KeyboardMarkup* = object of TelegramObject

  ReplyKeyboardMarkup* = object of KeyboardMarkup
    keyboard*: seq[seq[KeyboardButton]]
    resizeKeyboard*: Optional[bool]
    oneTimeKeyboard*: Optional[bool]
    selective*: Optional[bool]

  ReplyKeyboardRemove* = object of KeyboardMarkup
    removeKeyboard*: True
    selective*: Optional[bool]

  ForceReply* = object of KeyboardMarkup
    forceReply*: True
    selective*: Optional[bool]

  CallbackGame* = object of TelegramObject


  CallbackQuery* = ref object of TelegramObject
    id*: string
    fromUser*: User
    message*: Optional[Message]
    inlineMessageId*: Optional[string]
    chatInstance*: Optional[string]
    data*: Optional[string]
    gameShortName*: Optional[string]

  MessageEntity* = object of TelegramObject
    kind*: string
    offset*: int
    length*: int
    url*: Optional[string]
    user*: Optional[User]

  MessageKind* = enum
    kText
    kAudio
    kDocument
    kGame
    kPhoto
    kSticker
    kVideo
    kVoice
    kVideoNote
    kContact
    kLocation
    kVenue
    kNewChatMember
    kLeftChatMember
    kNewChatTitle
    kNewChatPhoto
    kDeleteChatPhoto
    kGroupChatCreated
    kSupergroupChatCreated
    kChannelChatCreated
    kMigrateToChatId
    kMigrateFromChatId
    kPinnedMessage
    kInvoice
    kSuccessfulPayment

  
  Message* = object of TelegramObject
    messageId*: int
    fromUser*: Optional[User]
    date*: int
    chat*: Chat
    forwardFrom*: Optional[User]
    forwardFromChat*: Optional[Chat]
    forwardFromMessageId*: Optional[int]
    forwardDate*: Optional[int]
    replyToMessage*: Optional[ref Message]
    editDate*: Optional[int]
    caption*: Optional[string]
    text*: Optional[string]
    entities*: Optional[seq[MessageEntity]]
    audio*: Optional[Audio]
    document*: Optional[Document]
    game*: Optional[Game]
    photo*: Optional[seq[PhotoSize]]
    sticker*: Optional[Sticker]
    video*: Optional[Video]
    voice*: Optional[Voice]
    videoNote*: Optional[VideoNote]
    contact*: Optional[Contact]
    location*: Optional[Location]
    venue*: Optional[Venue]
    newChatMembers*: Optional[seq[User]]
    newChatMember*: Optional[User]
    leftChatMember*: Optional[User]
    newChatTitle*: Optional[string]
    newChatPhoto*: Optional[seq[PhotoSize]]
    migrateToChatId*: Optional[int]
    migrateFromChatId*: Optional[int]
    pinnedMessage*: Optional[ref Message]
    invoice*: Optional[Invoice]
    successfulPayment*: Optional[SuccessfulPayment]

  ChatMember* = object of TelegramObject
    user*: User
    status*: string

  ResponseParameters* = object of TelegramObject
    migrateToChatId*: Optional[int]
    retryAfter*: Optional[int]

  InlineQuery* = object of TelegramObject
  ChosenInlineResult* = object of TelegramObject

  UpdateKind* = enum
    kMessage
    kEditedMessage
    kChannelPost
    kEditedChannelPost
    kInlineQuery
    kChosenInlineQuery
    kCallbackQuery
    kShippingQuery
    kPreCheckoutQuery

  Update* = object of TelegramObject
    updateId*: int
    case kind*: UpdateKind
    of kMessage:
      message*: Message
    of kEditedMessage:
      editedMessage*: Message
    of kChannelPost:
      channelPost*: Message
    of kEditedChannelPost:
      editedChannelPost*: Message
    of kInlineQuery:
      inlineQuery*: InlineQuery
    of kChosenInlineQuery:
      chosenInlineResult*: ChosenInlineResult
    of kCallbackQuery:
      callbackQuery*: CallbackQuery
    of kShippingQuery:
      shippingQuery*: ShippingQuery
    of kPreCheckoutQuery:
      preCheckoutQuery*: PreCheckoutQuery

  #------------------
  # Game
  #------------------
  Animation* = object of TelegramObject
    fileId*: string
    thumb*: Optional[PhotoSize]
    fileName*: Optional[string]
    mimeType*: Optional[string]
    fileSize*: Optional[int]

  Game* = object of TelegramObject
    title*: string
    description*: string
    photo*: seq[PhotoSize]
    text*: Optional[string]
    textEntities*: Optional[seq[MessageEntity]]
    animation*: Optional[Animation]

  #------------------
  # Payment
  #------------------
  Invoice* = object of TelegramObject
    title*: string
    description*: string
    startParameter*: string
    currency*: string
    totalAmount*: int

  ShippingAddress* = object of TelegramObject
    countryCode*: string
    state*: string
    city*: string
    streetLine1*: string
    streetLine2*: string
    postCode*: string

  OrderInfo* = object of TelegramObject
    name*: Optional[string]
    phoneNumber*: Optional[string]
    email*: Optional[string]
    shippingAddress*: Optional[ShippingAddress]

  LabeledPrice* = object of TelegramObject
    label*: string
    amount*: int

  ShippingOption* = object of TelegramObject
    id*: string
    title*: string
    prices*: seq[LabeledPrice]

  SuccessfulPayment* = object of TelegramObject
    currentcy*: string
    totalAmount*: int
    invoicePayload*: string
    shippingOptionId*: Optional[string]
    orderInfo*: Optional[OrderInfo]
    telegramPaymentChargeId*: string
    providerPaymentChargeId*: string

  ShippingQuery* = object of TelegramObject
    id*: string
    fromUser*: User
    invoicePayload*: string
    shippingAddress*: ShippingAddress

  PreCheckoutQuery* = object of TelegramObject
    id*: string
    fromUser*: User
    currency*: string
    totalAmount*: int
    invoicePayload*: string
    shippingOptionId*: Optional[string]
    orderInfo*: Optional[OrderInfo]

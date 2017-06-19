
type
  TeleBot* = ref object of RootObj
    token*: string
    lastUpdateId*: BiggestInt

  User* = object
    id*: int
    firstName*: string
    lastName*: string
    username*: string
    languageCode*: string

  Chat* = object
    id*: int
    kind*: string
    title*: string
    username*: string
    firstName*: string
    lastName*: string
    allMembersAreAdministrators*: bool

  PhotoSize* = object
    fileId*: string
    width*: int
    height*: int
    fileSize*: int

  Audio* = object
    fileId*: string
    duration*: int
    performer*: string
    title*: string
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
    emoji*: string
    fileSize*: int

  Video* = object
    fileId*: string
    width*: int
    height*: int
    duration*: int
    thumb*: PhotoSize
    mimeType*: string
    fileSize*: int

  Voice* = object
    fileId*: string
    duration*: int
    mimeType*: string
    fileSize*: int

  VideoNote* = object
    fileId*: string
    length*: int
    duration*: int
    thumb*: PhotoSize
    fileSize*: int

  Contact* = object
    phoneNumber*: string
    firstName*: string
    lastName*: string
    userId*: string

  Location* = object
    longitude*: float
    latitude*: float

  Venue* = object
    location*: Location
    title*: string
    address*: string
    foursquareId*: string

  UserProfilePhotos* = object
    totalCount*: int
    photos*: seq[seq[PhotoSize]]

  File* = object
    fileId*: string
    fileSize*: int
    filePath*: string

  KeyboardButton* = object
    text*: string
    requestContact*: bool
    requestLocation*: bool

  ReplyKeyboardMarkup* = object
    keyboard*: seq[seq[KeyboardButton]]
    resizeKeyboard*: bool
    oneTimeKeyboard*: bool
    selective*: bool

  ReplyKeyboardRemove* = object
    removeKeyBoard*: bool
    selective*: bool

  CallbackGame* = object

  InlineKeyboardButton* = object
    text*: string
    url*: string
    callbackData*: string
    switchInlineQuery*: string
    switchInlineQueryCurrentChat*: string
    callbackGame*: CallbackGame
    pay*: bool

  InlineKeyboardMarkup* = object
    inlineKeyboard*: seq[seq[InlineKeyboardButton]]

  CallbackQuery* = object
    id*: string
    fromUser*: User
    message*: Message
    inlineMessageId*: string
    chatInstance*: string
    data*: string
    gameShortName*: string

  MessageEntity* = object
    kind*: string
    offset*: int
    length*: int
    url*: string
    user*: User

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

  Message* = ref object
    messageId*: int
    fromUser*: User
    date*: int
    chat*: Chat
    forwardFrom*: User
    forwardFromChat*: Chat
    forwardFromMessageId*: int
    forwardDate*: int
    replyToMessage*: Message
    editDate*: int
    caption*: string
    case kind*: MessageKind
    of kText:
      text*: string
      entities*: seq[MessageEntity]
    of kAudio:
      audio*: Audio
    of kDocument:
      document*: Document
    of kGame:
      game*: Game
    of kPhoto:
      photo*: seq[PhotoSize]
    of kSticker:
      sticker*: Sticker
    of kVideo:
      video*: Video
    of kVoice:
      voice*: Voice
    of kVideoNote:
      videoNote*: VideoNote
    of kContact:
      contact*: Contact
    of kLocation:
      location*: Location
    of kVenue:
      venue*: Venue
    of kNewChatMember:
      newChatMembers*: seq[User]
      newChatMember*: User
    of kLeftChatMember:
      leftChatMember*: User
    of kNewChatTitle:
      newChatTitle*: string
    of kNewChatPhoto:
      newChatPhoto*: seq[PhotoSize]
    of kMigrateToChatId:
      migrateToChatId*: int
    of kMigrateFromChatId:
      migrateFromChatId*: int
    of kPinnedMessage:
      pinnedMessage*: Message
    of kInvoice:
      invoice*: Invoice
    of kSuccessfulPayment:
      successfulPayment*: SuccessfulPayment
    else:
      discard

  ChatMember* = object
    user*: User
    status*: string

  ResponseParameters* = object
    migrateToChatId*: int
    retryAfter*: int

  Update* = object
    updateId*: int
    message*: Message
    editedMessage*: Message
    channelPost*: Message
    editedChannelPost*: Message
    inlineQuery*: InlineQuery
    chosenInlineResult*: ChosenInlineResult
    callbackQuery*: CallbackQuery
    shippingQuery*: ShippingQuery
    preCheckoutQuery*: PreCheckoutQuery

  #------------------
  # Game
  #------------------
  Animation* = object
    fileId*: string
    thumb*: PhotoSize
    fileName*: string
    mimeType*: string
    fileSize*: int

  Game* = object
    title*: string
    description*: string
    photo*: seq[PhotoSize]
    text*: string
    textEntities*: seq[MessageEntity]
    animation*: Animation

  #------------------
  # Payment
  #------------------
  Invoice* = object
    title*: string
    description*: string
    startParameter*: string
    currency*: string
    totalAmount*: int

  ShippingAddress* = object
    countryCode*: string
    state*: string
    city*: string
    streetLine1*: string
    streetLine2*: string
    postCode*: string

  OrderInfo* = object
    name*: string
    phoneNumber*: string
    email*: string
    shippingAddress*: ShippingAddress

  LabeledPrice* = object
    label*: string
    amount*: int

  ShippingOption* = object
    id*: string
    title*: string
    prices*: seq[LabeledPrice]

  SuccessfulPayment* = object
    currentcy*: string
    totalAmount*: int
    invoicePayload*: string
    shippingOptionId*: string
    orderInfo*: OrderInfo
    telegramPaymentChargeId*: string
    providerPaymentChargeId*: string

  ShippingQuery* = object
    id*: string
    fromUser*: User
    invoicePayload*: string
    shippingAddress*: ShippingAddress

  PreCheckoutQuery* = object
    id*: string
    fromUser*: User
    currency*: string
    totalAmount*: int
    invoicePayload*: string
    shippingOptionId*: string
    orderInfo*: OrderInfo

  #------------------
  # Inline Query
  #------------------
  InlineQueryResult* = object
    kind*: string
    id*: string

  InlineQuery* = object
    id*: string
    fromUser*: User
    location*: Location
    query*: string
    offset*: string

  ChosenInlineResult* = object
    resultId*: string
    fromUser*: User
    location*: Location
    inlineMessageId*: string
    query*: string

  #------------------
  # Webhook
  #------------------
  WebhookInfo* = object
    url*: string
    hasCustomCertificate*: bool
    pendingUpdateCount*: int
    lastErrorDate*: int
    lastErrorMessage*: string
    maxConnections*: int
    allowedUpdates*: seq[string]

import logging, optional

type
  TelegramObject* = object of RootObj

  TeleBot* = ref object of TelegramObject
    token*: string
    lastUpdateId*: BiggestInt
    logger*: Logger

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

  Update* = object of TelegramObject
    updateId*: int
    message*: Optional[Message]
    editedMessage*: Optional[Message]
    channelPost*: Optional[Message]
    editedChannelPost*: Optional[Message]
    inlineQuery*: Optional[InlineQuery]
    chosenInlineResult*: Optional[ChosenInlineResult]
    callbackQuery*: Optional[CallbackQuery]
    shippingQuery*: Optional[ShippingQuery]
    preCheckoutQuery*: Optional[PreCheckoutQuery]

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
    
  #------------------
  # Inline Query
  #------------------
  InlineKeyboardButton* = object
    text*: string
    url*: string
    callbackData*: string
    switchInlineQuery*: string
    switchInlineQueryCurrentChat*: string
    callbackGame*: CallbackGame
    pay*: bool

  InlineKeyboardMarkup* = object of KeyBoardMarkup
    inlineKeyboard*: seq[seq[InlineKeyboardButton]]

  InlineQueryResult* = object of TelegramObject
    kind*: string
    id*: string
    inputMessageContent*: InputMessageContent
    replyMarkup*: InlineKeyboardMarkup

  InlineQueryResultWithThumb* = object of InlineQueryResult
    thumbUrl*: string
    thumbWidth*: int
    thumbHeight*: int

  InputMessageContent = object of RootObj

  InputTextMessageContent* = object of InputMessageContent
    messageText*: string
    parseMode*: string
    disableWebPagePreview*: bool

  InputLocationMessageContent* = object of InputMessageContent
    latitude*: float
    longitude*: float

  InputVenueMessageContent* = object of InputMessageContent
    llatitude*: float
    longitude*: float
    title*: string
    address*: string
    foursquareId*: string

  InputContactMessageContent* = object of InputMessageContent
    phoneNumber*: string
    firstName*: string
    lastName*: string

  InlineQueryResultArticle* = object of InlineQueryResultWithThumb
    title*: string
    url*: string
    hideUrl*: bool
    description*: string

  InlineQueryResultPhoto* = object of InlineQueryResult
    photoUrl*: string
    thumbUrl*: string
    photoWidth*: int
    photoHeight*: int
    title*: string
    description*: string
    caption*: string

  InlineQueryResultGif* = object of InlineQueryResult
    gifUrl*: string
    gifWidth*: int
    gifHeight*: int
    gifDuration*: int
    thumbUrl*: string
    title*: string
    caption*: string

  InlineQueryResultMpeg4Gif* = object of InlineQueryResult
    mpeg4Url*: string
    mpeg4Width*: int
    mpeg4Height*: int
    mpeg4Duration*: int
    thumbUrl*: string
    title*: string
    caption*: string

  InlineQueryResultVideo* = object of InlineQueryResult
    videoUrl*: string
    mimeType*: string
    thumbUrl*: string
    title*: string
    caption*: string
    videoWidth*: int
    videoHeight*: int
    videoDuration*: int
    description*: string

  InlineQueryResultAudio* = object of InlineQueryResult
    audioUrl*: string
    title*: string
    caption*: string
    performer*: string
    audioDuration*: int

  InlineQueryResultVoice* = object of InlineQueryResult
    voiceUrl*: string
    title*: string
    caption*: string
    voiceDuration*: int

  InlineQueryResultDocument* = object of InlineQueryResultWithThumb
    title*: string
    caption*: string
    documentUrl*: string
    mimeType*: string
    description*: string

  InlineQueryResultLocation* = object of InlineQueryResultWithThumb
    latitude*: float
    longitude*: float
    title*: string

  InlineQueryResultVenue* = object of InlineQueryResultWithThumb
    latitude*: float
    longitude*: float
    title*: string
    address*: string
    foursquareId*: string

  InlineQueryResultContact* = object of InlineQueryResultWithThumb
    phoneNumber*: string
    firstName*: string
    lastName*: string

  InlineQueryResultGame* = object of InlineQueryResult
    gameShortName*: string

  InlineQueryResultCachedPhoto* = object of InlineQueryResult
    photoFileId*: string
    title*: string
    description*: string
    caption*: string

  InlineQueryResultCachedGif* = object of InlineQueryResult
    gifFileId*: string
    title*: string
    caption*: string

  InlineQueryResultCachedMpeg4Gif* = object of InlineQueryResult
    mpeg4FileId*: string
    title*: string
    caption*: string

  InlineQueryResultCachedSticker* = object of InlineQueryResult
    stickerFileId*: string

  InlineQueryResultCachedVideo* = object of InlineQueryResult
    videoFileId*: string
    title*: string
    caption*: string
    description*: string

  InlineQueryResultCachedAudio* = object of InlineQueryResult
    audioFileId*: string
    caption*: string

  InlineQueryResultCachedVoice* = object of InlineQueryResult
    voiceFileId*: string
    title*: string
    caption*: string

  InlineQueryResultCacchedDocument* = object of InlineQueryResult
    title*: string
    caption*: string
    documentFileId*: string
    description*: string

  InlineQuery* = object of TelegramObject
    id*: string
    fromUser*: User
    location*: Optional[Location]
    query*: string
    offset*: string

  ChosenInlineResult* = object of TelegramObject
    resultId*: string
    fromUser*: User
    location*: Location
    inlineMessageId*: string
    query*: string

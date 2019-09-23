import asyncdispatch, options, tables, httpclient

type
  TelegramObject* = object of RootObj

  UpdateCallback* = proc(bot: Telebot, update: Update): Future[void]
  CommandCallback* = proc(bot: Telebot, command: Command): Future[void]
  CatchallCommandCallback* = proc(bot: Telebot, command: CatchallCommand): Future[void]
  InlineQueryCallback* = proc(bot: Telebot, inlineQuery: InlineQuery): Future[void]

  TeleBot* = ref object of TelegramObject
    token*: string
    lastUpdateId*: BiggestInt
    updateCallbacks*: seq[UpdateCallBack]
    commandCallbacks*: TableRef[string, seq[CommandCallback]]
    catchallCommandCallback*: CatchallCommandCallback
    inlineQueryCallbacks*: seq[InlineQueryCallback]
    proxy*: Proxy
    id*: int
    username*: string

  CatchallCommand* = object of TelegramObject
    command*: string
    message*: Message
    params*: string

  Command* = object of TelegramObject
    message*: Message
    params*: string

  User* = object of TelegramObject
    id*: int
    isBot*: bool
    firstName*: string
    lastName*: Option[string]
    username*: Option[string]
    languageCode*: Option[string]

  Chat* = object of TelegramObject
    id*: int64
    kind*: string
    title*: Option[string]
    username*: Option[string]
    firstName*: Option[string]
    lastName*: Option[string]
    photo*: Option[ChatPhoto]
    description*: Option[string]
    inviteLink*: Option[string]
    pinnedMessage*: Option[ref Message]
    permissions*: Option[ChatPermissions]
    stickerSetName*: Option[string]
    canSetStickerSet*: Option[bool]

  PhotoSize* = object of TelegramObject
    fileId*: string
    width*: int
    height*: int
    fileSize*: Option[int]

  Audio* = object of TelegramObject
    fileId*: string
    duration*: int
    performer*: Option[string]
    title*: Option[string]
    mimeType*: Option[string]
    fileSize*: Option[int]
    thumb*: Option[PhotoSize]

  Document* = object of TelegramObject
    fileId*: string
    thumb*: Option[PhotoSize]
    fileName*: Option[string]
    mimeType*: Option[string]
    fileSize*: Option[int]

  Sticker* = object of TelegramObject
    fileId*: string
    width*: int
    height*: int
    isAnimated*: bool
    thumb*: Option[PhotoSize]
    emoji*: Option[string]
    setName*: Option[string]
    maskPosition*: Option[MaskPosition]
    fileSize*: Option[int]

  StickerSet* = object of TelegramObject
    name*: string
    title*: string
    isAnimated*: bool
    containsMasks*: bool
    stickers*: seq[Sticker]

  MaskPosition* = object of TelegramObject
    point*: string
    xShift*: float
    yShift*: float
    scale*: float

  Video* = object of TelegramObject
    fileId*: string
    width*: int
    height*: int
    duration*: int
    thumb*: Option[PhotoSize]
    mimeType*: Option[string]
    fileSize*: Option[int]

  Voice* = object of TelegramObject
    fileId*: string
    duration*: int
    mimeType*: Option[string]
    fileSize*: Option[int]

  VideoNote* = object of TelegramObject
    fileId*: string
    length*: int
    duration*: int
    thumb*: Option[PhotoSize]
    fileSize*: Option[int]

  Contact* = object of TelegramObject
    phoneNumber*: string
    firstName*: string
    lastName*: Option[string]
    userId*: Option[string]
    vcard*: Option[string]

  Location* = object of TelegramObject
    longitude*: float
    latitude*: float

  Venue* = object of TelegramObject
    location*: Location
    title*: string
    address*: string
    foursquareId*: Option[string]
    foursquareType*: Option[string]

  PollOption* = object of TelegramObject
    text*: string
    voterCount*: int

  Poll* = object of TelegramObject
    id*: string
    question*: string
    options*: seq[PollOption]
    isClosed*: bool

  UserProfilePhotos* = object of TelegramObject
    totalCount*: int
    photos*: seq[seq[PhotoSize]]

  File* = object of TelegramObject
    fileId*: string
    fileSize*: Option[int]
    filePath*: Option[string]

  KeyboardButton* = object
    text*: string
    requestContact*: Option[bool]
    requestLocation*: Option[bool]

  InlineKeyboardButton* = object
    text*: string
    url*: Option[string]
    loginUrl*: Option[LoginUrl]
    callbackData*: Option[string]
    switchInlineQuery*: Option[string]
    switchInlineQueryCurrentChat*: Option[string]
    callbackGame*: Option[CallbackGame]
    pay*: Option[bool]

  KeyboardKind* = enum
    kReplyKeyboardMarkup
    kReplyKeyboardRemove
    kForceReply
    kInlineKeyboardMarkup

  KeyboardMarkup* = ref object of TelegramObject
    `type`*: KeyboardKind
    selective*: Option[bool]


  ReplyKeyboardMarkup* = ref object of KeyboardMarkup
    keyboard*: seq[seq[KeyboardButton]]
    resizeKeyboard*: Option[bool]
    oneTimeKeyboard*: Option[bool]

  ReplyKeyboardRemove* = ref object of KeyboardMarkup
  ForceReply* = ref object of KeyboardMarkup

  InlineKeyboardMarkup* = ref object of KeyboardMarkup
    inlineKeyboard*: seq[seq[InlineKeyboardButton]]

  LoginUrl* = ref object of TelegramObject
    url*: string
    forwardText*: Option[string]
    botUsername*: Option[string]
    requestWriteAccess*: Option[bool]

  CallbackGame* = object of TelegramObject

  CallbackQuery* = ref object of TelegramObject
    id*: string
    fromUser*: User
    message*: Option[Message]
    inlineMessageId*: Option[string]
    chatInstance*: Option[string]
    data*: Option[string]
    gameShortName*: Option[string]

  MessageEntity* = object of TelegramObject
    kind*: string
    offset*: int
    length*: int
    url*: Option[string]
    user*: Option[User]

  Message* = object of TelegramObject
    messageId*: int
    fromUser*: Option[User]
    date*: int
    chat*: Chat
    forwardFrom*: Option[User]
    forwardFromChat*: Option[Chat]
    forwardFromMessageId*: Option[int]
    forwardSignature*: Option[string]
    forwardSenderName*: Option[string]
    forwardDate*: Option[int]
    replyToMessage*: Option[ref Message]
    editDate*: Option[int]
    authorSignature*: Option[string]
    caption*: Option[string]
    text*: Option[string]
    entities*: Option[seq[MessageEntity]]
    captionEntities*: Option[seq[MessageEntity]]
    audio*: Option[Audio]
    document*: Option[Document]
    animation*: Option[Animation]
    game*: Option[Game]
    photo*: Option[seq[PhotoSize]]
    sticker*: Option[Sticker]
    video*: Option[Video]
    voice*: Option[Voice]
    videoNote*: Option[VideoNote]
    contact*: Option[Contact]
    location*: Option[Location]
    venue*: Option[Venue]
    poll*: Option[Poll]
    newChatMembers*: Option[seq[User]]
    newChatMember*: Option[User]
    leftChatMember*: Option[User]
    newChatTitle*: Option[string]
    newChatPhoto*: Option[seq[PhotoSize]]
    migrateToChatId*: Option[int64]
    migrateFromChatId*: Option[int64]
    pinnedMessage*: Option[ref Message]
    invoice*: Option[Invoice]
    successfulPayment*: Option[SuccessfulPayment]
    connectedWebsite*: Option[string]
    passportData*: Option[PassportData]
    replyMarkup*: Option[InlineKeyboardMarkup]

  ChatPhoto* = object of TelegramObject
    smallFileId*: string
    bigFileId*: string

  ChatMember* = object of TelegramObject
    user*: User
    status*: string
    untilDate*: Option[int]
    canBeEdited*: Option[bool]
    canPostMessages*: Option[bool]
    canEditMessages*: Option[bool]
    canDeleteMessages*: Option[bool]
    canRestrictMembers*: Option[bool]
    canPromoteMembers*: Option[bool]
    canChangeInfo*: Option[bool]
    canInviteUsers*: Option[bool]
    canPinMessages*: Option[bool]
    isMember*: Option[bool]
    canSendMessages*: Option[bool]
    canSendMediaMessages*: Option[bool]
    canSendPolls*: Option[bool]
    canSendOtherMessages*: Option[bool]
    canAddWebPagePreviews*: Option[bool]

  ChatPermissions* = object of TelegramObject
    canSendMessages*: Option[bool]
    canSendMediaMessages*: Option[bool]
    canSendPolls*: Option[bool]
    canSendOtherMessages*: Option[bool]
    canAddWebPagePreviews*: Option[bool]
    canChangeInfo*: Option[bool]
    canInviteUsers*: Option[bool]
    canPinMessages*: Option[bool]

  ResponseParameters* = object of TelegramObject
    migrateToChatId*: Option[int64]
    retryAfter*: Option[int]

  Update* = object of TelegramObject
    updateId*: int
    message*: Option[Message]
    editedMessage*: Option[Message]
    channelPost*: Option[Message]
    editedChannelPost*: Option[Message]
    inlineQuery*: Option[InlineQuery]
    chosenInlineResult*: Option[ChosenInlineResult]
    callbackQuery*: Option[CallbackQuery]
    shippingQuery*: Option[ShippingQuery]
    preCheckoutQuery*: Option[PreCheckoutQuery]
    poll*: Option[Poll]

  #------------------
  # Game
  #------------------
  Animation* = object of TelegramObject
    fileId*: string
    thumb*: Option[PhotoSize]
    fileName*: Option[string]
    mimeType*: Option[string]
    fileSize*: Option[int]

  Game* = object of TelegramObject
    title*: string
    description*: string
    photo*: seq[PhotoSize]
    text*: Option[string]
    textEntities*: Option[seq[MessageEntity]]
    animation*: Option[Animation]

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
    name*: Option[string]
    phoneNumber*: Option[string]
    email*: Option[string]
    shippingAddress*: Option[ShippingAddress]

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
    shippingOptionId*: Option[string]
    orderInfo*: Option[OrderInfo]
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
    shippingOptionId*: Option[string]
    orderInfo*: Option[OrderInfo]

  #------------------
  # Inline Query
  #------------------
  InputMessageContentKind* = enum
    TextMessage
    LocationMessage
    VenueMessage
    ContactMessage

  InputMessageContent* = ref object of TelegramObject
    case `type`*: InputMessageContentKind
    of TextMessage:
      messageText*: string
      parseMode*: Option[string]
      disableWebPagePreview*: Option[bool]
    of LocationMessage:
      latitude*: float
      longitude*: float
      livePeriod*: Option[int]
    of VenueMessage:
      venueLatitude*: float
      venueLongitude*: float
      venueTitle*: string
      venueAddress*: string
      foursquareId*: Option[string]
      foursquareType*: Option[string]
    of ContactMessage:
      phoneNumber*: string
      firstName*: string
      lastName*: Option[string]
      vcard*: Option[string]

  InlineQueryResult* = object of TelegramObject
    kind*: string
    id*: string
    inputMessageContent*: Option[InputMessageContent]
    replyMarkup*: Option[KeyboardMarkup]

  InlineQueryResultWithThumb* = object of InlineQueryResult
    thumbUrl*: Option[string]
    thumbWidth*: Option[int]
    thumbHeight*: Option[int]

  InlineQueryResultArticle* = object of InlineQueryResultWithThumb
    title*: string
    url*: Option[string]
    hideUrl*: Option[bool]
    description*: Option[string]

  InlineQueryResultPhoto* = object of InlineQueryResult
    photoUrl*: string
    thumbUrl*: string
    photoWidth*: Option[int]
    photoHeight*: Option[int]
    title*: Option[string]
    description*: Option[string]
    caption*: Option[string]

  InlineQueryResultGif* = object of InlineQueryResult
    gifUrl*: string
    gifWidth*: Option[int]
    gifHeight*: Option[int]
    gifDuration*: Option[int]
    thumbUrl*: string
    title*: Option[string]
    caption*: Option[string]

  InlineQueryResultMpeg4Gif* = object of InlineQueryResult
    mpeg4Url*: string
    mpeg4Width*: Option[int]
    mpeg4Height*: Option[int]
    mpeg4Duration*: Option[int]
    thumbUrl*: string
    title*: Option[string]
    caption*: Option[string]

  InlineQueryResultVideo* = object of InlineQueryResult
    videoUrl*: string
    mimeType*: string
    thumbUrl*: string
    title*: string
    caption*: Option[string]
    videoWidth*: Option[int]
    videoHeight*: Option[int]
    videoDuration*: Option[int]
    description*: Option[string]

  InlineQueryResultAudio* = object of InlineQueryResult
    audioUrl*: string
    title*: string
    caption*: Option[string]
    performer*: Option[string]
    audioDuration*: Option[int]

  InlineQueryResultVoice* = object of InlineQueryResult
    voiceUrl*: string
    title*: string
    caption*: Option[string]
    voiceDuration*: Option[int]

  InlineQueryResultDocument* = object of InlineQueryResultWithThumb
    title*: string
    caption*: Option[string]
    documentUrl*: string
    mimeType*: string
    description*: Option[string]

  InlineQueryResultLocation* = object of InlineQueryResultWithThumb
    latitude*: float
    longitude*: float
    title*: string
    livePeriod*: Option[int]

  InlineQueryResultVenue* = object of InlineQueryResultWithThumb
    latitude*: float
    longitude*: float
    title*: string
    address*: string
    foursquareId*: Option[string]
    foursquareType*: Option[string]

  InlineQueryResultContact* = object of InlineQueryResultWithThumb
    phoneNumber*: string
    firstName*: string
    lastName*: Option[string]
    vcard*: Option[string]

  InlineQueryResultGame* = object of InlineQueryResult
    gameShortName*: string

  InlineQueryResultCachedPhoto* = object of InlineQueryResult
    photoFileId*: string
    title*: Option[string]
    description*: Option[string]
    caption*: Option[string]

  InlineQueryResultCachedGif* = object of InlineQueryResult
    gifFileId*: string
    title*: Option[string]
    caption*: Option[string]

  InlineQueryResultCachedMpeg4Gif* = object of InlineQueryResult
    mpeg4FileId*: string
    title*: Option[string]
    caption*: Option[string]

  InlineQueryResultCachedSticker* = object of InlineQueryResult
    stickerFileId*: string

  InlineQueryResultCachedVideo* = object of InlineQueryResult
    videoFileId*: string
    title*: string
    caption*: Option[string]
    description*: Option[string]

  InlineQueryResultCachedAudio* = object of InlineQueryResult
    audioFileId*: string
    caption*: Option[string]

  InlineQueryResultCachedVoice* = object of InlineQueryResult
    voiceFileId*: string
    title*: string
    caption*: Option[string]

  InlineQueryResultCacchedDocument* = object of InlineQueryResult
    title*: string
    caption*: Option[string]
    documentFileId*: string
    description*: Option[string]

  InlineQuery* = object of TelegramObject
    id*: string
    fromUser*: User
    location*: Option[Location]
    query*: string
    offset*: string

  ChosenInlineResult* = object of TelegramObject
    resultId*: string
    fromUser*: User
    location*: Option[Location]
    inlineMessageId*: Option[string]
    query*: string

  #------------------
  # Input Media
  #------------------
  InputMedia* = ref object of TelegramObject
    kind*: string
    media*: string
    thumb*: Option[string]
    caption*: Option[string]
    parseMode*: Option[string]

  InputMediaPhoto* = ref object of InputMedia

  InputMediaVideo* = ref object of InputMedia
    width*: Option[int]
    height*: Option[int]
    duration*: Option[int]
    supportsStreaming*: Option[bool]

  InputMediaAnimation* = ref object of InputMedia
    width*: Option[int]
    height*: Option[int]
    duration*: Option[int]

  InputMediaAudio* = ref object of InputMedia
    duration*: Option[int]
    performer*: Option[string]
    title*: Option[string]

  InputMediaDocument* = ref object of InputMedia

  #------------------
  # Passport
  #------------------
  PassportFile* = object of TelegramObject
    fileId*: string
    fileSize*: int
    fileDate*: int

  EncryptedPassportElement* = object of TelegramObject
    kind*: string
    data*: Option[string]
    phoneNumber*: Option[string]
    email*: Option[string]
    files*: Option[seq[PassportFile]]
    frontSide*: Option[PassportFile]
    reverseSide*: Option[PassportFile]
    selfie*: Option[PassportFile]
    translation*: Option[seq[PassportFile]]
    hash*: string

  EncryptedCredentials* = object of TelegramObject
    data*: string
    hash*: string
    secret*: string

  PassportData* = object of TelegramObject
    data*: seq[EncryptedPassportElement]
    credentials*: EncryptedCredentials

  PassportElementError = ref object of TelegramObject
    source*: string
    kind*: string
    message*: string

  PassportElementErrorDataField* = ref object of PassportElementError
    fieldName*: string
    dataHash*: string

  PassportElementErrorFrontSide* = ref object of PassportElementError
    fileHash*: string

  PassportElementErrorReverseSide* = ref object of PassportElementError
    fileHash*: string

  PassportElementErrorSelfie* = ref object of PassportElementError
    fileHash*: string

  PassportElementErrorFile* = ref object of PassportElementError
    fileHash*: string

  PassportElementErrorFiles* = ref object of PassportElementError
    fileHashes*: seq[string]

  PassportElementErrorTranslationFile* = ref object of PassportElementError
    fileHash*: string

  PassportElementErrorTranslationFiles* = ref object of PassportElementError
    fileHashes*: seq[string]

  PassportElementErrorUnspecified* = ref object of PassportElementError
    elementHash*: string

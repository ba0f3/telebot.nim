import options, tables, asyncevents

type
  InputFile* = string

  TelegramObject* = object of RootObj

  TeleBot* = ref object of TelegramObject
    token*: string
    lastUpdateId*: BiggestInt
    updateEmitter*: AsyncEventEmitter[Update, string]
    commandEmitter*: AsyncEventEmitter[Command, string]

  UpdateCallback* = EventProc[Update]
  CommandCallback* = EventProc[Command]

  Command* = object of TelegramObject
    message*: Message
    params*: string

  User* = object of TelegramObject
    id*: int
    firstName*: string
    lastName*: Option[string]
    username*: Option[string]
    languageCode*: Option[string]

  Chat* = object of TelegramObject
    id*: int
    kind*: string
    title*: Option[string]
    username*: Option[string]
    firstName*: Option[string]
    lastName*: Option[string]
    allMembersAreAdministrators*: Option[bool]
    photo*: Option[ChatPhoto]
    description*: Option[string]
    inviteLink*: Option[string]

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
    thumb*: Option[PhotoSize]
    emoji*: Option[string]
    fileSize*: Option[int]

  StickerSet* = object of TelegramObject
    name*: string
    title*: string
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

  Location* = object of TelegramObject
    longitude*: float
    latitude*: float

  Venue* = object of TelegramObject
    location*: Location
    title*: string
    address*: string
    foursquareId*: Option[string]

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
    selective*: Option[bool]
    case kind*: KeyboardKind
    of kReplyKeyboardMarkup:
      keyboard*: seq[seq[KeyboardButton]]
      resizeKeyboard*: Option[bool]
      oneTimeKeyboard*: Option[bool]
    of kInlineKeyboardMarkup:
      inlineKeyboard*: seq[seq[InlineKeyboardButton]]
    else:
      discard

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
    forwardDate*: Option[int]
    replyToMessage*: Option[ref Message]
    editDate*: Option[int]
    caption*: Option[string]
    text*: Option[string]
    entities*: Option[seq[MessageEntity]]
    audio*: Option[Audio]
    document*: Option[Document]
    game*: Option[Game]
    photo*: Option[seq[PhotoSize]]
    sticker*: Option[Sticker]
    video*: Option[Video]
    voice*: Option[Voice]
    videoNote*: Option[VideoNote]
    contact*: Option[Contact]
    location*: Option[Location]
    venue*: Option[Venue]
    newChatMembers*: Option[seq[User]]
    newChatMember*: Option[User]
    leftChatMember*: Option[User]
    newChatTitle*: Option[string]
    newChatPhoto*: Option[seq[PhotoSize]]
    migrateToChatId*: Option[int]
    migrateFromChatId*: Option[int]
    pinnedMessage*: Option[ref Message]
    invoice*: Option[Invoice]
    successfulPayment*: Option[SuccessfulPayment]

  ChatPhoto* = object of TelegramObject
    smallFileId*: string
    bigFileId*: string

  ChatMember* = object of TelegramObject
    user*: User
    status*: string
    untilDate*: int
    canBeEdited*: Option[bool]
    canChangeInfo*: Option[bool]
    canPostMessages*: Option[bool]
    canEditMessages*: Option[bool]
    canDeleteMessages*: Option[bool]
    canInviteUsers*: Option[bool]
    canRestrictMembers*: Option[bool]
    canPinMessages*: Option[bool]
    canPromoteMebers*: Option[bool]
    canSendMessages*: Option[bool]
    canSendMediaMessages*: Option[bool]
    canSendOtherMessages*: Option[bool]
    canAddWebPagePreviews*: Option[bool]

  ResponseParameters* = object of TelegramObject
    migrateToChatId*: Option[int]
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
  InlineQueryResult* = object of TelegramObject
    kind*: string
    id*: string
    inputMessageContent*: Option[InputMessageContent]
    replyMarkup*: Option[KeyboardMarkup]

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
    photoWidth*: Option[int]
    photoHeight*: Option[int]
    title*: Option[string]
    description*: Option[string]
    caption*: Option[string]

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
    location*: Option[Location]
    query*: string
    offset*: string

  ChosenInlineResult* = object of TelegramObject
    resultId*: string
    fromUser*: User
    location*: Location
    inlineMessageId*: string
    query*: string

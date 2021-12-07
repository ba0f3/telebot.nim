import options, tables, httpclient
from asyncdispatch import Future


converter optionToBool*[T](o: Option[T]): bool = o.isSome()

type
  TelegramObject* = object of RootObj

  ChatAction* = enum
    TYPING
    UPLOAD_PHOTO
    RECORD_VIDEO
    UPLOAD_VIDEO
    RECORD_VOICE
    UPLOAD_VOICE
    UPLOAD_DOCUMENT
    CHOOSE_STICKER
    FIND_LOCATION
    RECORD_VIDEO_NOTE
    UPLOAD_VIDEO_NOTE

  ChatId* = int64|string

  UpdateCallback* = proc(bot: Telebot, update: Update): Future[bool] {.gcsafe.}
  CommandCallback* = proc(bot: Telebot, command: Command): Future[bool] {.gcsafe.}
  CatchallCommandCallback* = proc(bot: Telebot, command: Command): Future[bool] {.gcsafe.}
  InlineQueryCallback* = proc(bot: Telebot, inlineQuery: InlineQuery): Future[bool] {.gcsafe.}

  TeleBot* = ref object of TelegramObject
    token*: string
    lastUpdateId*: BiggestInt
    updateCallbacks*: seq[UpdateCallBack]
    commandCallbacks*: TableRef[string, seq[CommandCallback]]
    catchallCommandCallback*: CatchallCommandCallback
    inlineQueryCallbacks*: seq[InlineQueryCallback]
    serverUrl*: string
    proxy*: Proxy
    id*: int
    username*: string

  Command* = object of TelegramObject
    command*: string
    message*: Message
    params*: string

  User* = object of TelegramObject
    id*: int
    isBot*: bool
    firstName*: string
    lastName*: Option[string]
    username*: Option[string]
    languageCode*: Option[string]
    canJoinGroups: Option[bool]
    canReadAllGroupMessages: Option[bool]
    supportsInlineQueries: Option[bool]

  Chat* = object of TelegramObject
    id*: int64
    kind*: string
    title*: Option[string]
    username*: Option[string]
    firstName*: Option[string]
    lastName*: Option[string]
    photo*: Option[ChatPhoto]
    bio*: Option[string]
    hasPrivateForwards*: Option[bool]
    description*: Option[string]
    inviteLink*: Option[string]
    pinnedMessage*: Option[ref Message]
    permissions*: Option[ChatPermissions]
    slowModeDelay*: Option[int]
    messageAutoDeleteTime*: Option[int]
    hasProtectedContent*: Option[bool]
    stickerSetName*: Option[string]
    canSetStickerSet*: Option[bool]
    linkedChatId*: Option[int]
    location*: Option[ChatLocation]

  PhotoSize* = object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    width*: int
    height*: int
    fileSize*: Option[int]

  Audio* = object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    duration*: int
    performer*: Option[string]
    title*: Option[string]
    fileName*: Option[string]
    mimeType*: Option[string]
    fileSize*: Option[int]
    thumb*: Option[PhotoSize]

  Document* = object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    thumb*: Option[PhotoSize]
    fileName*: Option[string]
    mimeType*: Option[string]
    fileSize*: Option[int]

  Sticker* = object of TelegramObject
    fileId*: string
    fileUniqueId*: string
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
    thumb*: Option[PhotoSize]

  MaskPosition* = object of TelegramObject
    point*: string
    xShift*: float
    yShift*: float
    scale*: float

  Video* = object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    width*: int
    height*: int
    duration*: int
    thumb*: Option[PhotoSize]
    fileName*: Option[string]
    mimeType*: Option[string]
    fileSize*: Option[int]

  Voice* = object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    duration*: int
    mimeType*: Option[string]
    fileSize*: Option[int]

  VideoNote* = object of TelegramObject
    fileId*: string
    fileUniqueId*: string
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
    horizontalAccuracy*: Option[float]
    livePeriod*: Option[int]
    heading*: Option[int]
    proximityAlertRadius*: Option[int]

  Venue* = object of TelegramObject
    location*: Location
    title*: string
    address*: string
    foursquareId*: Option[string]
    foursquareType*: Option[string]
    googlePlaceId*: Option[string]
    googlePlaceType*: Option[string]

  PollOption* = object of TelegramObject
    text*: string
    voterCount*: int

  PollAnswer* = object of TelegramObject
    pollId*: string
    user*: User
    optionIds*: seq[int]

  Poll* = object of TelegramObject
    id*: string
    question*: string
    options*: seq[PollOption]
    totalVoterCount*: int
    isClosed*: bool
    isAnonymous*: bool
    kind*: string
    allowsMultipleAnswers*: bool
    correctOptionId*: int
    explanation*: Option[string]
    explanationEntities*: Option[seq[MessageEntity]]
    openPeriod*: Option[int]
    closeDate*: Option[int]

  ProximityAlertTriggered* = object of TelegramObject
    traveler*: User
    watcher*: User
    distance*: int

  MessageAutoDeleteTimerChanged* = object of TelegramObject
    messageAutoDeleteTime*: int

  VoiceChatScheduled* = object of TelegramObject
    startDate*: int

  VoiceChatStarted* = object of TelegramObject

  VoiceChatEnded* = object of TelegramObject
    duration*: int

  VoiceChatParticipantsInvited* = object of TelegramObject
    users*: seq[User]

  UserProfilePhotos* = object of TelegramObject
    totalCount*: int
    photos*: seq[seq[PhotoSize]]

  Dice* = object of TelegramObject
    emoji*: string
    value*: int

  File* = object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    fileSize*: Option[int]
    filePath*: Option[string]

  KeyboardButton* = object
    text*: string
    requestContact*: Option[bool]
    requestLocation*: Option[bool]
    requestPoll*: Option[KeyboardButtonPollType]

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
    inputFieldPlaceholder*: Option[string]

  KeyboardButtonPollType* = ref object of TelegramObject
    kind*: string

  ReplyKeyboardRemove* = ref object of KeyboardMarkup
  ForceReply* = ref object of KeyboardMarkup
    inputFieldPlaceholder*: Option[string]


  InlineKeyboardMarkup* = ref object of KeyboardMarkup
    inlineKeyboard*: seq[seq[InlineKeyboardButton]]

  LoginUrl* = ref object of TelegramObject
    url*: string
    forwardText*: Option[string]
    botUsername*: Option[string]
    requestWriteAccess*: Option[bool]

  CallbackGame* = object of TelegramObject

  GameHighScore* = object of TelegramObject
    position*: int
    user*: User
    score*: int

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
    language*: Option[string]

  Message* = object of TelegramObject
    messageId*: int
    fromUser*: Option[User]
    senderChat*: Option[Chat]
    date*: int
    chat*: Chat
    forwardFrom*: Option[User]
    forwardFromChat*: Option[Chat]
    forwardFromMessageId*: Option[int]
    forwardSignature*: Option[string]
    forwardSenderName*: Option[string]
    forwardDate*: Option[int]
    isAutomaticForward*: Option[bool]
    replyToMessage*: Option[ref Message]
    viaBot*: Option[User]
    editDate*: Option[int]
    hasProtectedContent*: Option[bool]
    mediaGroupId*: Option[string]
    authorSignature*: Option[string]
    text*: Option[string]
    entities*: Option[seq[MessageEntity]]
    animation*: Option[Animation]
    audio*: Option[Audio]
    document*: Option[Document]
    photo*: Option[seq[PhotoSize]]
    sticker*: Option[Sticker]
    video*: Option[Video]
    videoNote*: Option[VideoNote]
    voice*: Option[Voice]
    caption*: Option[string]
    captionEntities*: Option[seq[MessageEntity]]
    contact*: Option[Contact]
    dice*: Option[Dice]
    game*: Option[Game]
    poll*: Option[Poll]
    venue*: Option[Venue]
    location*: Option[Location]
    newChatMembers*: Option[seq[User]]
    leftChatMember*: Option[User]
    newChatTitle*: Option[string]
    newChatPhoto*: Option[seq[PhotoSize]]
    deleteChatPhoto*: Option[bool]
    groupChatCreated*: Option[bool]
    superGroupChatCreated*: Option[bool]
    chanelChatCreated*: Option[bool]
    messageAutoDeleteTimerChanged*: Option[MessageAutoDeleteTimerChanged]
    migrateToChatId*: Option[int64]
    migrateFromChatId*: Option[int64]
    pinnedMessage*: Option[ref Message]
    invoice*: Option[Invoice]
    successfulPayment*: Option[SuccessfulPayment]
    connectedWebsite*: Option[string]
    passportData*: Option[PassportData]
    proximityAlertTriggered*: Option[ProximityAlertTriggered]
    voiceChatScheduled*: Option[VoiceChatScheduled]
    voiceChatStarted*: Option[VoiceChatStarted]
    voiceChatEnded*: Option[VoiceChatEnded]
    voiceChatParticipantsInvited*: Option[VoiceChatParticipantsInvited]
    replyMarkup*: Option[InlineKeyboardMarkup]

  MessageId* = object of TelegramObject
    messageId*: int

  ChatPhoto* = object of TelegramObject
    smallFileId*: string
    smallFileUniqueId*: string
    bigFileId*: string
    bigFileUniqueId*: string

  ChatInviteLink* = object of TelegramObject
    inviteLink*: string
    creator*: User
    createsJoinRequest*: bool
    isPrimary*: bool
    isRevoked*: bool
    name*: Option[string]
    expireDate*: Option[int]
    memberLimit*: Option[int]
    pendingJoinRequestCount*: Option[int]

  ChatMember* = object of TelegramObject
    user*: User
    status*: string
    #TODO these properties below will be removed infavor of 6 types of chat members
    customTitle*: Option[string]
    isAnonymous*: Option[bool]
    untilDate*: Option[int]
    canBeEdited*: Option[bool]
    canManageChat*: Option[bool]
    canPostMessages*: Option[bool]
    canEditMessages*: Option[bool]
    canDeleteMessages*: Option[bool]
    canManageVoiceChats*: Option[bool]
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

  #[ I dont know how these types work yet
  ChatMember* = object of TelegramObject
    user*: User
    status*: string

  ChatMemberOwner* = object of ChatMember
    customTitle*: Option[string]
    isAnonymous*: Option[bool]

  ChatMemberAdministrator* = object of ChatMemberOwner
    canBeEdited*: Option[bool]
    canManageChat*: Option[bool]
    canDeleteMessages*: Option[bool]
    canManageVoiceChats*: Option[bool]
    canRestrictMembers*: Option[bool]
    canPromoteMembers*: Option[bool]
    canChangeInfo*: Option[bool]
    canInviteUsers*: Option[bool]
    canPostMessages*: Option[bool]
    canEditMessages*: Option[bool]
    canPinMessages*: Option[bool]

  ChatMemberMember* = object of ChatMember

  ChatMemberRestricted* = object of ChatMember
    isMember*: Option[bool]
    canChangeInfo*: Option[bool]
    canInviteUsers*: Option[bool]
    canPinMessages*: Option[bool]
    canSendMessages*: Option[bool]
    canSendMediaMessages*: Option[bool]
    canSendPolls*: Option[bool]
    canSendOtherMessages*: Option[bool]
    canAddWebPagePreviews*: Option[bool]
    untilDate*: Option[int]

  ChatMemberLeft* = object of ChatMember

  ChatMemberBanned* = object of ChatMember
    untilDate*: Option[int]
  ]#

  ChatMemberUpdated* = object of TelegramObject
    chat*: Chat
    fromUser*: User
    date*: int
    oldChatMember*: ChatMember
    newChatMember*: ChatMember
    inviteLink*: Option[ChatInviteLink]

  ChatJoinRequest* = object of TelegramObject
    chat*: Chat
    fomrUser*: User
    date*: int
    bio*: Option[string]
    inviteLink*: Option[ChatInviteLink]

  ChatPermissions* = object of TelegramObject
    canSendMessages*: Option[bool]
    canSendMediaMessages*: Option[bool]
    canSendPolls*: Option[bool]
    canSendOtherMessages*: Option[bool]
    canAddWebPagePreviews*: Option[bool]
    canChangeInfo*: Option[bool]
    canInviteUsers*: Option[bool]
    canPinMessages*: Option[bool]

  ChatLocation* = object of TelegramObject
    location*: Location
    address*: string

  BotCommand* = object of TelegramObject
    command*: string
    description*: string

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
    pollAnswer*: Option[PollAnswer]
    myChatMember*: Option[ChatMemberUpdated]
    chatMember*: Option[ChatMemberUpdated]
    chatJoinRequest*: Option[ChatJoinRequest]

  #------------------
  # Game
  #------------------
  Animation* = object of TelegramObject
    fileId*: string
    fileUniqueId*: string
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
    InvoiceMessage

  InputMessageContent* = ref object of TelegramObject
    case `type`*: InputMessageContentKind
    of TextMessage:
      messageText*: string
      parseMode*: Option[string]
      disableWebPagePreview*: Option[bool]
      captionEntities*: Option[seq[MessageEntity]]
    of LocationMessage:
      latitude*: float
      longitude*: float
      livePeriod*: Option[int]
      heading*: Option[int]
    of VenueMessage:
      venueLatitude*: float
      venueLongitude*: float
      venueTitle*: string
      venueAddress*: string
      foursquareId*: Option[string]
      foursquareType*: Option[string]
      googlePlaceId*: Option[string]
      googlePlaceType*: Option[string]
    of ContactMessage:
      phoneNumber*: string
      firstName*: string
      lastName*: Option[string]
      vcard*: Option[string]
    of InvoiceMessage:
      title*: string
      description*: string
      payload*: string
      providerToken*: string
      currrency*: string
      prices*: seq[LabeledPrice]
      maxTipAmount*: Option[int]
      suggestedTipAmounts*: Option[seq[int]]
      providerData*: Option[string]
      photoUrl*: Option[string]
      photoSize*: Option[int]
      photoWidth*: Option[int]
      photoHeight*: Option[int]
      needName*: Option[bool]
      needPhoneNumber*: Option[bool]
      needEmail*: Option[bool]
      needShippingAddress*: Option[bool]
      sendPhoneNumberToProvider*: Option[bool]
      sendEmailToProvider*: Option[bool]
      isFlexible*: Option[bool]


  InlineQueryResult* = object of TelegramObject
    kind*: string
    id*: string
    captionEntities*: Option[seq[MessageEntity]]
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
    horizontalAccuracy*: Option[float]
    livePeriod*: Option[int]
    heading*: Option[int]
    proximityAlertRadius*: Option[int]

  InlineQueryResultVenue* = object of InlineQueryResultWithThumb
    latitude*: float
    longitude*: float
    title*: string
    address*: string
    foursquareId*: Option[string]
    foursquareType*: Option[string]
    googlePlaceId*: Option[string]
    googlePlaceType*: Option[string]

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

  InlineQueryResultCachedDocument* = object of InlineQueryResult
    title*: string
    caption*: Option[string]
    documentFileId*: string
    description*: Option[string]

  InlineQuery* = object of TelegramObject
    id*: string
    fromUser*: User
    query*: string
    offset*: string
    chatType: Option[string]
    location*: Option[Location]


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
    captionEntities*: Option[seq[MessageEntity]]

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
    disableContentTypeDetection*: Option[bool]


  InputMediaSet* = InputMediaPhoto|InputMediaVideo|InputMediaAnimation|InputMediaAudio|InputMediaDocument

  #------------------
  # Passport
  #------------------
  PassportFile* = object of TelegramObject
    fileId*: string
    fileUniqueId*: string
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

  #------------------
  # BotCommandScope
  #------------------

  BotCommandScope* = enum
    COMMAND_SCOPE_DEFAULT = "default"
    COMMAND_SCOPE_ALL_PRIVATE_CHATS = "all_private_chats"
    COMMAND_SCOPE_ALL_GROUP_CHATS = "all_group_chats"
    COMMAND_SCOPE_ALL_CHAT_ADMINISTARTORS = "all_chat_administrators"
    COMMAND_SCOPE_CHAT = "chat"
    COMMAND_SCOPE_CHAT_ADMINISTARTORS = "chat_administrators"
    COMMAND_SCOPE_CHAT_MEMBER = "chat_member"

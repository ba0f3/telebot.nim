import options, tables, httpclient
from asyncdispatch import Future


converter optionToBool*[T](o: Option[T]): bool = o.isSome()

template telebotInternalUse* {.pragma.}

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

  InputFileOrString* = string

  UpdateCallback* = proc(bot: Telebot, update: Update): Future[bool] {.gcsafe.}
  CommandCallback* = proc(bot: Telebot, command: Command): Future[bool] {.gcsafe.}
  CatchallCommandCallback* = proc(bot: Telebot, command: Command): Future[bool] {.gcsafe.}
  InlineQueryCallback* = proc(bot: Telebot, inlineQuery: InlineQuery): Future[bool] {.gcsafe.}

  ErrorHandler* = proc(bot: Telebot, error: CatchableError, message: string): Future[bool] {.gcsafe.}

  TeleBot* = ref object of TelegramObject
    token*: string
    lastUpdateId*: BiggestInt
    updateCallbacks*: seq[UpdateCallBack]
    commandCallbacks*: TableRef[string, seq[CommandCallback]]
    catchallCommandCallback*: CatchallCommandCallback
    inlineQueryCallbacks*: seq[InlineQueryCallback]
    errorHandler*: ErrorHandler
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
    isPremium*: Option[bool]
    addedToAttachmentMenu*: Option[bool]
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
    isForum*:Option[bool]
    photo*: Option[ChatPhoto]
    activeUsernames*: Option[seq[string]]
    emojiStatusCustomEmojiId*: Option[string]
    emojiStatusExpirationDate*: Option[int]
    bio*: Option[string]
    hasPrivateForwards*: Option[bool]
    joinToSendMessages*: Option[bool]
    joinByRequest*: Option[bool]
    description*: Option[string]
    inviteLink*: Option[string]
    pinnedMessage*: Option[ref Message]
    permissions*: Option[ChatPermissions]
    slowModeDelay*: Option[int]
    messageAutoDeleteTime*: Option[int]
    hasAggressiveAntiSpamEnabled*: Option[bool]
    hasHiddenMembers*: Option[bool]
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
    thumbnail*: Option[PhotoSize]

  Document* = object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    thumbnail*: Option[PhotoSize]
    fileName*: Option[string]
    mimeType*: Option[string]
    fileSize*: Option[int]

  Story* = object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    width*: int
    height*: int
    duration*: int
    thumbnail*: Option[PhotoSize]
    fileName*: Option[string]
    mimeType*: Option[string]
    fileSize*: Option[int]

  Sticker* = object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    width*: int
    height*: int
    isAnimated*: bool
    isVideo*: bool
    thumbnail*: Option[PhotoSize]
    emoji*: Option[string]
    setName*: Option[string]
    premiumAnimation*: Option[File]
    maskPosition*: Option[MaskPosition]
    customEmojiId*: Option[string]
    needsRepainting*: Option[bool]
    fileSize*: Option[int]

  StickerSet* = object of TelegramObject
    name*: string
    title*: string
    stickerType*: string
    isAnimated*: bool
    isVideo*: bool
    stickers*: seq[Sticker]
    thumbnail*: Option[PhotoSize]

  MaskPosition* = object of TelegramObject
    point*: string
    xShift*: float
    yShift*: float
    scale*: float

  InputSticker* = object of TelegramObject
    sticker*: InputFileOrString
    emojiList*: seq[string]
    maskPosition*: MaskPosition
    keywords*: seq[string]

  Video* = object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    width*: int
    height*: int
    duration*: int
    thumbnail*: Option[PhotoSize]
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
    thumbnail*: Option[PhotoSize]
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
    voterChat*: Option[Chat]
    user*: Option[User]
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
    correctOptionId*: Option[int]
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

  ForumTopicCreated* = object of TelegramObject
    name*: string
    iconColor*: int
    iconCustomEmojiId*: Option[string]

  ForumTopicClosed* = object of TelegramObject

  ForumTopicEdited* = object of TelegramObject
    name*: Option[string]
    iconCustomEmojiId*: Option[string]

  ForumTopicReopened* = object of TelegramObject

  GeneralForumTopicHidden* = object of TelegramObject

  GeneralForumTopicUnhidden* = object of TelegramObject

  UserShared* = object of TelegramObject
    requestId*: int
    userId*: int64

  ChatShared* = object of TelegramObject
    requestId*: int
    chatId*: int64

  WriteAccessAllowed* = object of TelegramObject
    fromRequest*: Option[bool]
    webAppName*: Option[string]
    fromAttachmentMenu*: Option[bool]

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

  FileObj* = object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    fileSize*: Option[int64]
    filePath*: Option[string]

  KeyboardButton* = object of TelegramObject
    text*: string
    requestUser*: Option[KeyboardButtonRequestUser]
    requestChat*: Option[KeyboardButtonRequestChat]
    requestContact*: Option[bool]
    requestLocation*: Option[bool]
    requestPoll*: Option[KeyboardButtonPollType]
    webApp*: Option[WebAppInfo]

  InlineKeyboardButton* = object of TelegramObject
    text*: string
    url*: Option[string]
    loginUrl*: Option[LoginUrl]
    callbackData*: Option[string]
    webApp*: Option[WebAppInfo]
    switchInlineQuery*: Option[string]
    switchInlineQueryCurrentChat*: Option[string]
    switchInlineQueryChosenChat*: Option[SwitchInlineQueryChosenChat]
    callbackGame*: Option[CallbackGame]
    pay*: Option[bool]

  KeyboardKind* = enum
    kReplyKeyboardMarkup
    kReplyKeyboardRemove
    kForceReply
    kInlineKeyboardMarkup

  KeyboardMarkup* = ref object of TelegramObject
    kind* {.telebotInternalUse.}: KeyboardKind

  ReplyKeyboardMarkup* = ref object of KeyboardMarkup
    keyboard*: seq[seq[KeyboardButton]]
    isPersistent*: Option[bool]
    resizeKeyboard*: Option[bool]
    oneTimeKeyboard*: Option[bool]
    inputFieldPlaceholder*: Option[string]
    selective*: Option[bool]

  KeyboardButtonRequestUser* = ref object of TelegramObject
    requestId*: int
    userIsBot*: Option[bool]
    userIsPremium*: Option[bool]

  KeyboardButtonRequestChat* = ref object of TelegramObject
    requestId*: int
    chatIsChannel*: bool
    chatIsForum*: bool
    chatHasUsername*: bool
    chatIsCreated*: bool
    userAdministratorRights*: ChatAdministratorRights
    botAdministratorRights*: ChatAdministratorRights
    botIsMember*: bool

  KeyboardButtonPollType* = ref object of TelegramObject
    kind*: string

  ReplyKeyboardRemove* = ref object of KeyboardMarkup
    selective*: Option[bool]

  ForceReply* = ref object of KeyboardMarkup
    forceReply*: Option[bool]
    inputFieldPlaceholder*: Option[string]
    selective*: Option[bool]

  InlineKeyboardMarkup* = ref object of KeyboardMarkup
    inlineKeyboard*: seq[seq[InlineKeyboardButton]]

  LoginUrl* = ref object of TelegramObject
    url*: string
    forwardText*: Option[string]
    botUsername*: Option[string]
    requestWriteAccess*: Option[bool]

  CallbackGame* = ref object of TelegramObject

  GameHighScore* = ref object of TelegramObject
    position*: int
    user*: User
    score*: int

  SwitchInlineQueryChosenChat* = ref object of TelegramObject
    query*: Option[string]
    allowUserChats*: Option[bool]
    allowBotChats*: Option[bool]
    allowGroupChats*: Option[bool]
    allowChannelChats*: Option[bool]


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
    customEmojiId*: Option[string]

  Message* = object of TelegramObject
    messageId*: int
    messageThreadId*: Option[int]
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
    isTopicMessage*: Option[bool]
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
    story*: Option[Story]
    video*: Option[Video]
    videoNote*: Option[VideoNote]
    voice*: Option[Voice]
    caption*: Option[string]
    captionEntities*: Option[seq[MessageEntity]]
    hasMediaSpoiler*: Option[bool]
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
    userShared*: Option[UserShared]
    chatShared*: Option[ChatShared]
    connectedWebsite*: Option[string]
    writeAccessAllowed*: Option[WriteAccessAllowed]
    passportData*: Option[PassportData]
    proximityAlertTriggered*: Option[ProximityAlertTriggered]
    forumTopicCreated*: Option[ForumTopicCreated]
    forumTopicEdited*: Option[ForumTopicEdited]
    forumTopicClosed*: Option[ForumTopicClosed]
    forumTopicReopened*: Option[ForumTopicReopened]
    generalForumTopicHidden*: Option[GeneralForumTopicHidden]
    generalForumTopicUnhidden*: Option[GeneralForumTopicUnhidden]
    videoChatScheduled*: Option[VoiceChatScheduled]
    videoChatStarted*: Option[VoiceChatStarted]
    videoChatEnded*: Option[VoiceChatEnded]
    videoChatParticipantsInvited*: Option[VoiceChatParticipantsInvited]
    webAppData*: Option[WebAppData]
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

  ChatAdministratorRights* = object of TelegramObject
    isAnonymous*: bool
    canManageChat*: bool
    canDeleteMessages*: bool
    canManageVideoChats*: bool
    canRestrictMembers*: bool
    canPromoteMembers*: bool
    canChangeInfo*: bool
    canInviteUsers*: bool
    canpostMessages*: Option[bool]
    canEditMessages*: Option[bool]
    canPinMessages*: Option[bool]
    canPostStories*: Option[bool]
    canEditStories*: Option[bool]
    canDeleteStories*: Option[bool]
    canManageTopics*: Option[bool]

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
    canManageVideoChats*: Option[bool]
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
    canPostStories*: Option[bool]
    canEditStories*: Option[bool]
    canDeleteStories*: Option[bool]
    canPinMessages*: Option[bool]
    customTitle*: Option[string]

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
    viaChatFolderInviteLink*: Option[bool]

  ChatJoinRequest* = object of TelegramObject
    chat*: Chat
    fromUser*: User
    userChatId*: int64
    date*: int
    bio*: Option[string]
    inviteLink*: Option[ChatInviteLink]

  ChatPermissions* = object of TelegramObject
    canSendMessages*: Option[bool]
    canSendAudios*: Option[bool]
    canSendDocuments*: Option[bool]
    canSendPhotos*: Option[bool]
    canSendVideos*: Option[bool]
    canSendVideoNotes*: Option[bool]
    canSendVoiceNotes*: Option[bool]
    canSendPolls*: Option[bool]
    canSendOtherMessages*: Option[bool]
    canAddWebPagePreviews*: Option[bool]
    canChangeInfo*: Option[bool]
    canInviteUsers*: Option[bool]
    canPinMessages*: Option[bool]
    canManageTopics*: Option[bool]

  ChatLocation* = object of TelegramObject
    location*: Location
    address*: string

  ForumTopic* = object of TelegramObject
    messageThreadId*: int
    name*: string
    iconColor*: int
    iconCustomEmojiId*: Option[string]

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
    thumbnail*: Option[PhotoSize]
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
    case kind* {.telebotInternalUse.}: InputMessageContentKind
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
    replyMarkup*: Option[InlineKeyboardMarkup]

  InlineQueryResultWithThumb* = object of InlineQueryResult
    thumbnailUrl*: Option[string]
    thumbnailWidth*: Option[int]
    thumbnailHeight*: Option[int]

  InlineQueryResultArticle* = object of InlineQueryResultWithThumb
    title*: string
    url*: Option[string]
    hideUrl*: Option[bool]
    description*: Option[string]

  InlineQueryResultPhoto* = object of InlineQueryResult
    photoUrl*: string
    thumbnailUrl*: string
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
    thumbnailUrl*: string
    thumbnailMimeType*: Option[string]
    title*: Option[string]
    caption*: Option[string]

  InlineQueryResultMpeg4Gif* = object of InlineQueryResult
    mpeg4Url*: string
    mpeg4Width*: Option[int]
    mpeg4Height*: Option[int]
    mpeg4Duration*: Option[int]
    thumbnailUrl*: string
    thumbnailMimeType*: Option[string]
    title*: Option[string]
    caption*: Option[string]

  InlineQueryResultVideo* = object of InlineQueryResult
    videoUrl*: string
    mimeType*: string
    thumbnailUrl*: string
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

  InlineQueryResultsButton* = ref object of TelegramObject
    text*: string
    webApp*: Option[WebAppInfo]
    startParameter*: Option[string]

  #------------------
  # Input Media
  #------------------
  InputMedia* = ref object of TelegramObject
    kind*: string
    media*: string
    thumbnail*: Option[string]
    caption*: Option[string]
    parseMode*: Option[string]
    captionEntities*: Option[seq[MessageEntity]]

  InputMediaPhoto* = ref object of InputMedia
    hasSpoiler*: Option[bool]

  InputMediaVideo* = ref object of InputMedia
    width*: Option[int]
    height*: Option[int]
    duration*: Option[int]
    supportsStreaming*: Option[bool]
    hasSpoiler*: Option[bool]

  InputMediaAnimation* = ref object of InputMedia
    width*: Option[int]
    height*: Option[int]
    duration*: Option[int]
    hasSpoiler*: Option[bool]

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

  #[
  BotCommandScope* = object of TelegramObject
    kind*: string

  BotCommandScopeDefault* = ref object of BotCommandScope

  BotCommandScopeAllPrivateChats* = ref object of BotCommandScope

  BotCommandScopeAllGroupChats* = ref object of BotCommandScope

  BotCommandScopeAllChatAdministrators* = ref object of BotCommandScope

  BotCommandScopeChat* = ref object of BotCommandScope
    chatId*: ChatId

  BotCommandScopeChatAdministrators* = ref object of BotCommandScope
    chatId*: ChatId

  BotCommandScopeChatMember* = ref object of BotCommandScope
    chatId*: ChatId
    userId*: int
  ]#

  BotName* = object of TelegramObject
    name*: string

  BotDescription* = object of TelegramObject
    description*: string

  BotShortDescription* = object of TelegramObject
    shortDescription*: string

  #------------------
  # Web App
  #------------------
  MenuButton* = ref object of TelegramObject

  MenuButtonCommands* = ref object of MenuButton
    kind*: string

  MenuButtonWebApp* = ref object of MenuButton
    kind*: string
    text*: string
    webApp*: WebAppInfo

  MenuButtonDefault* = ref object of MenuButton
    kind*: string


  WebAppInfo* = ref object of TelegramObject
    url*: string

  SentWebAppMessage* = ref object of TelegramObject
    inlineMessageId*: Option[string]

  WebAppData* = ref object of TelegramObject
    data*: string
    buttonText*: string

const DefaultChatId*: ChatId = 0

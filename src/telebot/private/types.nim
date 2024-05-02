import tables, httpclient
from asyncdispatch import Future

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

  TeleBot* = ref object of TelegramObject
    token*: string
    lastUpdateId*: BiggestInt
    updateCallbacks*: seq[UpdateCallback]
    commandCallbacks*: TableRef[string, seq[CommandCallback]]
    catchallCommandCallback*: CatchallCommandCallback
    inlineQueryCallbacks*: seq[InlineQueryCallback]
    serverUrl*: string
    proxy*: Proxy
    id*: int
    username*: string

  Command* = object
    command*: string
    message*: Message
    params*: string

  User* = ref object of TelegramObject
    id*: int
    isBot*: bool
    firstName*: string
    lastName*: string
    username*: string
    languageCode*: string
    isPremium*: bool
    addedToAttachmentMenu*: bool
    canJoinGroups: bool
    canReadAllGroupMessages: bool
    supportsInlineQueries: bool
    canConnectToBusiness*: bool

  Chat* = ref object of TelegramObject
    id*: int64
    kind*: string
    title*: string
    username*: string
    firstName*: string
    lastName*: string
    isForum*:bool
    photo*: ChatPhoto
    activeUsernames*: seq[string]
    birthdate*: Birthdate
    businessIntro*: BusinessIntro
    BusinessLocation*: BusinessLocation
    businessOpeningHours*: BusinessOpeningHours
    personalChat*: Chat
    availableReactions*: seq[ReactionType]
    accentColorId*: int
    backgroundCustomEmojiId*: string
    profileAccentColorId*: int
    profileBackgroundCustomEmojiId*: string
    emojiStatusCustomEmojiId*: string
    emojiStatusExpirationDate*: int
    bio*: string
    hasPrivateForwards*: bool
    joinToSendMessages*: bool
    joinByRequest*: bool
    description*: string
    inviteLink*: string
    pinnedMessage*: Message
    permissions*: ChatPermissions
    slowModeDelay*: int
    unrestrictBoostCount*: int
    messageAutoDeleteTime*: int
    hasAggressiveAntiSpamEnabled*: bool
    hasHiddenMembers*: bool
    hasProtectedContent*: bool
    hasVisibleHistory*: bool
    stickerSetName*: string
    canSetStickerSet*: bool
    customEmojiStickerSetName*: string
    linkedChatId*: int
    location*: ChatLocation

  PhotoSize* = ref object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    width*: int
    height*: int
    fileSize*: int

  Audio* = ref object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    duration*: int
    performer*: string
    title*: string
    fileName*: string
    mimeType*: string
    fileSize*: int
    thumbnail*: PhotoSize

  Document* = ref object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    thumbnail*: PhotoSize
    fileName*: string
    mimeType*: string
    fileSize*: int

  Story* = ref object of TelegramObject
    chat*: Chat
    id*: int

  Sticker* = ref object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    width*: int
    height*: int
    isAnimated*: bool
    isVideo*: bool
    thumbnail*: PhotoSize
    emoji*: string
    setName*: string
    premiumAnimation*: File
    maskPosition*: MaskPosition
    customEmojiId*: string
    needsRepainting*: bool
    fileSize*: int

  StickerSet* = ref object of TelegramObject
    name*: string
    title*: string
    stickerType*: string
    stickers*: seq[Sticker]
    thumbnail*: PhotoSize

  MaskPosition* = ref object of TelegramObject
    point*: string
    xShift*: float
    yShift*: float
    scale*: float

  InputSticker* = ref object of TelegramObject
    sticker*: InputFileOrString
    format*: string
    emojiList*: seq[string]
    maskPosition*: MaskPosition
    keywords*: seq[string]

  Video* = ref object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    width*: int
    height*: int
    duration*: int
    thumbnail*: PhotoSize
    fileName*: string
    mimeType*: string
    fileSize*: int

  Voice* = ref object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    duration*: int
    mimeType*: string
    fileSize*: int

  VideoNote* = ref object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    length*: int
    duration*: int
    thumbnail*: PhotoSize
    fileSize*: int

  Contact* = ref object of TelegramObject
    phoneNumber*: string
    firstName*: string
    lastName*: string
    userId*: string
    vcard*: string

  Location* = ref object of TelegramObject
    longitude*: float
    latitude*: float
    horizontalAccuracy*: float
    livePeriod*: int
    heading*: int
    proximityAlertRadius*: int

  Venue* = ref object of TelegramObject
    location*: Location
    title*: string
    address*: string
    foursquareId*: string
    foursquareType*: string
    googlePlaceId*: string
    googlePlaceType*: string

  PollOption* = ref object of TelegramObject
    text*: string
    voterCount*: int

  PollAnswer* = ref object of TelegramObject
    pollId*: string
    voterChat*: Chat
    user*: User
    optionIds*: seq[int]

  Poll* = ref object of TelegramObject
    id*: string
    question*: string
    options*: seq[PollOption]
    totalVoterCount*: int
    isClosed*: bool
    isAnonymous*: bool
    kind*: string
    allowsMultipleAnswers*: bool
    correctOptionId*: int
    explanation*: string
    explanationEntities*: seq[MessageEntity]
    openPeriod*: int
    closeDate*: int

  ProximityAlertTriggered* = ref object of TelegramObject
    traveler*: User
    watcher*: User
    distance*: int

  MessageAutoDeleteTimerChanged* = ref object of TelegramObject
    messageAutoDeleteTime*: int

  ChatBoostAdded* = ref object of TelegramObject
    boostCount*: int

  ForumTopicCreated* = ref object of TelegramObject
    name*: string
    iconColor*: int
    iconCustomEmojiId*: string

  ForumTopicClosed* = ref object of TelegramObject

  ForumTopicEdited* = ref object of TelegramObject
    name*: string
    iconCustomEmojiId*: string

  ForumTopicReopened* = ref object of TelegramObject

  GeneralForumTopicHidden* = ref object of TelegramObject

  GeneralForumTopicUnhidden* = ref object of TelegramObject

  SharedUser* = ref object of TelegramObject
    userId*: int64
    firstName*: string
    lastName*: string
    username*: string
    photo*: seq[PhotoSize]

  UsersShared* = ref object of TelegramObject
    requestId*: int
    users*: seq[SharedUser]

  ChatShared* = ref object of TelegramObject
    requestId*: int
    chatId*: int64
    title*: string
    username*: string
    photo*: seq[PhotoSize]

  WriteAccessAllowed* = ref object of TelegramObject
    fromRequest*: bool
    webAppName*: string
    fromAttachmentMenu*: bool

  VoiceChatScheduled* = ref object of TelegramObject
    startDate*: int

  VoiceChatStarted* = ref object of TelegramObject

  VoiceChatEnded* = ref object of TelegramObject
    duration*: int

  VoiceChatParticipantsInvited* = ref object of TelegramObject
    users*: seq[User]

  GiveawayCreated* = ref object of TelegramObject

  Giveaway* = ref object of TelegramObject
    chats*: seq[Chat]
    winnersSelectionDate: int
    winnerCount*: int
    onlyNewMembers*: bool
    hasPublicWinners*: bool
    prizeDescription*: string
    countryCodes*: seq[string]
    premiumSubscriptionMonthCount*: int

  GiveawayWinners* = ref object of TelegramObject
    chat*: Chat
    giveawayMessageId*: int
    winnersSelectionDate*: int
    winnerCount*: int
    winners*: seq[User]
    additionChatCount*: int
    premiumSubscriptionMonthCount*: int
    unclaimedPrizeCount*: int
    onlyNewMembers*: bool
    wasRefunded*: bool
    prizeDescription*: string

  GiveawayCompleted* = ref object of TelegramObject
    winnerCount*: int
    unclaimedPrizeCount*: int
    giveawayMessage*: Message

  LinkPreviewOptions* = ref object of TelegramObject
    isDisabled*: bool
    url*: string
    preferSmallMedia*: bool
    preferLargeMedia*: bool
    showAboveText*: bool



  UserProfilePhotos* = ref object of TelegramObject
    totalCount*: int
    photos*: seq[seq[PhotoSize]]

  Dice* = ref object of TelegramObject
    emoji*: string
    value*: int

  FileObj* = ref object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    fileSize*: int64
    filePath*: string

  KeyboardButton* = ref object of TelegramObject
    text*: string
    requestUsers*: KeyboardButtonRequestUsers
    requestChat*: KeyboardButtonRequestChat
    requestContact*: bool
    requestLocation*: bool
    requestPoll*: KeyboardButtonPollType
    webApp*: WebAppInfo

  InlineKeyboardButton* = ref object of TelegramObject
    text*: string
    url*: string
    loginUrl*: LoginUrl
    callbackData*: string
    webApp*: WebAppInfo
    switchInlineQuery*: string
    switchInlineQueryCurrentChat*: string
    switchInlineQueryChosenChat*: SwitchInlineQueryChosenChat
    callbackGame*: CallbackGame
    pay*: bool

  KeyboardKind* = enum
    kReplyKeyboardMarkup
    kReplyKeyboardRemove
    kForceReply
    kInlineKeyboardMarkup

  KeyboardMarkup* = ref object of TelegramObject
    kind* {.telebotInternalUse.}: KeyboardKind

  ReplyKeyboardMarkup* = ref object of KeyboardMarkup
    keyboard*: seq[seq[KeyboardButton]]
    isPersistent*: bool
    resizeKeyboard*: bool
    oneTimeKeyboard*: bool
    inputFieldPlaceholder*: string
    selective*: bool

  KeyboardButtonRequestUsers* = ref object of TelegramObject
    requestId*: int
    userIsBot*: bool
    userIsPremium*: bool
    maxQuantity*: int
    requestName*: bool
    requestUsername*: bool
    requestPhoto*: bool

  KeyboardButtonRequestChat* = ref object of TelegramObject
    requestId*: int
    chatIsChannel*: bool
    chatIsForum*: bool
    chatHasUsername*: bool
    chatIsCreated*: bool
    userAdministratorRights*: ChatAdministratorRights
    botAdministratorRights*: ChatAdministratorRights
    botIsMember*: bool
    requestTitle*: bool
    requestUsername*: bool
    requestPhoto*: bool

  KeyboardButtonPollType* = ref object of TelegramObject
    kind*: string

  ReplyKeyboardRemove* = ref object of KeyboardMarkup
    selective*: bool

  ForceReply* = ref object of KeyboardMarkup
    forceReply*: bool
    inputFieldPlaceholder*: string
    selective*: bool

  InlineKeyboardMarkup* = ref object of KeyboardMarkup
    inlineKeyboard*: seq[seq[InlineKeyboardButton]]

  LoginUrl* = ref object of TelegramObject
    url*: string
    forwardText*: string
    botUsername*: string
    requestWriteAccess*: bool

  CallbackGame* = ref object of TelegramObject

  GameHighScore* = ref object of TelegramObject
    position*: int
    user*: User
    score*: int

  SwitchInlineQueryChosenChat* = ref object of TelegramObject
    query*: string
    allowUserChats*: bool
    allowBotChats*: bool
    allowGroupChats*: bool
    allowChannelChats*: bool


  CallbackQuery* = ref object of TelegramObject
    id*: string
    fromUser*: User
    message*: Message
    inlineMessageId*: string
    chatInstance*: string
    data*: string
    gameShortName*: string

  MessageEntity* = ref object of TelegramObject
    kind*: string
    offset*: int
    length*: int
    url*: string
    user*: User
    language*: string
    customEmojiId*: string

  TextQuote* = ref object of TelegramObject
    text*: string
    entities*: seq[MessageEntity]
    positon*: int
    isManual*: bool

  MessageOriginKind* = enum
    kindMessageOriginUser = "user"
    kindMessageOriginHiddenUser = "hidden_user"
    kindMessageOriginChat = "chat"
    kindMessageOriginChannel = "channel"

  MessageOrigin* = ref object of TelegramObject
    date*: int
    case kind*: MessageOriginKind
    of kindMessageOriginUser:
      senderUser*: User
    of kindMessageOriginHiddenUser:
      senderUserName*: string
    of kindMessageOriginChat:
      senderChat*: Chat
    of kindMessageOriginChannel:
      chat*: Chat
      messageId*: int
    # only available for MessageOriginChat and MessageOriginChannel
    authorSignature*: string

  ExternalReplyInfo* = ref object of TelegramObject
    origin*: MessageOrigin
    chat*: Chat
    messageId*: int
    linkPreviewOptions*: LinkPreviewOptions
    animation*: Animation
    audio*: Audio
    document*: Document
    photo*: seq[PhotoSize]
    sticker*: Sticker
    story*: Story
    video*: Video
    videoNote*: VideoNote
    voice*: Voice
    hasMediaSpoiler*: bool
    contact*: Contact
    dice*: Dice
    game*: Game
    giveaway*: Giveaway
    giveawayWinners*: GiveawayWinners
    invoice*: Invoice
    location*: Location
    poll*: Poll
    venue*: Venue

  ReplyParameters* = ref object of TelegramObject
    messageId*: int
    chatId*: seq[int]
    allowSendingWithoutReply*: bool
    quote*: string
    quoteParseMode*: string
    quoteEntities*: seq[MessageEntity]
    quotePostion*: int

  Message* = ref object of TelegramObject
    messageId*: int
    messageThreadId*: int
    fromUser*: User
    senderChat*: Chat
    senderBoostCount*: int
    senderBusinessBot*: User
    date*: int
    businessConnectionId*: string
    chat*: Chat
    forwardOrigin*: MessageOrigin
    isTopicMessage*: bool
    isAutomaticForward*: bool
    replyToMessage*: Message
    externalReply*: ExternalReplyInfo
    quote*: TextQuote
    replyToStory*: Story
    viaBot*: User
    editDate*: int
    hasProtectedContent*: bool
    isFromOffline*: bool
    mediaGroupId*: string
    authorSignature*: string
    text*: string
    entities*: seq[MessageEntity]
    linkPreviewOptions*: LinkPreviewOptions
    animation*: Animation
    audio*: Audio
    document*: Document
    photo*: seq[PhotoSize]
    sticker*: Sticker
    story*: Story
    video*: Video
    videoNote*: VideoNote
    voice*: Voice
    caption*: string
    captionEntities*: seq[MessageEntity]
    hasMediaSpoiler*: bool
    contact*: Contact
    dice*: Dice
    game*: Game
    poll*: Poll
    venue*: Venue
    location*: Location
    newChatMembers*: seq[User]
    leftChatMember*: User
    newChatTitle*: string
    newChatPhoto*: seq[PhotoSize]
    deleteChatPhoto*: bool
    groupChatCreated*: bool
    superGroupChatCreated*: bool
    chanelChatCreated*: bool
    messageAutoDeleteTimerChanged*: MessageAutoDeleteTimerChanged
    migrateToChatId*: int64
    migrateFromChatId*: int64
    pinnedMessage*: Message
    invoice*: Invoice
    successfulPayment*: SuccessfulPayment
    usersShared*: UsersShared
    chatShared*: ChatShared
    connectedWebsite*: string
    writeAccessAllowed*: WriteAccessAllowed
    passportData*: PassportData
    proximityAlertTriggered*: ProximityAlertTriggered
    boostAdded*: ChatBoostAdded
    forumTopicCreated*: ForumTopicCreated
    forumTopicEdited*: ForumTopicEdited
    forumTopicClosed*: ForumTopicClosed
    forumTopicReopened*: ForumTopicReopened
    generalForumTopicHidden*: GeneralForumTopicHidden
    generalForumTopicUnhidden*: GeneralForumTopicUnhidden
    giveawayCreated*: GiveawayCreated
    giveaway*: Giveaway
    giveawayWinners*: GiveawayWinners
    giveawayCompleted*: GiveawayCompleted
    videoChatScheduled*: VoiceChatScheduled
    videoChatStarted*: VoiceChatStarted
    videoChatEnded*: VoiceChatEnded
    videoChatParticipantsInvited*: VoiceChatParticipantsInvited
    webAppData*: WebAppData
    replyMarkup*: InlineKeyboardMarkup

  MessageId* = ref object of TelegramObject
    messageId*: int

  #InaccessibleMessage* = ref object of TelegramObject
  #  chat*: Chat
  #  messageId*: int
  #  date*: int

  #MaybeInaccessibleMessage* = Message|InaccessibleMessage

  ChatPhoto* = ref object of TelegramObject
    smallFileId*: string
    smallFileUniqueId*: string
    bigFileId*: string
    bigFileUniqueId*: string

  ChatInviteLink* = ref object of TelegramObject
    inviteLink*: string
    creator*: User
    createsJoinRequest*: bool
    isPrimary*: bool
    isRevoked*: bool
    name*: string
    expireDate*: int
    memberLimit*: int
    pendingJoinRequestCount*: int

  ChatAdministratorRights* = ref object of TelegramObject
    isAnonymous*: bool
    canManageChat*: bool
    canDeleteMessages*: bool
    canManageVideoChats*: bool
    canRestrictMembers*: bool
    canPromoteMembers*: bool
    canChangeInfo*: bool
    canInviteUsers*: bool
    canpostMessages*: bool
    canEditMessages*: bool
    canPinMessages*: bool
    canPostStories*: bool
    canEditStories*: bool
    canDeleteStories*: bool
    canManageTopics*: bool

  ChatMember* = ref object of TelegramObject
    user*: User
    status*: string
    #TODO these properties below will be removed infavor of 6 types of chat members
    customTitle*: string
    isAnonymous*: bool
    untilDate*: int
    canBeEdited*: bool
    canManageChat*: bool
    canPostMessages*: bool
    canEditMessages*: bool
    canDeleteMessages*: bool
    canManageVideoChats*: bool
    canRestrictMembers*: bool
    canPromoteMembers*: bool
    canChangeInfo*: bool
    canInviteUsers*: bool
    canPinMessages*: bool
    isMember*: bool
    canSendMessages*: bool
    canSendMediaMessages*: bool
    canSendPolls*: bool
    canSendOtherMessages*: bool
    canAddWebPagePreviews*: bool

  #[ I dont know how these types work yet
  ChatMember* = ref object of TelegramObject
    user*: User
    status*: string

  ChatMemberOwner* = ref object of ChatMember
    customTitle*: string
    isAnonymous*: bool

  ChatMemberAdministrator* = ref object of ChatMemberOwner
    canBeEdited*: bool
    canManageChat*: bool
    canDeleteMessages*: bool
    canManageVoiceChats*: bool
    canRestrictMembers*: bool
    canPromoteMembers*: bool
    canChangeInfo*: bool
    canInviteUsers*: bool
    canPostMessages*: bool
    canEditMessages*: bool
    canPostStories*: bool
    canEditStories*: bool
    canDeleteStories*: bool
    canPinMessages*: bool
    customTitle*: string

  ChatMemberMember* = ref object of ChatMember

  ChatMemberRestricted* = ref object of ChatMember
    isMember*: bool
    canChangeInfo*: bool
    canInviteUsers*: bool
    canPinMessages*: bool
    canSendMessages*: bool
    canSendMediaMessages*: bool
    canSendPolls*: bool
    canSendOtherMessages*: bool
    canAddWebPagePreviews*: bool
    untilDate*: int

  ChatMemberLeft* = ref object of ChatMember

  ChatMemberBanned* = ref object of ChatMember
    untilDate*: int
  ]#

  ChatMemberUpdated* = ref object of TelegramObject
    chat*: Chat
    fromUser*: User
    date*: int
    oldChatMember*: ChatMember
    newChatMember*: ChatMember
    inviteLink*: ChatInviteLink
    viaChatFolderInviteLink*: bool

  ChatJoinRequest* = ref object of TelegramObject
    chat*: Chat
    fromUser*: User
    userChatId*: int64
    date*: int
    bio*: string
    inviteLink*: ChatInviteLink

  ChatPermissions* = ref object of TelegramObject
    canSendMessages*: bool
    canSendAudios*: bool
    canSendDocuments*: bool
    canSendPhotos*: bool
    canSendVideos*: bool
    canSendVideoNotes*: bool
    canSendVoiceNotes*: bool
    canSendPolls*: bool
    canSendOtherMessages*: bool
    canAddWebPagePreviews*: bool
    canChangeInfo*: bool
    canInviteUsers*: bool
    canPinMessages*: bool
    canManageTopics*: bool

  Birthdate* = ref object of TelegramObject
    day*: int
    month*: int
    year*: int

  BusinessIntro* = ref object of TelegramObject
    title*: string
    message*: string
    sticker*: Sticker

  BusinessLocation* = ref object of TelegramObject
    address*: string
    location*: Location

  BusinessOpeningHoursInterval* = ref object of TelegramObject
    openingMinute*: int
    closingMinute*: int

  BusinessOpeningHours* = ref object of TelegramObject
    timeZoneName*: string
    openingHours*: seq[BusinessOpeningHours]

  ChatLocation* = ref object of TelegramObject
    location*: Location
    address*: string

  ReactionTypeKind* = enum
    kindReactionTypeEmoji = "emoji"
    kindReactionTypeCustomEmoji = "custom_emoji"

  ReactionType* = ref object of TelegramObject
    case kind*: ReactionTypeKind
    of kindReactionTypeEmoji:
      emoji*: string
    of kindReactionTypeCustomEmoji:
      customEmoji*: string

  ReactionCount* = ref object of TelegramObject
    kind*: ReactionType
    totalCount*: int

  MessageReactionUpdated* = ref object of TelegramObject
    chat*: Chat
    messageId*: int
    user*: User
    actorChat*: Chat
    date*: int
    oldReaction*: seq[ReactionType]
    newReaction*: seq[ReactionType]

  MessageReactionCountUpdated* = ref object of TelegramObject
    chat*: Chat
    messageId*: int
    date*: int
    reactions*: seq[ReactionCount]


  ForumTopic* = ref object of TelegramObject
    messageThreadId*: int
    name*: string
    iconColor*: int
    iconCustomEmojiId*: string

  BotCommand* = ref object of TelegramObject
    command*: string
    description*: string

  ResponseParameters* = ref object of TelegramObject
    migrateToChatId*: int64
    retryAfter*: int

  Update* = ref object of TelegramObject
    updateId*: int
    message*: Message
    editedMessage*: Message
    channelPost*: Message
    editedChannelPost*: Message
    businessConnection*: BusinessConnection
    businessMessage*: Message
    editedBusinessMessage*: Message
    deletedBusinessMessages*: BusinessMessagesDeleted
    messageReaction*: MessageReactionUpdated
    messageReactionCount*: MessageReactionCountUpdated
    inlineQuery*: InlineQuery
    chosenInlineResult*: ChosenInlineResult
    callbackQuery*: CallbackQuery
    shippingQuery*: ShippingQuery
    preCheckoutQuery*: PreCheckoutQuery
    poll*: Poll
    pollAnswer*: PollAnswer
    myChatMember*: ChatMemberUpdated
    chatMember*: ChatMemberUpdated
    chatJoinRequest*: ChatJoinRequest

  #------------------
  # Game
  #------------------
  Animation* = ref object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    thumbnail*: PhotoSize
    fileName*: string
    mimeType*: string
    fileSize*: int

  Game* = ref object of TelegramObject
    title*: string
    description*: string
    photo*: seq[PhotoSize]
    text*: string
    textEntities*: seq[MessageEntity]
    animation*: Animation

  #------------------
  # Payment
  #------------------
  Invoice* = ref object of TelegramObject
    title*: string
    description*: string
    startParameter*: string
    currency*: string
    totalAmount*: int

  ShippingAddress* = ref object of TelegramObject
    countryCode*: string
    state*: string
    city*: string
    streetLine1*: string
    streetLine2*: string
    postCode*: string

  OrderInfo* = ref object of TelegramObject
    name*: string
    phoneNumber*: string
    email*: string
    shippingAddress*: ShippingAddress

  LabeledPrice* = ref object of TelegramObject
    label*: string
    amount*: int

  ShippingOption* = ref object of TelegramObject
    id*: string
    title*: string
    prices*: seq[LabeledPrice]

  SuccessfulPayment* = ref object of TelegramObject
    currentcy*: string
    totalAmount*: int
    invoicePayload*: string
    shippingOptionId*: string
    orderInfo*: OrderInfo
    telegramPaymentChargeId*: string
    providerPaymentChargeId*: string

  ShippingQuery* = ref object of TelegramObject
    id*: string
    fromUser*: User
    invoicePayload*: string
    shippingAddress*: ShippingAddress

  PreCheckoutQuery* = ref object of TelegramObject
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
      parseMode*: string
      linkPreviewOptions*: LinkPreviewOptions
      captionEntities*: seq[MessageEntity]
    of LocationMessage:
      latitude*: float
      longitude*: float
      livePeriod*: int
      heading*: int
    of VenueMessage:
      venueLatitude*: float
      venueLongitude*: float
      venueTitle*: string
      venueAddress*: string
      foursquareId*: string
      foursquareType*: string
      googlePlaceId*: string
      googlePlaceType*: string
    of ContactMessage:
      phoneNumber*: string
      firstName*: string
      lastName*: string
      vcard*: string
    of InvoiceMessage:
      title*: string
      description*: string
      payload*: string
      providerToken*: string
      currrency*: string
      prices*: seq[LabeledPrice]
      maxTipAmount*: int
      suggestedTipAmounts*: seq[int]
      providerData*: string
      photoUrl*: string
      photoSize*: int
      photoWidth*: int
      photoHeight*: int
      needName*: bool
      needPhoneNumber*: bool
      needEmail*: bool
      needShippingAddress*: bool
      sendPhoneNumberToProvider*: bool
      sendEmailToProvider*: bool
      isFlexible*: bool

  InlineQueryResult* = ref object of TelegramObject
    kind*: string
    id*: string
    captionEntities*: seq[MessageEntity]
    inputMessageContent*: InputMessageContent
    replyMarkup*: InlineKeyboardMarkup

  InlineQueryResultWithThumb* = ref object of InlineQueryResult
    thumbnailUrl*: string
    thumbnailWidth*: int
    thumbnailHeight*: int

  InlineQueryResultArticle* = ref object of InlineQueryResultWithThumb
    title*: string
    url*: string
    hideUrl*: bool
    description*: string

  InlineQueryResultPhoto* = ref object of InlineQueryResult
    photoUrl*: string
    thumbnailUrl*: string
    photoWidth*: int
    photoHeight*: int
    title*: string
    description*: string
    caption*: string

  InlineQueryResultGif* = ref object of InlineQueryResult
    gifUrl*: string
    gifWidth*: int
    gifHeight*: int
    gifDuration*: int
    thumbnailUrl*: string
    thumbnailMimeType*: string
    title*: string
    caption*: string

  InlineQueryResultMpeg4Gif* = ref object of InlineQueryResult
    mpeg4Url*: string
    mpeg4Width*: int
    mpeg4Height*: int
    mpeg4Duration*: int
    thumbnailUrl*: string
    thumbnailMimeType*: string
    title*: string
    caption*: string

  InlineQueryResultVideo* = ref object of InlineQueryResult
    videoUrl*: string
    mimeType*: string
    thumbnailUrl*: string
    title*: string
    caption*: string
    videoWidth*: int
    videoHeight*: int
    videoDuration*: int
    description*: string

  InlineQueryResultAudio* = ref object of InlineQueryResult
    audioUrl*: string
    title*: string
    caption*: string
    performer*: string
    audioDuration*: int

  InlineQueryResultVoice* = ref object of InlineQueryResult
    voiceUrl*: string
    title*: string
    caption*: string
    voiceDuration*: int

  InlineQueryResultDocument* = ref object of InlineQueryResultWithThumb
    title*: string
    caption*: string
    documentUrl*: string
    mimeType*: string
    description*: string

  InlineQueryResultLocation* = ref object of InlineQueryResultWithThumb
    latitude*: float
    longitude*: float
    title*: string
    horizontalAccuracy*: float
    livePeriod*: int
    heading*: int
    proximityAlertRadius*: int

  InlineQueryResultVenue* = ref object of InlineQueryResultWithThumb
    latitude*: float
    longitude*: float
    title*: string
    address*: string
    foursquareId*: string
    foursquareType*: string
    googlePlaceId*: string
    googlePlaceType*: string

  InlineQueryResultContact* = ref object of InlineQueryResultWithThumb
    phoneNumber*: string
    firstName*: string
    lastName*: string
    vcard*: string

  InlineQueryResultGame* = ref object of InlineQueryResult
    gameShortName*: string

  InlineQueryResultCachedPhoto* = ref object of InlineQueryResult
    photoFileId*: string
    title*: string
    description*: string
    caption*: string

  InlineQueryResultCachedGif* = ref object of InlineQueryResult
    gifFileId*: string
    title*: string
    caption*: string

  InlineQueryResultCachedMpeg4Gif* = ref object of InlineQueryResult
    mpeg4FileId*: string
    title*: string
    caption*: string

  InlineQueryResultCachedSticker* = ref object of InlineQueryResult
    stickerFileId*: string

  InlineQueryResultCachedVideo* = ref object of InlineQueryResult
    videoFileId*: string
    title*: string
    caption*: string
    description*: string

  InlineQueryResultCachedAudio* = ref object of InlineQueryResult
    audioFileId*: string
    caption*: string

  InlineQueryResultCachedVoice* = ref object of InlineQueryResult
    voiceFileId*: string
    title*: string
    caption*: string

  InlineQueryResultCachedDocument* = ref object of InlineQueryResult
    title*: string
    caption*: string
    documentFileId*: string
    description*: string

  InlineQuery* = ref object of TelegramObject
    id*: string
    fromUser*: User
    query*: string
    offset*: string
    chatType: string
    location*: Location

  ChosenInlineResult* = ref object of TelegramObject
    resultId*: string
    fromUser*: User
    location*: Location
    inlineMessageId*: string
    query*: string

  InlineQueryResultsButton* = ref object of TelegramObject
    text*: string
    webApp*: WebAppInfo
    startParameter*: string

  #------------------
  # Input Media
  #------------------
  InputMedia* = ref object of TelegramObject
    kind*: string
    media*: string
    thumbnail*: string
    caption*: string
    parseMode*: string
    captionEntities*: seq[MessageEntity]

  InputMediaPhoto* = ref object of InputMedia
    hasSpoiler*: bool

  InputMediaVideo* = ref object of InputMedia
    width*: int
    height*: int
    duration*: int
    supportsStreaming*: bool
    hasSpoiler*: bool

  InputMediaAnimation* = ref object of InputMedia
    width*: int
    height*: int
    duration*: int
    hasSpoiler*: bool

  InputMediaAudio* = ref object of InputMedia
    duration*: int
    performer*: string
    title*: string

  InputMediaDocument* = ref object of InputMedia
    disableContentTypeDetection*: bool


  InputMediaSet* = InputMediaPhoto|InputMediaVideo|InputMediaAnimation|InputMediaAudio|InputMediaDocument

  #------------------
  # Passport
  #------------------
  PassportFile* = ref object of TelegramObject
    fileId*: string
    fileUniqueId*: string
    fileSize*: int
    fileDate*: int

  EncryptedPassportElement* = ref object of TelegramObject
    kind*: string
    data*: string
    phoneNumber*: string
    email*: string
    files*: seq[PassportFile]
    frontSide*: PassportFile
    reverseSide*: PassportFile
    selfie*: PassportFile
    translation*: seq[PassportFile]
    hash*: string

  EncryptedCredentials* = ref object of TelegramObject
    data*: string
    hash*: string
    secret*: string

  PassportData* = ref object of TelegramObject
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
  BotCommandScope* = ref object of TelegramObject
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

  BotName* = ref object of TelegramObject
    name*: string

  BotDescription* = ref object of TelegramObject
    description*: string

  BotShortDescription* = ref object of TelegramObject
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
    inlineMessageId*: string

  WebAppData* = ref object of TelegramObject
    data*: string
    buttonText*: string

  #------------------
  # Chat Boost
  #------------------

  ChatBoostSourceKind* = enum
    kindChatBoostSourcePremium
    kindChatBoostSourceGiftCode
    kindChatBoostSourceGiveaway

  ChatBoostSource* = ref object of TelegramObject
    user*: User
    case source*: ChatBoostSourceKind
    of kindChatBoostSourceGiveaway:
      giveawayMessageId*: int
      isUncaimed*: bool
    else: discard

  ChatBoost* = ref object of TelegramObject
    boostId*: string
    addDate*: int
    expireDate*: int
    source*: ChatBoostSource

  ChatBoostUpdated* = ref object of TelegramObject
    chat*: Chat
    boost*: ChatBoost

  ChatBoostRemoved* = ref object of TelegramObject
    chat*: Chat
    boostId*: string
    removeDate*: int
    source*: ChatBoostSource

  UserChatBoosts* = ref object of TelegramObject
    boosts*: seq[ChatBoost]

  BusinessConnection* = ref object of TelegramObject
    id*: string
    user*: User
    userChatId*: int64
    date*: int
    canReply*: bool
    isEnabled*: bool

  BusinessMessagesDeleted* = ref object of TelegramObject
    businessConnectionId*: string
    chat*: Chat
    messageIds*: seq[int]

const DefaultChatId*: ChatId = 0


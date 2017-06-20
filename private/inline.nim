import asyncdispatch

type
  User = object
  Location = object
  InlineKeyboardMarkup = object

  InlineQueryResult* = object of RootObj
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

proc answerInlineQuery*(id: string, results: openArray[InlineQueryResult], cacheTime = 0, isPersonal = false, nextOffset = "", switchPmText = "", switchPmParameter = ""): Future[bool] {.async.} =
  discard

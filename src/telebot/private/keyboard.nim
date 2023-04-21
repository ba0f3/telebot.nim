import types, strutils, utils, options

proc initKeyBoardButton*(text: string, requestChat: KeyboardButtonRequestChat = nil, requestContact = false, requestLocation = false, requestPoll: KeyboardButtonPollType = nil, webApp: WebAppInfo = nil): KeyboardButton =
  result.text = text
  if requestChat != nil: result.requestChat = some(requestChat)
  if requestContact: result.requestContact = some(true)
  if requestLocation: result.requestLocation = some(true)
  if requestPoll != nil: result.requestPoll = some(requestPoll)
  if webApp != nil: result.webApp = some(webApp)

proc newReplyKeyboardMarkup*(keyboards: varargs[seq[KeyboardButton]], isPersistent = false, resizeKeyboard = false, oneTimeKeyboard = false, inputFieldPlaceholder = "", selective = false): ReplyKeyboardMarkup =
  new(result)
  result.kind = kReplyKeyboardMarkup
  for keyboard in keyboards:
    result.keyboard.add(keyboard)
  if isPersistent: result.isPersistent = some(true)
  if resizeKeyboard: result.resizeKeyboard = some(true)
  if oneTimeKeyboard: result.oneTimeKeyboard = some(true)
  if inputFieldPlaceholder.len != 0: result.inputFieldPlaceholder = some(inputFieldPlaceholder)
  if selective: result.selective = some(true)

proc initInlineKeyBoardButton*(text: string, url = "", loginUrl: LoginUrl = nil, callbackData = "", webApp: WebAppInfo = nil, switchInlineQuery = "", switchInlineQueryCurrentChat = "", callbackGame: CallbackGame = nil, pay = false): InlineKeyboardButton =
  result.text = text
  if url.len != 0: result.url = some(url)
  if loginUrl  != nil: result.loginUrl = some(loginUrl)
  if callbackData.len != 0: result.callbackData = some(callbackData)
  if webApp != nil: result.webApp = some(webApp)
  if switchInlineQuery.len != 0: result.switchInlineQuery = some(switchInlineQuery)
  if switchInlineQueryCurrentChat.len != 0: result.switchInlineQueryCurrentChat = some(switchInlineQueryCurrentChat)
  if callbackGame != nil: result.callbackGame = some(callbackGame)
  if pay: result.pay = some(pay)

proc newInlineKeyboardMarkup*(keyboards: varargs[seq[InlineKeyBoardButton]]): InlineKeyboardMarkup =
  new(result)
  result.kind = kInlineKeyboardMarkup
  for keyboard in keyboards:
    result.inlineKeyboard.add(keyboard)

proc newReplyKeyboardRemove*(selective = false): ReplyKeyboardRemove =
  new(result)
  result.kind = kReplyKeyboardRemove
  if selective:
    result.selective = some(true)

proc newForceReply*(selective = false, inputFieldPlaceholder = ""): ForceReply =
  new(result)
  result.kind = kForceReply
  result.forceReply = some(true)
  result.selective = some(selective)
  if inputFieldPlaceholder.len != 0:
    result.inputFieldPlaceholder = some(inputFieldPlaceholder)
  if selective:
    result.selective = some(true)

proc `$`*(k: KeyboardMarkup): string =
  case k.kind:
  of kInlineKeyboardMarkup:
    marshal(InlineKeyboardMarkup(k), result)
  of kReplyKeyboardMarkup:
    marshal(ReplyKeyboardMarkup(k), result)
  of kReplyKeyboardRemove:
    let kb = ReplyKeyboardMarkup(k)
    if kb.selective.get(false):
      result = "{\"remove_keyboard\": true, \"selective\": true}"
    else:
      result = "{\"remove_keyboard\": true}"
  of kForceReply:
      marshal(ForceReply(k), result)

proc newLoginUrl*(url: string, forwardText = "", botUsername = "", requestWriteAccess = false): LoginUrl =
  new(result)
  result.url = url
  if forwardText.len > 0:
    result.forwardText = forwardText.some
  if botUsername.len > 0:
    result.botUsername = botUsername.some
  if requestWriteAccess:
    result.requestWriteAccess = requestWriteAccess.some

import types, strutils, utils, options

proc initKeyBoardButton*(text: string): KeyboardButton =
  result.text = text

proc newReplyKeyboardMarkup*(keyboards: varargs[seq[KeyboardButton]], inputFieldPlaceholder = ""): ReplyKeyboardMarkup =
  new(result)
  result.type = kReplyKeyboardMarkup
  for keyboard in keyboards:
    result.keyboard.add(keyboard)
  if inputFieldPlaceholder.len != 0:
    result.inputFieldPlaceholder = some(inputFieldPlaceholder)

proc initInlineKeyBoardButton*(text: string): InlineKeyboardButton =
  result.text = text

proc newInlineKeyboardMarkup*(keyboards: varargs[seq[InlineKeyBoardButton]]): InlineKeyboardMarkup =
  new(result)
  result.type = kInlineKeyboardMarkup
  for keyboard in keyboards:
    result.inlineKeyboard.add(keyboard)


proc newReplyKeyboardRemove*(selective: bool): ReplyKeyboardRemove =
  new(result)
  result.type = kReplyKeyboardRemove
  result.selective = some(selective)

proc newForceReply*(selective: bool, inputFieldPlaceholder = ""): ForceReply =
  new(result)
  result.type = kForceReply
  result.selective = some(selective)
  if inputFieldPlaceholder.len != 0:
    result.inputFieldPlaceholder = some(inputFieldPlaceholder)

proc `$`*(k: KeyboardMarkup): string =
  case k.type:
  of kInlineKeyboardMarkup:
    marshal(InlineKeyboardMarkup(k), result)
  of kReplyKeyboardMarkup:
    marshal(ReplyKeyboardMarkup(k), result)
  of kReplyKeyboardRemove:
    if k.selective.get(false):
      result = "{'remove_keyboard': true, 'selective': true}"
    else:
      result = "{'remove_keyboard': true}"
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
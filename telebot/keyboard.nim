import types, sam, strutils, utils, options, tables

proc initKeyBoardButton*(text: string): KeyboardButton =
  result.text = text

proc newReplyKeyboardMarkup*(keyboards: varargs[seq[KeyboardButton]]): KeyboardMarkup =
  new(result)
  result.`type` = kReplyKeyboardMarkup
  for keyboard in keyboards:
    result.keyboard.add(keyboard)

proc initInlineKeyBoardButton*(text: string): InlineKeyboardButton =
  result.text = text

proc newInlineKeyboardMarkup*(keyboards: varargs[seq[InlineKeyBoardButton]]): KeyboardMarkup =
  new(result)
  result.`type` = kInlineKeyboardMarkup
  for keyboard in keyboards:
    result.inlineKeyboard.add(keyboard)

proc newReplyKeyboardRemove*(selective: bool): KeyboardMarkup =
    new(result)
    result.`type` = kReplyKeyboardRemove
    result.selective = some(selective)

proc newForceReply*(selective: bool): KeyboardMarkup =
  new(result)
  result.`type` = kForceReply
  result.selective = some(selective)

proc `$`*(k: KeyboardMarkup): string =
  case k.`type`
  of kReplyKeyboardMarkup, kInlineKeyboardMarkup:
    marshal(k, result)
  of kReplyKeyboardRemove:
    if k.selective.get(false):
      return "{'remove_keyboard': true, 'selective': true}"
    else:
      return "{'remove_keyboard': true}"
  of kForceReply:
    if k.selective.get(false):
      return "{'force_reply': true, 'selective': true}"
    else:
      return "{'force_reply': true}"

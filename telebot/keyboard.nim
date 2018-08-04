import types, json, strutils, utils, options

proc initKeyBoardButton*(text: string): KeyboardButton =
  result.text = text

proc newReplyKeyboardMarkup*(keyboards: varargs[seq[KeyboardButton]]): KeyboardMarkup =
  new(result)
  result.kind = kReplyKeyboardMarkup
  result.keyboard = @[]
  for keyboard in keyboards:
    result.keyboard.add(keyboard)

proc initInlineKeyBoardButton*(text: string): InlineKeyboardButton =
  result.text = text

proc newInlineKeyboardMarkup*(keyboards: varargs[seq[InlineKeyBoardButton]]): KeyboardMarkup =
  new(result)
  result.kind = kInlineKeyboardMarkup
  result.inlineKeyboard = @[]
  for keyboard in keyboards:
    result.inlineKeyboard.add(keyboard)

proc newReplyKeyboardRemove*(selective: bool): KeyboardMarkup =
    new(result)
    result.kind = kReplyKeyboardRemove
    result.selective = some(selective)

proc newForceReply*(selective: bool): KeyboardMarkup =
  new(result)
  result.kind = kForceReply
  result.selective = some(selective)

proc `$`*(k: KeyboardButton): string =
  var j = newJObject()
  j["text"] = %k.text
  if k.requestContact.get:
    j["request_contact"] = newJBool(true)
  if k.requestLocation.get:
    j["request_location"] = newJBool(true)

  result = $j

proc `$`*(k: KeyboardMarkup): string =
  var j = newJObject()
  case k.kind
  of kReplyKeyboardMarkup:

    var kb = newJArray()
    for row in k.keyboard:
      var n = newJArray()
      for button in row:
        n.add(%button)
      kb.add(n)
    j["keyboard"] = kb
    if k.selective.isSome and k.selective.get:
      j["selective"] = newJBool(true)
    if k.resizeKeyboard.isSome and k.resizeKeyboard.get:
      j["resize_keyboard"] = newJBool(true)
    if k.oneTimeKeyboard.isSome and k.oneTimeKeyboard.get:
      j["one_time_keyboard"] = newJBool(true)
  of kInlineKeyboardMarkup:
    echo "here ===================="
    var kb = newJArray()
    for row in k.inlineKeyboard:
      var n = newJArray()
      for button in row:
        n.add(%button)
      kb.add(n)
    j["inline_keyboard"] = kb
  of kReplyKeyboardRemove:
    if k.selective.isNone or not k.selective.get:
      return "{'remove_keyboard': true}"
    else:
      return "{'remove_keyboard': true, 'selective': true}"
  of kForceReply:
    if k.selective.isNone or not k.selective.get:
      return "{'force_reply': true}"
    else:
      return "{'force_reply': true, 'selective': true}"

  result = $j

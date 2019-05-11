import types, json, strutils, utils, options, tables

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

proc `$`*(k: KeyboardButton): string =
  var j = newJObject()
  j["text"] = %k.text
  if k.requestContact.get(false):
    j["request_contact"] = newJBool(true)
  if k.requestLocation.get(false):
    j["request_location"] = newJBool(true)

  result = $j

proc `$`*(k: KeyboardMarkup): string =
  var j = newJObject()
  case k.`type`
  of kReplyKeyboardMarkup:
    var kb = newJArray()
    for row in k.keyboard:
      var n = newJArray()
      for button in row:
        n.add(%button)
      kb.add(n)
    j["keyboard"] = kb
    if k.selective.get(false):
      j["selective"] = newJBool(true)
    if k.resizeKeyboard.get(false):
      j["resize_keyboard"] = newJBool(true)
    if k.oneTimeKeyboard.get(false):
      j["one_time_keyboard"] = newJBool(true)
  of kInlineKeyboardMarkup:
    var kb = newJArray()
    for row in k.inlineKeyboard:
      var n = newJArray()
      for button in row:
        var b = %button
        for key in b.getFields.keys:
          let jsonKey = formatName(key)
          if b[key].kind == JNull:
            b.delete(key)
          elif jsonKey != key:
            b[jsonKey] = b[key]
            b.delete(key)
        n.add(b)
      kb.add(n)
    j["inline_keyboard"] = kb
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

  result = $j

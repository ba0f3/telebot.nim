import types, json, strutils, utils, options

proc getMessage*(n: JsonNode): Message {.inline.} =
  result = unmarshal(n, Message)

proc `$`*(k: KeyboardButton): string =
  var j = newJObject()
  j["text"] = %k.text
  if k.requestContact.get:
    j["request_contact"] = %true
  if k.requestLocation.get:
    j["request_location"] = %true

  result = $j

proc `$`*(k: ReplyKeyboardMarkup): string =
  var j = newJObject()
  var kb = newJArray()
  for x in k.keyboard:
    var n = newJArray()
    for y in x:
      n.add(%y)
    kb.add(n)
  j["keyboard"] = kb
  if k.selective.isSome and k.selective.get:
    j["selective"] = %k.selective
  if k.resizeKeyboard.isSome and k.resizeKeyboard.get:
    j["resize_keyboard"] = %k.resizeKeyboard
  if k.oneTimeKeyboard.isSome and k.oneTimeKeyboard.get:
    j["one_time_keyboard"] = %k.oneTimeKeyboard

  result = $j

proc initReplyKeyboardMarkup*(kb: seq[seq[KeyboardButton]]): ReplyKeyboardMarkup =
  result.keyboard = kb

proc `$`*(k: ReplyKeyboardRemove): string =
  if k.selective.isNone or not k.selective.get:
    return "{'remove_keyboard': true}"
  else:
    return "{'remove_keyboard': true, 'selective': true}"


proc `$`*(k: ForceReply): string =
  if k.selective.isNone or not k.selective.get:
    return "{'force_reply': true}"
  else:
    return "{'force_reply': true, 'selective': true}"


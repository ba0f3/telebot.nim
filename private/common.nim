import types, json, strutils, utils, options

proc getMessage*(n: JsonNode): Message {.inline.} =
  result = unmarshal(n, Message)


discard """
proc processUpdates*(b: TeleBot, n: JsonNode): seq[Update] =
  result = @[]
  var u: Update
  for x in n:
    
    u.updateId = x["update_id"].num.int
    if u.updateId > b.lastUpdateId:
      b.lastUpdateId = u.updateId

    if x.hasKey("message"):
      u.kind = kMessage
      u.message = getMessage(x["message"])
    elif x.hasKey("edited_message"):
      u.kind = kEditedMessage
      u.editedMessage = getMessage(x["edited_message"])
    elif x.hasKey("channel_post"):
      u.kind = kChannelPost
      u.editedMessage = getMessage(x["channel_post"])
    elif x.hasKey("edited_channel_post"):
      u.kind = kEditedChannelPost
      u.editedMessage = getMessage(x["edited_channel_post"])
    elif x.hasKey("inline_query"):
      u.kind = kInlineQuery
      u.inlineQuery = getInlineQuery(x["inline_query"])
    elif x.hasKey("chosen_inline_query"):
      u.kind = kChosenInlineQuery
      #u.editedMessage = getChosenInlineResult(x["chosen_inline_query"])
    elif x.hasKey("callback_query"):
      u.kind = kCallbackQuery
      #u.editedMessage = getCallbackQuery(x["callback_query"])
    elif x.hasKey("shipping_query"):
      u.kind = kShippingQuery
      #u.editedMessage = getShippingQuery(x["shipping_query"])
    elif x.hasKey("pre_checkout_query"):
      u.kind = kPreCheckoutQuery
      #u.editedMessage = getPreCheckoutQuery(x["pre_checkout_query"])


    result.add(u)
"""

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


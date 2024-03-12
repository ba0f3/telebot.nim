import unittest, json, telebot, telebot/private/utils

suite "reaction types":
  var
    yes = newInlineKeyboardButton("Yes 🆗", callbackData = "yes")
    no = newInlineKeyboardButton("No 🚫", callbackData = "no")
    replyMarkup = newInlineKeyboardMarkup(@[yes, no])
    str = ""

  test "marshalling keyboard":
    marshal(replyMarkup, str)
    assert str == """{"inline_keyboard":[[{"text":"Yes 🆗","callback_data":"yes"},{"text":"No 🚫","callback_data":"no"}]]}"""

  test "unmarshalling emoji ❤️":
    let k = unmarshal(parseJson(str), InlineKeyboardMarkup)
    assert k.inlineKeyboard.len == 1
    assert k.inlineKeyboard[0].len == 2
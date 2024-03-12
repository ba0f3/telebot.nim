import unittest, json, telebot, telebot/private/utils

suite "reaction types":
  var
    emoji = ReactionTypeEmoji("❤️")
    customEmoji = ReactionTypeCustomEmoji("😍")
    str = ""

  test "marshalling emoji ❤️":
    marshal(emoji, str)
    assert str == """{"type":"emoji","emoji":"❤️"}"""

  test "unmarshalling emoji ❤️":
    let e = unmarshal(parseJson(str), ReactionType)
    assert e.kind == kindReactionTypeEmoji
    assert e.emoji == "❤️"

  test "marshalling custom emoji 😍":
    str = ""
    marshal(customEmoji, str)
    assert str == """{"type":"custom_emoji","custom_emoji":"😍"}"""

  test "unmarshalling custom emoji 😍":
    let e = unmarshal(parseJson(str), ReactionType)
    assert e.kind == kindReactionTypeCustomEmoji
    assert e.customEmoji == "😍"


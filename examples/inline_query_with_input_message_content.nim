import ../telebot, asyncdispatch, json, httpclient, logging, options
from strutils import strip

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

from cgi import encodeUrl
const API_KEY = slurp("secret.key").strip()

proc inlineHandler(b: Telebot, u: InlineQuery) {.async.} =
  var res: InlineQueryResultArticle
  res.kind = "article"
  res.title = "тест\""
  res.id = "1"
  res.inputMessageContent = InputTextMessageContent("test").some

  var results: seq[InlineQueryResultArticle]
  results.add(res)

  discard waitFor b.answerInlineQuery(u.id, results)

when isMainModule:
  let bot = newTeleBot(API_KEY)
  bot.onInlineQuery(inlineHandler)
  bot.poll(timeout=300, clean=true)

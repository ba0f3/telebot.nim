import telebot, asyncdispatch, json, httpclient, logging, options
var L = newConsoleLogger()
addHandler(L)

from cgi import encodeUrl
const API_KEY = slurp("secret.key")

proc queryHandler(b: TeleBot, q: InlineQuery): Future[bool] {.async, gcsafe.} =

  if q.query.len == 0:
    return true

  let url = "https://api.reddit.com/r/unixporn/search?limit=6&type=link&q=" & encodeUrl(q.query)
  var
    client = newAsyncHttpClient()
    response = await client.get(url)
    photos: seq[InlineQueryResultPhoto]
  if response.code == Http200:
    var data = parseJson(await response.body)
    for child in data["data"]["children"].items:
      if child["data"]["thumbnail"].str[0..3] != "http":
         continue
      var photo: InlineQueryResultPhoto
      photo.kind = "photo"
      photo.id = child["data"]["id"].str
      photo.photoUrl = child["data"]["url"].str
      photo.thumbnailUrl = child["data"]["thumbnail"].str
      photo.title = some($child["data"]["title"])

      photos.add(photo)
  discard await b.answerInlineQuery(q.id, photos)

when isMainModule:
  let bot = newTeleBot(API_KEY)
  bot.onInlineQuery(queryHandler)
  bot.poll(timeout=300)

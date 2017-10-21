import ../telebot, asyncdispatch, json, httpclient, logging, options
var L = newConsoleLogger()
addHandler(L)

from cgi import encodeUrl
const API_KEY = slurp("secret.key")

proc fetchResults(query: string): Future[seq[InlineQueryResultPhoto]] {.async.} =
  result = @[]
  let url = "https://api.reddit.com/r/unixporn/search?limit=6&type=link&q=" & encodeUrl(query)
  var
    client = newAsyncHttpClient()
    response = await client.get(url)
  if response.code == Http200:
    var data = parseJson(await response.body)
    for child in data["data"]["children"].items:
      if child["data"]["thumbnail"].str[0..3] != "http":
         continue
      var photo: InlineQueryResultPhoto
      photo.kind = "photo"
      photo.id = child["data"]["id"].str
      photo.photoUrl = child["data"]["url"].str
      photo.thumbUrl = child["data"]["thumbnail"].str
      photo.title = some($child["data"]["title"])
      result.add(photo)

var updates: seq[Update]
proc main() {.async.} =
  let bot = newTeleBot(API_KEY, "nim_telebot")

  while true:
    updates = await bot.getUpdates(timeout=300)
    for update in updates:
      if update.inlineQuery.isNone:
        continue
      var
        query = update.inlineQuery.get
        results = await fetchResults(query.query)
      discard await bot.answerInlineQuery(query.id, results)
asyncCheck main()
runForever()

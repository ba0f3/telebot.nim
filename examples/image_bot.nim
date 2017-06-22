import ../telebot, asyncdispatch, json, httpclient, logging

var L = newConsoleLogger()
addHandler(L)

from cgi import encodeUrl
const API_KEY = slurp("secret.key")

proc fetchResults(query: string): Future[seq[InlineQueryResultPhoto]] {.async.} =
  result = @[]
  let url = "https://api.reddit.com/r/EarthPorn/search?limit=6&type=link&q=" & encodeUrl(query)
  var
    client = newAsyncHttpClient()
    response = await client.get(url)
  if response.code == Http200:
    var data = parseJson(await response.body)
    for child in data["data"]["children"].items:
      echo child["data"]
      if $child["data"]["thumbnail"] == "self":
         continue
      var photo: InlineQueryResultPhoto
      photo.kind = "photo"
      photo.id = $child["data"]["id"]
      photo.photoUrl = $child["data"]["url"]
      photo.thumbUrl = $child["data"]["thumbnail"]
      photo.title = $child["data"]["title"]
      result.add(photo)

var updates: seq[Update]
proc main() {.async.} =
  let bot = newTeleBot(API_KEY)
  while true:
    updates = await bot.getUpdates(timeout=300)
    for update in updates:
      if update.inlineQuery.isNil:
        continue
      var
        query = unwrap(update.inlineQuery)
        results = await fetchResults(query.query)
      echo query
      discard await bot.answerInlineQuery(query.id, results)
asyncCheck main()
runForever()

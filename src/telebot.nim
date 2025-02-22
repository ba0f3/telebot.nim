## Telebot is a Nim library for creating Telegram Bot applications.
##
## This module provides the main interface for creating and managing Telegram bots.
## It implements the Telegram Bot API and provides a simple, intuitive way
## to create bots in Nim.
##
## Basic Usage
## ===========
##
## .. code-block:: nim
##   import telebot
##
##   let bot = newTeleBot("YOUR_BOT_TOKEN")
##
##   bot.onCommand("start") do (cmd: Command):
##     try:
##       let resp = await bot.sendMessage(cmd.message.chat.id, "Hello! I'm your bot!")
##       echo "Message sent: ", resp.messageId
##     except IOError as e:
##       echo "Failed to send message: ", e.msg
##
##   bot.poll()
##
## The library supports all major Telegram Bot API features including:
## * Command handling
## * Message updates
## * Inline keyboards
## * Media sending
## * Webhooks
##
import tables, httpclient

import telebot/private/[types, keyboard, webhook, inputmedia, helpers, api, events]
export types, webhook, keyboard, inputmedia, helpers, api, events

proc setProxy*(b: TeleBot, url: string, auth = "") {.inline.} =
  ## Configures a proxy for the bot's HTTP client with type-safe authentication.
  ##
  ## Use this procedure to set up a proxy if your bot needs to connect through one.
  ##
  ## Parameters:
  ##   - `b`: The TeleBot instance to configure
  ##   - `url`: The proxy URL (e.g. "http://proxy.example.com:8080")
  ##   - `auth`: Optional authentication credentials (username/password)
  ##
  ## See also:
  ##   - `newTeleBot <#newTeleBot,string,string>`_ for creating bot instances
  ##   - `TeleBot <#TeleBot>`_ type documentation
  ##
  ## Example:
  ## ```nim
  ## let bot = newTeleBot("TOKEN")
  ## bot.setProxy("http://proxy.example.com:8080")
  ## ```
  b.proxy = newProxy(url, auth)

proc newTeleBot*(token: string, serverUrl="https://api.telegram.org"): TeleBot =
  ## Creates a new Telegram Bot instance.
  ##
  ## This is the main constructor for creating a new bot instance. It initializes
  ## all necessary internal structures and prepares the bot for operation.
  ##
  ## Parameters:
  ## * `token`: The bot token obtained from BotFather
  ## * `serverUrl`: Optional custom Telegram API server URL. The default value should work
  ##   for most use cases. Only change this if you're using a custom Telegram API server.
  ##
  ## Returns:
  ## * A new `TeleBot` instance configured with the provided parameters
  ##
  ## Example:
  ## ```nim
  ## # Create a new bot with default settings
  ## let bot = newTeleBot("123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11")
  ##
  ## # Create a bot with a custom API server
  ## let customBot = newTeleBot("YOUR_TOKEN", "https://custom.telegram.server")
  ## ```
  new(result)
  result.token = token
  result.serverUrl = serverUrl
  result.commandCallbacks = newTable[string, seq[CommandCallback]]()

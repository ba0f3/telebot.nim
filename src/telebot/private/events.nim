import tables
from types import TeleBot, UpdateCallback, CommandCallback, CatchallCommandCallback, InlineQueryCallback

proc onUpdate*(b: TeleBot, cb: UpdateCallback) =
  ## Registers a callback to handle general updates.
  ##
  ## This procedure allows you to register a callback function that will be
  ## invoked whenever a new update is received from the Telegram Bot API.
  ##
  ## Parameters:
  ##   - `b`: The TeleBot instance to register the callback for.
  ##   - `cb`: The callback function to be registered.
  ##         It should be a `proc` that takes a `TeleBot` and an `Update` as parameters.
  ##
  ## Example:
  ## ```nim
  ## bot.onUpdate proc (bot: TeleBot, update: Update): Future[bool] =
  ##   echo "Received update: ", update
  ##   return false # Continue processing other callbacks
  ## ```
  b.updateCallbacks.add(cb)

proc onCommand*(b: TeleBot, command: string, cb: CommandCallback) =
  ## Registers a callback to handle specific commands.
  ##
  ## This procedure allows you to register a callback function that will be
  ## invoked when a message with the specified command is received.
  ##
  ## Parameters:
  ##   - `b`: The TeleBot instance to register the callback for.
  ##   - `command`: The command string to handle (e.g., "start", "help").
  ##                 Commands should be registered without the leading slash.
  ##   - `cb`: The callback function to be registered.
  ##         It should be a `proc` that takes a `TeleBot` and a `Command` object as parameters.
  ##
  ## Example:
  ## ```nim
  ## bot.onCommand("start") proc (bot: TeleBot, cmd: Command): Future[bool] =
  ##   echo "Received /start command from user: ", cmd.message.from.username
  ##   return false # Continue processing other callbacks
  ## ```
  if not b.commandCallbacks.hasKey(command):
    b.commandCallbacks[command] = @[]
  b.commandCallbacks[command].add(cb)

proc onUnknownCommand*(b: TeleBot, cb: CatchallCommandCallback) =
  ## Registers a callback to handle unknown commands.
  ##
  ## This procedure allows you to register a callback function that will be
  ## invoked when a message with an unknown command (not registered with `onCommand`)
  ## is received. Only one catch-all command callback can be registered.
  ##
  ## Parameters:
  ##   - `b`: The TeleBot instance to register the callback for.
  ##   - `cb`: The callback function to be registered.
  ##         It should be a `proc` that takes a `TeleBot` and a `Command` object as parameters.
  ##
  ## Example:
  ## ```nim
  ## bot.onUnknownCommand proc (bot: TeleBot, cmd: Command): Future[bool] =
  ##   echo "Received unknown command: ", cmd.command, " from user: ", cmd.message.from.username
  ##   return false # Continue processing other callbacks
  ## ```
  b.catchallCommandCallback = cb

proc onInlineQuery*(b: TeleBot, cb: InlineQueryCallback) =
  ## Registers a callback to handle inline queries.
  ##
  ## This procedure allows you to register a callback function that will be
  ## invoked when an inline query is received.
  ##
  ## Parameters:
  ##   - `b`: The TeleBot instance to register the callback for.
  ##   - `cb`: The callback function to be registered.
  ##         It should be a `proc` that takes a `TeleBot` and an `InlineQuery` object as parameters.
  ##
  ## Example:
  ## ```nim
  ## bot.onInlineQuery proc (bot: TeleBot, query: InlineQuery): Future[bool] =
  ##   echo "Received inline query: ", query.query, " from user: ", query.from.username
  ##   return false # Continue processing other callbacks
  ## ```
  b.inlineQueryCallbacks.add(cb)

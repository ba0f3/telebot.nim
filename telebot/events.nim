proc onUpdate*(b: TeleBot, cb: UpdateCallback) =
  b.updateCallbacks.add(cb)

proc onCommand*(b: TeleBot, command: string, cb: CommandCallback) =
  if not b.commandCallbacks.hasKey(command):
    b.commandCallbacks[command] = @[]
  b.commandCallbacks[command].add(cb)

proc onUnknownCommand*(b: TeleBot, cb: CatchallCommandCallback) =
  b.catchallCommandCallback = cb

proc onInlineQuery*(b: TeleBot, cb: InlineQueryCallback) =
  b.inlineQueryCallbacks.add(cb)
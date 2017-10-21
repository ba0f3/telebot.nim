import asyncevents

proc onUpdate*(b: TeleBot, p: EventProc[Update]) =
  b.updateEmitter.on("update", p)

proc onCommand*(b: TeleBot, command: string, p: EventProc[Command]) =
  b.commandEmitter.on(command, p)

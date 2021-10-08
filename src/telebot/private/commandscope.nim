import types

proc newBotCommandScopeDefault*(): BotCommandScope =
  result = BotCommandScope(kind: "default")

proc newBotCommandScopeAllPrivateChats*(): BotCommandScope =
  result = BotCommandScope(kind: "all_private_chats")

proc newBotCommandScopeAllGroupChats*(): BotCommandScope =
  result = BotCommandScope(kind: "all_group_chats")

proc newBotCommandScopeAllChatAdministrators*(): BotCommandScope =
  result = BotCommandScope(kind: "all_chat_administrators")

proc newBotCommandScopeChat*(chatId: ChatId): BotCommandScopeChat =
  result = BotCommandScopeChat(kind: "chat", chatId: ChatId)

proc newBotCommandScopeChatAdministrator*(chatId: ChatId): BotCommandScopeChat =
  result = BotCommandScopeChat(kind: "chat_administrators", chatId: ChatId)

proc newBotCommandScopeChatMember*(chatId: ChatId, userId: int): BotCommandScopeChatMember =
  result = BotCommandScopeChatMember(kind: "chat_member", chatId: ChatId, userId: userId)

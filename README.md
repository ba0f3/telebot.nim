# Telebot.nim

A powerful, asynchronous Telegram Bot API client implemented in Nim. Create feature-rich Telegram bots with ease using this modern, efficient library.

## Features

- ✨ **Full Telegram Bot API Support**: Implements the complete Telegram Bot API, covering all methods and types for creating versatile bots.
- 🚀 **Asynchronous Design**: Built with Nim's `async/await` for non-blocking operations, ensuring high performance and responsiveness for handling multiple bot interactions concurrently.
- 💪 **Type-Safe API**: Leverages Nim's strong typing system to provide a robust and predictable API, reducing runtime errors and improving code maintainability.
- 🛠️ **Rich Set of Utilities**: Includes a variety of utility functions and helpers for common bot development tasks, such as keyboard markup generation, input file handling, and more.
- 📦 **Easy Integration**: Designed for straightforward integration into existing Nim projects, with clear and concise API.
- 🔒 **Secure by Default**: Encourages secure bot development practices, with features like proxy support and recommendations for secure API token handling.

## Prerequisites

- Nim 1.6.2 or higher
- A Telegram Bot API token (Get it from [@BotFather](https://t.me/botfather))

## Installation

Install using Nimble:

```bash
nimble install telebot
```

## Quick Start

1. Create a new bot with [@BotFather](https://t.me/botfather)
2. Save your API token in a secure location
3. Create your first bot:

### Echo Bot Example

This example demonstrates a basic echo bot that replies to text messages and greets users when they send the `/start` command.

```nim
import telebot, asyncdispatch, logging, options, strutils

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

# Remember to strip your secret key to avoid HTTP errors
const API_KEY = strip(slurp("secret.key"))

proc updateHandler(bot: TeleBot, update: Update): Future[bool] {.async.} =
  if not update.message.isNil:
    let response = update.message
    if response.text.len > 0:
      let text = response.text
      echo "Received message: " & text & " from: " & response.chat.id.string
      discard await bot.sendMessage(response.chat.id, "Echo: " & text, parseMode = "markdown", disableNotification = true, replyParameters = ReplyParameters(messageId: response.messageId))
  return true

proc startCommandHandler(bot: TeleBot, command: Command): Future[bool] {.async.} =
  if not command.message.fromUser.isNil:
    let userName = command.message.fromUser.firstName
    discard await bot.sendMessage(command.message.chat.id, "Hello " & userName & "! Welcome to the Echo Bot.\\n\\nSend me any text and I will echo it back to you.", parseMode = "markdown", disableNotification = true, replyParameters = ReplyParameters(messageId: command.message.messageId))
  return true

when isMainModule:
  when defined(local):
    let bot = newTeleBot(API_KEY, "http://127.0.0.1:8081") # For local API server testing
  else:
    let bot = newTeleBot(API_KEY)

  bot.setLogLevel(levelDebug) # Enable debug logging for development

  bot.onUpdate(updateHandler)
  bot.onCommand("start", startCommandHandler) # Register /start command handler

  echo "Bot started. Polling for updates..."
  bot.poll(timeout = 300)
```

## Advanced Usage

### Sending Photos

```nim
import telebot, asyncdispatch

const API_KEY = "YOUR_BOT_API_TOKEN" # Replace with your actual API key

proc photoHandler(bot: TeleBot, command: Command): Future[bool] {.async.} =
  discard await bot.sendPhoto(command.message.chat.id, "https://www.telegram-bot-api.com/logo.png", caption = "Telegram Bot API Logo")
  return true

let bot = newTeleBot(API_KEY)
bot.onCommand("photo", photoHandler)
bot.poll()
```

### Inline Keyboard

```nim
import telebot, asyncdispatch

const API_KEY = "YOUR_BOT_API_TOKEN" # Replace with your actual API key

proc inlineKeyboardHandler(bot: TeleBot, command: Command): Future[bool] {.async.} =
  let inlineKeyboard = newInlineKeyboardMarkup(
    inlineKeyboardRows(
      inlineKeyboardButtonRow(newInlineKeyboardButtonUrl("Go to Google", "https://google.com"))
    ))
  discard await bot.sendMessage(command.message.chat.id, "Click the button below:", replyMarkup = inlineKeyboard)
  return true

let bot = newTeleBot(API_KEY)
bot.onCommand("keyboard", inlineKeyboardHandler)
bot.poll()
```

### Handling Callback Queries

```nim
import telebot, asyncdispatch

const API_KEY = "YOUR_BOT_API_TOKEN" # Replace with your actual API key

proc callbackQueryHandler(bot: TeleBot, callbackQuery: CallbackQuery): Future[bool] {.async.} =
  discard await bot.answerCallbackQuery(callbackQuery.id, text = "Button clicked!")
  discard await bot.sendMessage(callbackQuery.message.chat.id, "Callback query data: " & callbackQuery.data)
  return true

proc inlineKeyboardCallbackHandler(bot: TeleBot, command: Command): Future[bool] {.async.} =
  let inlineKeyboard = newInlineKeyboardMarkup(
    inlineKeyboardRows(
      inlineKeyboardButtonRow(newInlineKeyboardButtonCallbackData("Click me", "button_clicked"))
    ))
  discard await bot.sendMessage(command.message.chat.id, "Click the button below:", replyMarkup = inlineKeyboard)
  bot.onCallbackQuery(callbackQueryHandler) # Register callback query handler
  return true

let bot = newTeleBot(API_KEY)
bot.onCommand("callback", inlineKeyboardCallbackHandler)
bot.poll()
```


### Configuration Options

- **Timeouts**: Customize request timeouts using the `timeout` parameter
- **Proxy Support**: Configure proxy settings for bot connections
- **Parse Mode**: Set default parse mode for messages
- **API Server**: Use custom API server if needed

```nim
let bot = newTeleBot(API_KEY,
timeout = 500,  # timeout in seconds
proxy = "http://proxy.example.com:8080",
parseMode = "markdown"
)
```

### Webhook Setup

For production environments, webhooks are recommended over polling:

```nim
# Configure webhook
await bot.setWebhook(
url = "https://your-domain.com/webhook",
certificate = "path/to/cert.pem"  # Optional
)

# Start webhook server
bot.startWebhook(
host = "0.0.0.0",
port = 8443,
certificate = "path/to/cert.pem",
privateKey = "path/to/private.key"
)
```

### Error Handling

Implement robust error handling in your bots:

```nim
try:
discard await bot.sendMessage(chatId, "Hello!")
except TelegramError as e:
error "Failed to send message: ", e.message
except Exception as e:
error "Unexpected error: ", e.msg
```

### Best Practices

1. **Security**:
- Store API tokens securely
- Validate all user input
- Use HTTPS for webhooks

2. **Performance**:
- Implement rate limiting
- Use webhook mode for production
- Handle updates asynchronously

3. **Reliability**:
- Implement proper error handling
- Add logging for debugging
- Use persistent storage for important data

## Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting your:

- Bug reports 🐛
- Feature requests ✨
- Pull requests 🚀
- Documentation improvements 📝

## Version History

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and migration guides.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Resources

- [Telegram Bot API Documentation](https://core.telegram.org/bots/api)
- [Nim Documentation](https://nim-lang.org/docs/manual.html)
- [Project Wiki](../../wiki)

## Support

- Report bugs on [GitHub Issues](../../issues)
- Star ⭐ the project to show your support!

## Credits

- Documentation was improved with the help of Cline bot, powered by OpenRouter's Google: Gemini 2.0 Flash Thinking Experimental 01-21 (free).

## Breaking Changes

> **Note**: From version 1.0.0, procs like `newMessage`, `newPhoto`, etc. are deprecated. Use `sendMessage`, `sendDocument` instead.
> For backward compatibility, import `telebot/compat`.

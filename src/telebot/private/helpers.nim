import types

# -------------
# InputMessageContent
# -------------
func InputTextMessageContent*(messageText: string): InputMessageContent =
  new(result)
  result.kind = TextMessage
  result.messageText = messageText

func InputLocationMessageContent*(latitude, longitude: float): InputMessageContent =
  new(result)
  result.kind = LocationMessage
  result.latitude = latitude
  result.longitude = longitude

func InputVenueMessageContent*(latitude, longitude: float, title, address: string): InputMessageContent =
  new(result)
  result.kind = VenueMessage
  result.latitude = latitude
  result.longitude = longitude
  result.venueTitle = title
  result.venueAddress = address

func InputContactMessageContent*(phoneNumber, firstName: string): InputMessageContent =
  new(result)
  result.kind = ContactMessage
  result.phoneNumber = phoneNumber
  result.firstName = firstName

func InputInvoiceMessageContent*(title, description, payload, providerToken, currrency: string, prices: seq[LabeledPrice]): InputMessageContent =
  new(result)
  result.kind = InvoiceMessage
  result.title = title
  result.description = description
  result.payload = payload
  result.providerToken = providerToken
  result.currrency = currrency
  result.prices = prices

# -------------
# ReactionType
# -------------
func ReactionTypeEmoji*(emoji: string): ReactionType =
  new(result)
  result.kind = kindReactionTypeEmoji
  result.emoji = emoji

func ReactionTypeCustomEmoji*(emoji: string): ReactionType =
  new(result)
  result.kind = kindReactionTypeCustomEmoji
  result.customEmoji = emoji

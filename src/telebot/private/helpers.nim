import types

# -------------
# InputMessageContent
# -------------
func InputTextMessageContent*(messageText: string): InputMessageContent =
  ## Creates an InputMessageContent of TextMessage kind.
  ##
  ## Helper function to create InputMessageContent for sending text messages
  ## in inline queries.
  ##
  ## Parameters:
  ##   - `messageText`: The text content of the message.
  ##
  ## Returns:
  ##   - `InputMessageContent`: An InputMessageContent object of TextMessage kind.
  new(result)
  result.kind = TextMessage
  result.messageText = messageText

func InputLocationMessageContent*(latitude, longitude: float): InputMessageContent =
  ## Creates an InputMessageContent of LocationMessage kind.
  ##
  ## Helper function to create InputMessageContent for sending location messages
  ## in inline queries.
  ##
  ## Parameters:
  ##   - `latitude`: Latitude of the location.
  ##   - `longitude`: Longitude of the location.
  ##
  ## Returns:
  ##   - `InputMessageContent`: An InputMessageContent object of LocationMessage kind.
  new(result)
  result.kind = LocationMessage
  result.latitude = latitude
  result.longitude = longitude

func InputVenueMessageContent*(latitude, longitude: float, title, address: string): InputMessageContent =
  ## Creates an InputMessageContent of VenueMessage kind.
  ##
  ## Helper function to create InputMessageContent for sending venue messages
  ## in inline queries.
  ##
  ## Parameters:
  ##   - `latitude`: Latitude of the venue.
  ##   - `longitude`: Longitude of the venue.
  ##   - `title`: Title of the venue.
  ##   - `address`: Address of the venue.
  ##
  ## Returns:
  ##   - `InputMessageContent`: An InputMessageContent object of VenueMessage kind.
  new(result)
  result.kind = VenueMessage
  result.latitude = latitude
  result.longitude = longitude
  result.venueTitle = title
  result.venueAddress = address

func InputContactMessageContent*(phoneNumber, firstName: string): InputMessageContent =
  ## Creates an InputMessageContent of ContactMessage kind.
  ##
  ## Helper function to create InputMessageContent for sending contact messages
  ## in inline queries.
  ##
  ## Parameters:
  ##   - `phoneNumber`: Phone number of the contact.
  ##   - `firstName`: First name of the contact.
  ##
  ## Returns:
  ##   - `InputMessageContent`: An InputMessageContent object of ContactMessage kind.
  new(result)
  result.kind = ContactMessage
  result.phoneNumber = phoneNumber
  result.firstName = firstName

func InputInvoiceMessageContent*(title, description, payload, providerToken, currency: string, prices: seq[LabeledPrice]): InputMessageContent =
  ## Creates an InputMessageContent of InvoiceMessage kind.
  ##
  ## Helper function to create InputMessageContent for sending invoice messages
  ## in inline queries.
  ##
  ## Parameters:
  ##   - `title`: Title of the invoice.
  ##   - `description`: Description of the invoice.
  ##   - `payload`: Payload of the invoice.
  ##   - `providerToken`: Provider token for the invoice.
  ##   - `currency`: Currency code for the invoice.
  ##   - `prices`: List of LabeledPrice objects representing the prices.
  ##
  ## Returns:
  ##   - `InputMessageContent`: An InputMessageContent object of InvoiceMessage kind.
  new(result)
  result.kind = InvoiceMessage
  result.title = title
  result.description = description
  result.payload = payload
  result.providerToken = providerToken
  result.currency = currency
  result.prices = prices

# -------------
# ReactionType
# -------------
func ReactionTypeEmoji*(emoji: string): ReactionType =
  ## Creates a ReactionType of Emoji kind.
  ##
  ## Helper function to create ReactionType for message reactions using Emoji.
  ##
  ## Parameters:
  ##   - `emoji`: The emoji string for the reaction.
  ##
  ## Returns:
  ##   - `ReactionType`: A ReactionType object of Emoji kind.
  new(result)
  result.kind = kindReactionTypeEmoji
  result.emoji = emoji

func ReactionTypeCustomEmoji*(emoji: string): ReactionType =
  ## Creates a ReactionType of CustomEmoji kind.
  ##
  ## Helper function to create ReactionType for message reactions using Custom Emoji.
  ##
  ## Parameters:
  ##   - `emoji`: The custom emoji ID string for the reaction.
  ##
  ## Returns:
  ##   - `ReactionType`: A ReactionType object of CustomEmoji kind.
  new(result)
  result.kind = kindReactionTypeCustomEmoji
  result.customEmoji = emoji

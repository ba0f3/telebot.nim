import types, options

# -------------
# InputMessageContent
# -------------
func InputTextMessageContent*(messageText: string): InputMessageContent =
  new(result)
  result.`type` = TextMessage
  result.messageText = messageText

func InputLocationMessageContent*(latitude, longitude: float): InputMessageContent =
  new(result)
  result.`type` = LocationMessage
  result.latitude = latitude
  result.longitude = longitude

func InputVenueMessageContent*(latitude, longitude: float, title, address: string): InputMessageContent =
  new(result)
  result.`type` = VenueMessage
  result.latitude = latitude
  result.longitude = longitude
  result.venueTitle = title
  result.venueAddress = address

func InputContactMessageContent*(phoneNumber, firstName: string): InputMessageContent =
  new(result)
  result.`type` = ContactMessage
  result.phoneNumber = phoneNumber
  result.firstName = firstName

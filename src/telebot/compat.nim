import httpclient, asyncdispatch, strutils
import private/[types, keyboard, utils]

magic Message:
  chatId: int64
  text: string
  parseMode: string {.optional.}
  disableWebPagePreview: bool {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Photo:
  chatId: int64
  photo: string
  caption: string {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Audio:
  chatId: int64
  audio: string
  caption: string {.optional.}
  duration: int {.optional.}
  performer: string {.optional.}
  title: string {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Document:
  chatId: int64
  document: string
  caption: string {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Sticker:
  chatId: int64
  sticker: string
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Video:
  chatId: int64
  video: string
  duration: int {.optional.}
  width: int {.optional.}
  height: int {.optional.}
  caption: string {.optional.}
  supportsStreaming: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Voice:
  chatId: int64
  voice: string
  caption: string {.optional.}
  duration: int {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic VideoNote:
  chatId: int64
  videoNote: string
  duration: int {.optional.}
  length: int {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Location:
  chatId: int64
  latitude: float
  longitude: float
  livePeriod: int {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Venue:
  chatId: int64
  latitude: int
  longitude: int
  title: string
  address: string
  foursquareId: string {.optional.}
  foursquareType: string {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Contact:
  chatId: int64
  phoneNumber: string
  firstName: string
  lastName: string {.optional.}
  vcard: string {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Invoice:
  chatId: int64
  title: string
  description: string
  payload: string
  providerToken: string
  startParameter: string
  currency: string
  prices: seq[LabeledPrice]
  providerData: string {.optional.}
  photoUrl: string {.optional.}
  photoSize: int {.optional.}
  photoWidth: int {.optional.}
  photoHeight: int {.optional.}
  needName: bool {.optional.}
  needPhoneNumber: bool {.optional.}
  needEmail: bool {.optional.}
  needShippingAddress: bool {.optional.}
  sendPhoneNumberToProvider: bool {.optional.}
  sendEmailToProvider: bool {.optional.}
  isFlexible: bool {.optional.}
  disableNotification: bool {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Animation:
  chatId: int64
  animation: string
  duration: int {.optional.}
  width: int {.optional.}
  height: int {.optional.}
  thumb: string {.optional.}
  caption: string {.optional.}
  parseMode: string {.optional.}
  disableNotification: string {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Poll:
  chatId: int64
  question: string
  options: seq[string]
  isAnonymous: bool {.optional.}
  kind: string {.optional.}
  allowsMultipleAnswers: bool {.optional.}
  correctOptionId: int {.optional.}
  isClosed: bool {.optional.}
  disableNotification: string {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}

magic Dice:
  chatId: int64
  disableNotification: string {.optional.}
  replyToMessageId: int {.optional.}
  replyMarkup: KeyboardMarkup {.optional.}
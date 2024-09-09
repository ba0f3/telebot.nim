import
  std/jsffi,
  std/strutils,
  std/macros

type
  WebAppEvents* = enum
    THEME_CHANGED = "themeChanged"
    VIEWPORT_CHANGED = "viewportChanged"
    MAIN_BUTTON_CLICKED = "mainButtonClicked"
    SECONDARY_BUTTON_CLICKED = "secondaryButtonClicked"
    BACK_BUTTON_CLICKED = "backButtonClicked"
    SETTINGS_BUTTON_CLICKED = "settingsButtonClicked"
    INVOICE_CLOSE = "invoiceClosed"
    POPUP_CLOSED = "popupClosed"
    QR_TEXT_RECEIVED = "qrTextReceived"
    SCAN_QR_POPUP_CLOSED = "scanQrPopupClosed"
    CLIPBOARD_TEXT_RECEIVED = "clipboardTextReceived"
    WRITE_ACCESS_REQUESTED = "writeAccessRequested"
    CONTACT_REQUESTED = "contactRequested"
    BIOMETRIC_MANAGER_UPDATED = "biometricManagerUpdated"
    BIOMETRIC_AUTH_REQUESTED = "biometricAuthRequested"
    BIOMETRIC_TOKEN_UPDATED = "biometricTokenUpdated"

  WebAppInitData* = object
    query_id*: cstring
    user*: WebAppUser
    receiver*: WebAppUser
    chat*: WebAppChat
    start_param: cstring
    can_send_after*: cint
    auth_date*: cint
    hash*: cstring

  WebAppUser* {.importc, nodecl.} = object
    id*: cint
    is_bot*: bool
    first_name*: cstring
    last_name*: cstring
    username*: cstring
    language_code*: cstring
    isPremium*: bool
    addedToAttachmentMenu*: bool
    allowsWriteToPm*: bool
    photo_url*: cstring

  WebAppChat* {.importc, nodecl.} = object
    id*: cint
    `type`*: cstring
    title*: cstring
    username*: cstring
    photo_url*: cstring


  BackButton* {.importc, nodecl.} = object
    isVisible*: bool

  BottomButton* {.importc, nodecl.} = object
    text*: cstring
    color*: cstring
    textColor*: cstring
    isVisible*: bool
    isActive*: bool
    isProgressVisible*: bool

  SettingsButton* {.importc, nodecl.} = object
    isVisible*: bool

  HapticFeedback* {.importc, nodecl.} = object

  CloudStorage* {.importc, nodecl.} = object

  BiometricManager* {.importc, nodecl.} = object
    isInited*: bool
    isBiometricAvailable*: bool
    biometricType*: cstring
    isAccessRequested*: bool
    isAccessGranted*: bool
    isBiometricTokenSaved*: bool
    deviceId*: cstring

  BiometricRequestAccessParams* {.importc, nodecl.} = object
    reason*: cstring

  BiometricAuthenticateParams* {.importc, nodecl.} = object
    reason*: cstring

  ThemeParams* {.importc, nodecl.} = object
    bg_color*: cstring
    text_color*: cstring
    hint_color*: cstring
    link_color*: cstring
    button_color*: cstring
    button_text_color*: cstring
    secondary_bg_color*: cstring
    header_bg_color*: cstring
    bottom_bar_bg_color*: cstring
    accent_text_color*: cstring
    section_bg_color*: cstring
    section_header_text_color*: cstring
    section_separator_color*: cstring
    subtitle_text_color*: cstring
    destructive_text_color*: cstring

  StoryShareParams* {.importc, nodecl.} = object
    text*: cstring
    widgetLink*: StoryWidgetLink

  StoryWidgetLink* {.importc, nodecl.} = object
    url*: cstring
    name*: cstring

  ScanQrPopupParams* {.importc, nodecl.} = object
    text*: cstring

  PopupButton* {.importc, nodecl.} = object
    id*: cstring
    `type`*: cstring
    text*: cstring

  PopupParams* {.importc, nodecl.} = object
    title*: cstring
    message*: cstring
    buttons*: seq[PopupButton]

  ScanQrPopupParams* {.importc, nodecl.} = object
    text*: cstring

  WebApp* = ref WebAppObj
  WebAppObj* {.importc, nodecl.} = object of RootObj
    initData*: cstring
    initDataUnsafe*: WebAppInitData
    version*: cstring
    platform*: cstring
    colorScheme*: cstring
    themeParams*: ThemeParams
    isExpanded*: bool
    viewportHeight*: cfloat
    viewportStableHeight*: cfloat
    headerColor*: cstring
    backgroundColor*: cstring
    bottomBarColor*: cstring
    isClosingConfirmationEnabled*: bool
    isVerticalSwipesEnabled*: bool
    BackButton*: BackButton
    BottomButton*: BottomButton
    SecondaryButton*: BottomButton
    SettingsButton*: SettingsButton
    HapticFeedback*: HapticFeedback
    CloudStorage*: CloudStorage
    BiometricManager*: BiometricManager


  TelegramObj* {.importc, nodecl.} = object of RootObj
    WebApp*: WebApp

  TelegramRef* = ref TelegramObj

  # Events
  InvoiceClosedEvent* {.importc, nodecl.} = object of RootObj
    url*: cstring
    status*: cstring
  ViewportChangedEvent* {.importc, nodecl.} = object of RootObj
    isStateStable*: bool
  PopupClosedEvent* {.importc, nodecl.} = object of RootObj
    button_id*: cint
  QrTextReceivedEvent* {.importc, nodecl.} = object of RootObj
    data*: cstring
  ClipboardTextReceivedEvent* {.importc, nodecl.} = object of RootObj
    data*: cstring
  WriteAccessRequestedEvent* {.importc, nodecl.} = object of RootObj
    status*: cstring
  ContactRequestedEvent* {.importc, nodecl.} = object of RootObj
    status*: cstring
  BiometricAuthRequestedEvent* {.importc, nodecl.} = object of RootObj
    isAuthenticated*: bool
  BiometricTokenUpdatedEvent* {.importc, nodecl.} = object of RootObj
    isUpdated*: bool

  EmptyEventHandler* = proc()
  InvoiceClosedEventHandler* = proc(event: InvoiceClosedEvent)
  ViewportChangedEventHandler* = proc(event: ViewportChangedEvent)
  PopupClosedEventHandler* = proc(event: PopupClosedEvent)
  QrTextReceivedEventHandler* = proc(event: QrTextReceivedEvent)
  ClipboardTextReceivedEventHandler* = proc(event: ClipboardTextReceivedEvent)
  WriteAccessRequestedEventHandler* = proc(event: WriteAccessRequestedEvent)
  ContactRequestedEventHandler* = proc(event: ContactRequestedEvent)
  BiometricAuthRequestedEventHandler* = proc(event: BiometricAuthRequestedEvent)
  BiometricTokenUpdatedEventHandler* = proc(event: BiometricTokenUpdatedEvent)
  CloudStorageHandler* = proc()

var Telegram* {.importc, nodecl.}: TelegramRef

macro checkFor(items, obj, key: untyped): untyped =
  newStmtList(
    # {.emit: "if (`obj`.key)".}
    newNimNode(nnkPragma).add(
      newNimNode(nnkExprColonExpr).add(
        ident"emit",
        newLit("if (`" & $obj & "`." & $key & ")")
      )
    ),
    # items.add "key: " & $obj.key
    newCall("add", items, newCall("&", newLit($key & ": "), newCall("$", newDotExpr(obj, key))))
  )

proc `$`*(data: WebAppInitData): string =
  # Some fields are sometimes missing
  result = "WebAppInitData("
  var items: seq[string] = @[]
  checkFor(items, data, query_id)
  checkFor(items, data, user)
  checkFor(items, data, receiver)
  checkFor(items, data, chat)
  checkFor(items, data, start_param)
  checkFor(items, data, can_send_after)
  checkFor(items, data, auth_date)
  checkFor(items, data, hash)
  result &= join(items, ", ")
  result &= ")"

#--------
# WebApp
#--------
proc isVersionAtLeast*(w: WebApp, version: cstring): bool {.importjs: "#.isVersionAtLeast(#)", nodecl.}
proc setHeaderColor*(w: WebApp, color: cstring) {.importjs: "#.setHeaderColor(#)", nodecl.}
proc setBackgroundColor*(w: WebApp, color: cstring) {.importjs: "#.setBackgrounColor(#)", nodecl.}
proc setBottomBarColor*(w: WebApp, color: cstring) {.importjs: "#.setBottomBarColor(#)", nodecl.}
proc enableClosingConfirmation*(w: WebApp) {.importjs: "#.enableClosingConfirmation()", nodecl.}
proc disableClosingConfirmation*(w: WebApp) {.importjs: "#.disableClosingConfirmation()", nodecl.}
proc enableVerticalSwipes*(w: WebApp) {.importjs: "#.enableVerticalSwipes()", nodecl.}
proc disableVerticalSwipes*(w: WebApp) {.importjs: "#.disableVerticalSwipes()", nodecl.}
proc onEvent*(w: WebApp, eventType: cstring, eventHandler: EmptyEventHandler) {.importjs: "#.onEvent(#, #)", nodecl.}
proc offEvent*(w: WebApp, eventType: cstring, eventHandler: EmptyEventHandler) {.importjs: "#.offEvent(#, #)", nodecl.}
proc sendData*(w: WebApp, data: cstring) {.importjs: "#.sendData(#)", nodecl.}
proc openLink*(w: WebApp, url: cstring, options: JsObject) {.importjs: "#.openLink(#, #)", nodecl.}
proc openTelegramLink*(w: WebApp, url: cstring) {.importjs: "#.openTelegramLink(#)", nodecl.}
proc openInvoice*(w: WebApp, url: cstring, callback: InvoiceClosedEventHandler = nil) {.importjs: "#.openInvoice(#, #)", nodecl.}
proc shareToStory*(w: WebApp, mediaUrl: cstring, params: StoryShareParams = nil) {.importjs: "#.shareToStory(#, #)", nodecl.}
proc showPopup*(w: WebApp, params: PopupParams, callback: EmptyEventHandler = nil) {.importjs: "#.showPopup(#, #)", nodecl.}
proc showAlert*(w: WebApp, message: string, callback: EmptyEventHandler = nil) {.importjs: "#.showAlert(#, #)", nodecl.}
proc showScanQrPopup*(w: WebApp, params: ScanQrPopupParams, callback: QrTextReceivedEventHandler) {.importjs: "#.showScanQrPopup(#, #)", nodecl.}
proc closeScanQrPopup*(w: WebApp) {.importjs: "#.closeScanQrPopup()", nodecl.}
proc readTextFromClipboard*(w: WebApp, callbback: ClipboardTextReceivedEventHandler) {.importjs: "#.readTextFromClipboard(#)", nodecl.}
proc requestWriteAccess*(w: WebApp, callback: WriteAccessRequestedEventHandler) {.importjs: "#.requestWriteAccess(#)", nodecl.}
proc requestContact*(w: WebApp, callback: ContactRequestedEventHandler) {.importjs: "#.requestContact(#)", nodecl.}
proc showConfirm*(w: WebApp, message: cstring, callback: EmptyEventHandler = nil) {.importjs: "#.showConfirm(#, #)", nodecl.}
proc ready*(w: WebApp): bool {.importjs: "#.ready()", nodecl.}
proc expand*(w: WebApp) {.importjs: "#.expand()", nodecl.}
proc close*(w: WebApp) {.importjs: "#.close()", nodecl.}

#--------
# BackButtton
#--------
proc onClick*(b: BackButton, callback: EmptyEventHandler): BackButton {.importjs: "#.onClick(#)", nodecl, discardable.}
proc offClick*(b: BackButton, callback: EmptyEventHandler): BackButton {.importjs: "#.offClick(#)", nodecl, discardable.}
proc show*(b: BackButton): BackButton {.importjs: "#.show()", nodecl.}
proc hide*(b: BackButton): BackButton {.importjs: "#.hide()", nodecl.}

#--------
# MainButtton
#--------
proc setText*(b: BottomButton, text: cstring): BottomButton {.importjs: "#.setText(#)", nodecl, discardable.}
proc onClick*(b: BottomButton, callback: EmptyEventHandler): BottomButton {.importjs: "#.onClick(#)", nodecl, discardable.}
proc offClick*(b: BottomButton, callback: EmptyEventHandler): BottomButton {.importjs: "#.offClick(#)", nodecl, discardable.}
proc show*(b: BottomButton): BottomButton {.importjs: "#.show()", nodecl.}
proc hide*(b: BottomButton): BottomButton {.importjs: "#.hide()", nodecl.}
proc enable*(b: BottomButton): BottomButton {.importjs: "#.enable()", nodecl.}
proc disable*(b: BottomButton): BottomButton {.importjs: "#.disable()", nodecl.}
proc showProgress*(b: BottomButton, leaveAction: bool): BottomButton {.importjs: "#.showProgress(#)", nodecl.}
proc hideProgress*(b: BottomButton): BottomButton {.importjs: "#.hideProgress()", nodecl.}
proc setParams*(b: BottomButton, params: JsObject): BottomButton {.importjs: "#.setParams(#)", nodecl.}


#--------
# SettingsButton
#--------
proc onClick*(b: SettingsButton, callback: EmptyEventHandler): SettingsButton {.importjs: "#.onClick(#)", nodecl.}
proc offClick*(b: SettingsButton, callback: EmptyEventHandler): SettingsButton {.importjs: "#.offClick(#)", nodecl.}
proc show*(b: SettingsButton): SettingsButton {.importjs: "#.show()", nodecl.}
proc hide*(b: SettingsButton): SettingsButton {.importjs: "#.hide()", nodecl.}

#--------
# HapticFeedback
#--------
proc impactOccurred*(h: HapticFeedback, style: cstring): HapticFeedback {.importjs: "#.impactOccurred(#)", nodecl.}
proc notificationOccurred*(h: HapticFeedback, kind: cstring): HapticFeedback {.importjs: "#.notificationOccurred(#)", nodecl.}
proc selectionChanged*(h: HapticFeedback): HapticFeedback {.importjs: "#.selectionChanged()", nodecl.}

#--------
# CloudStorage
#--------
proc setItem*(c: CloudStorage, key: cstring, value: cstring, callback: EmptyEventHandler) {.importjs: "#.setItem(#, #, #)", nodecl.}
proc getItem*(c: CloudStorage, key: cstring, callback: EmptyEventHandler) {.importjs: "#.getItem(#, #)", nodecl.}
proc getItems*(c: CloudStorage, keys: seq[cstring], callback: EmptyEventHandler) {.importjs: "#.getItems(#, #)", nodecl.}
proc removeItem*(c: CloudStorage, key: cstring, callback: EmptyEventHandler) {.importjs: "#.removeItem(#, #)", nodecl.}
proc removeItems*(c: CloudStorage, keys: seq[cstring], callback: EmptyEventHandler) {.importjs: "#.removeItems(#, #)", nodecl.}
proc getKeys*(c: CloudStorage, callback: EmptyEventHandler) {.importjs: "#.getKeys(#)", nodecl.}


#--------
# BiometricManager
#--------
proc init*(c: BiometricManager, callback: EmptyEventHandler) {.importjs: "#.init(#)", nodecl.}
proc requestAccess*(c: BiometricManager, params: BiometricRequestAccessParams, callback: EmptyEventHandler) {.importjs: "#.requestAccess(#, #)", nodecl.}
proc authenticate*(c: BiometricManager, params:BiometricAuthenticateParams, callback: EmptyEventHandler) {.importjs: "#.authenticate(#, #)", nodecl.}
proc updateBiometricToken*(c: BiometricManager, token: cstring, callback: EmptyEventHandler) {.importjs: "#.updateBiometricToken(#, #)", nodecl.}
proc openSettings*(c: BiometricManager) {.importjs: "#.openSettings()", nodecl.}

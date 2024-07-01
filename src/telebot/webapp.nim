import
  std/jsffi,
  std/strutils,
  std/macros

type
  WebAppEvents* = enum
    THEME_CHANGED = "themeChanged"
    VIEWPORT_CHANGED = "viewportChanged"
    MAIN_BUTTON_CLICKED = "mainButtonClicked"
    BACk_BUTTON_CLICKED = "backButtonClicked"
    SETTINGS_BUTTON_CLICKED = "settingsButtonClicked"
    INVOICE_CLOSE = "invoiceClosed"
    POPUP_CLOSED = "popupClosed"
    QR_TEXT_RECEIVED = "qrTextReceived"
    CLIPBOARD_TEXT_RECEIVED = "clipboardTextReceived"
    WRITE_ACCESS_REQUESTED = "writeAccessRequested"
    CONTACT_REQUESTED = "contactRequested"

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

  MainButton* {.importc, nodecl.} = object
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
    accent_text_color*: cstring
    section_bg_color*: cstring
    section_header_text_color*: cstring
    subtitle_text_color*: cstring
    destructive_text_color*: cstring

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
    isClosingConfirmationEnabled*: bool
    BackButton*: BackButton
    MainButton*: MainButton
    SettingsButton*: SettingsButton
    HapticFeedback*: HapticFeedback
    CloudStorage*: CloudStorage
    BiometricManager*: BiometricManager


  TelegramObj* {.importc, nodecl.} = object of RootObj
    WebApp*: WebApp

  TelegramRef* = ref TelegramObj

  EventHandler = proc()

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
proc isVersionAtLeast*(w: WebApp, version: cstring): bool {.importc, nodecl.}
proc setHeaderColor*(w: WebApp, color: cstring) {.importc, nodecl.}
proc setBackgrounColor*(w: WebApp, color: cstring) {.importc, nodecl.}
proc enableClosingConfirmation*(w: WebApp) {.importc, nodecl.}
proc disableClosingConfirmation*(w: WebApp) {.importc, nodecl.}
proc onEvent*(w: WebApp, eventType: cstring, eventHandler: EventHandler) {.importc, nodecl.}
proc offEvent*(w: WebApp, eventType: cstring, eventHandler: EventHandler) {.importc, nodecl.}
proc sendData*(w: WebApp, data: cstring) {.importc, nodecl.}
proc openLink*(w: WebApp, url: cstring, options: JsObject) {.importc, nodecl.}
proc openTelegramLink*(w: WebApp, url: cstring) {.importc, nodecl.}
proc openInvoice*(w: WebApp, url: cstring, callback: EventHandler = nil) {.importc, nodecl.}
proc showPopup*(w: WebApp, params: PopupParams, callback: EventHandler = nil) {.importc, nodecl.}
proc showAlert*(w: WebApp, message: string, callback: EventHandler = nil) {.importc, nodecl.}
proc showScanQrPopup*(w: WebApp, params: ScanQrPopupParams, callbback: EventHandler) {.importc, nodecl.}
proc closeScanQrPopup*(w: WebApp) {.importc, nodecl.}
proc readTextFromClipboard*(w: WebApp, callbback: EventHandler) {.importc, nodecl.}
proc requestWriteAccess*(w: WebApp, callback: EventHandler) {.importc, nodecl.}
proc requestContact*(w: WebApp, callback: EventHandler) {.importc, nodecl.}
proc showConfirm*(w: WebApp, message: cstring, callback: EventHandler = nil) {.importc, nodecl.}
proc ready*(w: WebApp): bool {.importc, nodecl.}
proc expand*(w: WebApp) {.importc, nodecl.}
proc close*(w: WebApp) {.importc, nodecl.}

#--------
# BackButtton
#--------
proc onClick*(b: BackButton, callback: EventHandler): BackButton {.importc, nodecl.}
proc offClick*(b: BackButton, callback: EventHandler): BackButton {.importc, nodecl.}
proc show*(b: BackButton): BackButton {.importc, nodecl.}
proc hide*(b: BackButton): BackButton {.importc, nodecl.}

#--------
# MainButtton
#--------
proc setText*(b: MainButton, text: cstring): MainButton {.importc, nodecl.}
proc onClick*(b: MainButton, callback: EventHandler): MainButton {.importc, nodecl.}
proc offClick*(b: MainButton, callback: EventHandler): MainButton {.importc, nodecl.}
proc show*(b: MainButton): MainButton {.importc, nodecl.}
proc hide*(b: MainButton): MainButton {.importc, nodecl.}
proc enable*(b: MainButton): MainButton {.importc, nodecl.}
proc disable*(b: MainButton): MainButton {.importc, nodecl.}
proc showProgress*(b: MainButton, leaveAction: bool): MainButton {.importc, nodecl.}
proc hideProgress*(b: MainButton): MainButton {.importc, nodecl.}
proc setParams*(b: MainButton, params: JsObject): MainButton {.importc, nodecl.}


#--------
# SettingsButton
#--------
proc onClick*(b: SettingsButton, callback: EventHandler): SettingsButton {.importc, nodecl.}
proc offClick*(b: SettingsButton, callback: EventHandler): SettingsButton {.importc, nodecl.}
proc show*(b: SettingsButton): SettingsButton {.importc, nodecl.}
proc hide*(b: SettingsButton): SettingsButton {.importc, nodecl.}

#--------
# HapticFeedback
#--------
proc impactOccurred*(h: HapticFeedback, style: cstring): HapticFeedback {.importc, nodecl.}
proc notificationOccurred*(h: HapticFeedback, kind: cstring): HapticFeedback {.importc, nodecl.}
proc selectionChanged*(h: HapticFeedback): HapticFeedback {.importc, nodecl.}

#--------
# CloudStorage
#--------
proc setItem*(c: CloudStorage, key: cstring, value: cstring, callback: EventHandler) {.importc, nodecl.}
proc getItem*(c: CloudStorage, key: cstring, callback: EventHandler) {.importc, nodecl.}
proc getItems*(c: CloudStorage, keys: seq[cstring], callback: EventHandler) {.importc, nodecl.}
proc removeItem*(c: CloudStorage, key: cstring, callback: EventHandler) {.importc, nodecl.}
proc removeItems*(c: CloudStorage, keys: seq[cstring], callback: EventHandler) {.importc, nodecl.}
proc getKeys*(c: CloudStorage, callback: EventHandler) {.importc, nodecl.}


#--------
# BiometricManager
#--------
proc init*(c: BiometricManager, callback: EventHandler) {.importc, nodecl.}
proc requestAccess*(c: BiometricManager, params: BiometricRequestAccessParams, callback: EventHandler) {.importc, nodecl.}
proc authenticate*(c: BiometricManager, params:BiometricAuthenticateParams, callback: EventHandler) {.importc, nodecl.}
proc updateBiometricToken*(c: BiometricManager, token: cstring, callback: EventHandler) {.importc, nodecl.}
proc openSettings*(c: BiometricManager) {.importc, nodecl.}

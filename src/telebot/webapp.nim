import std/jsffi

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
    query_id*: string
    user*: WebAppUser
    receiver*: WebAppUser
    chat*: WebAppChat
    start_param: string
    can_send_after*: int
    auth_date*: int
    hash*: string

  WebAppUser* {.importc, nodecl.} = object
    id*: int64
    is_bot*: bool
    first_name*: string
    last_name*: string
    username*: string
    language_code*: string
    isPremium*: bool
    addedToAttachmentMenu*: bool
    allowsWriteToPm*: bool
    photo_url*: string

  WebAppChat* {.importc, nodecl.} = object
    id*: int64
    `type`*: string
    title*: string
    username*: string
    photo_url*: string


  BackButton* {.importc, nodecl.} = object
    isVisible*: bool

  MainButton* {.importc, nodecl.} = object
    text*: string
    color*: string
    textColor*: string
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
    biometricType*: string
    isAccessRequested*: bool
    isAccessGranted*: bool
    isBiometricTokenSaved*: bool
    deviceId*: string

  BiometricRequestAccessParams* {.importc, nodecl.} = object
    reason*: string

  BiometricAuthenticateParams* {.importc, nodecl.} = object
    reason*: string

  ThemeParams* {.importc, nodecl.} = object
    bg_color*: string
    text_color*: string
    hint_color*: string
    link_color*: string
    button_color*: string
    button_text_color*: string
    secondary_bg_color*: string
    header_bg_color*: string
    accent_text_color*: string
    section_bg_color*: string
    section_header_text_color*: string
    subtitle_text_color*: string
    destructive_text_color*: string

  PopupButton* {.importc, nodecl.} = object
    id*: string
    `type`*: string
    text*: string

  PopupParams* {.importc, nodecl.} = object
    title*: string
    message*: string
    buttons*: seq[PopupButton]

  ScanQrPopupParams* {.importc, nodecl.} = object
    text*: string

  WebApp* = ref WebAppObj
  WebAppObj* {.importc, nodecl.} = object of RootObj
    initData*: string
    initDataUnsafe*: WebAppInitData
    version*: string
    platform*: string
    colorScheme*: string
    themeParams*: ThemeParams
    isExpanded*: bool
    viewportHeight*: float
    viewportStableHeight*: float
    headerColor*: string
    backgroundColor*: string
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

#--------
# WebApp
#--------
proc isVersionAtLeast*(w: WebApp, version: string): bool {.importc, nodecl.}
proc setHeaderColor*(w: WebApp, color: string) {.importc, nodecl.}
proc setBackgrounColor*(w: WebApp, color: string) {.importc, nodecl.}
proc enableClosingConfirmation*(w: WebApp) {.importc, nodecl.}
proc disableClosingConfirmation*(w: WebApp) {.importc, nodecl.}
proc onEvent*(w: WebApp, eventType: string, eventHandler: EventHandler) {.importc, nodecl.}
proc offEvent*(w: WebApp, eventType: string, eventHandler: EventHandler) {.importc, nodecl.}
proc sendData*(w: WebApp, data: string) {.importc, nodecl.}
proc openLink*(w: WebApp, url: string, options: JsObject) {.importc, nodecl.}
proc openTelegramLink*(w: WebApp, url: string) {.importc, nodecl.}
proc openInvoice*(w: WebApp, url: string, callback: EventHandler = nil) {.importc, nodecl.}
proc showPopup*(w: WebApp, params: PopupParams, callback: EventHandler = nil) {.importc, nodecl.}
proc showAlert*(w: WebApp, message: string, callback: EventHandler = nil) {.importc, nodecl.}
proc showScanQrPopup*(w: WebApp, params: ScanQrPopupParams, callbback: EventHandler) {.importc, nodecl.}
proc closeScanQrPopup*(w: WebApp) {.importc, nodecl.}
proc readTextFromClipboard*(w: WebApp, callbback: EventHandler) {.importc, nodecl.}
proc requestWriteAccess*(w: WebApp, callback: EventHandler) {.importc, nodecl.}
proc requestContact*(w: WebApp, callback: EventHandler) {.importc, nodecl.}
proc showConfirm*(w: WebApp, message: string, callback: EventHandler = nil) {.importc, nodecl.}
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
proc setText*(b: MainButton, text: string): MainButton {.importc, nodecl.}
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
proc impactOccurred*(h: HapticFeedback, style: string): HapticFeedback {.importc, nodecl.}
proc notificationOccurred*(h: HapticFeedback, kind: string): HapticFeedback {.importc, nodecl.}
proc selectionChanged*(h: HapticFeedback): HapticFeedback {.importc, nodecl.}

#--------
# CloudStorage
#--------
proc setItem*(c: CloudStorage, key: string, value: string, callback: EventHandler) {.importc, nodecl.}
proc getItem*(c: CloudStorage, key: string, callback: EventHandler) {.importc, nodecl.}
proc getItems*(c: CloudStorage, keys: seq[string], callback: EventHandler) {.importc, nodecl.}
proc removeItem*(c: CloudStorage, key: string, callback: EventHandler) {.importc, nodecl.}
proc removeItems*(c: CloudStorage, keys: seq[string], callback: EventHandler) {.importc, nodecl.}
proc getKeys*(c: CloudStorage, callback: EventHandler) {.importc, nodecl.}


#--------
# BiometricManager
#--------
proc init*(c: BiometricManager, callback: EventHandler) {.importc, nodecl.}
proc requestAccess*(c: BiometricManager, params: BiometricRequestAccessParams, callback: EventHandler) {.importc, nodecl.}
proc authenticate*(c: BiometricManager, params:BiometricAuthenticateParams, callback: EventHandler) {.importc, nodecl.}
proc updateBiometricToken*(c: BiometricManager, token: string, callback: EventHandler) {.importc, nodecl.}
proc openSettings*(c: BiometricManager) {.importc, nodecl.}

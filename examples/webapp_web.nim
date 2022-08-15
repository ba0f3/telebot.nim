import dom, telebot/webapp

#while not Telegram.WebApp.ready():
#  discard

Telegram.WebApp.showAlert("Hello from telebot.nim's WebApp")

let version = "Telegram.Webapp.version = " & Telegram.WebApp.version
echo(version)

window.document.write(version)

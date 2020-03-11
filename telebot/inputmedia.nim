import types, strutils, utils, options

proc `$`*(m: InputMedia): string =
    result = ""
    if m of InputMediaPhoto:
        var photo = InputMediaPhoto(m)
        photo.kind = "photo"
        marshal(photo[], result)
    elif m of InputMediaVideo:
        var video = InputMediaVideo(m)
        marshal(video[], result)
    elif m of InputMediaAudio:
        var audio = InputMediaAudio(m)
        marshal(audio[], result)
    elif m of InputMediaAnimation:
        var animation = InputMediaAnimation(m)
        marshal(animation[], result)
    elif m of InputMediaDocument:
        var document = InputMediaDocument(m)
        marshal(document[], result)

genInputMedia("Photo")
genInputMedia("Video")
genInputMedia("Animation")
genInputMedia("Audio")
genInputMedia("Document")

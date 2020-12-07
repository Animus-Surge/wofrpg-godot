extends HBoxContainer

var addonPage:String
var _dlPage:String

func initAddon(title,url,downloadURL,image=load("res://icon.png"),description="No Description Provided"):
	$icon.texture = image
	$VBoxContainer/title.text = title
	$VBoxContainer/description.text = description
	addonPage = url
	_dlPage = downloadURL

func onDlPressed():
	pass #TODO: download the pck file and store it to user://addons

func onWebPressed():
	#warning-ignore: return_value_discarded
	OS.shell_open(addonPage)

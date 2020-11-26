extends Panel

func _ready():
	#warning-ignore:return_value_discarded
	#fb.connect("dbComplete", self, "dbComplete")
	#warning-ignore:return_value_discarded
	fb.connect("failed", self, "failed")
	#following lines help with making sure the menu is visible
	$settingspanel.hide()
	$creditspanel.hide()
	get_node("../dialogue").hide()
	fb.getFromDB("newsinfo.json")
	gvars.setCurrentScene("menus")

#func dbComplete(result):
#	$newspanel/RichTextLabel.bbcode_text = result.text

func failed(reason, _action):
	print(reason)

func onPlay():
	gvars.load_scene("res://scenes/gamesys.tscn")

func onCredits():
	$creditspanel.show()

func onQuit():
	get_tree().quit(0)

func dialogueHide():
	get_node("../dialogue").hide()

func creditsHide():
	$creditspanel.hide()

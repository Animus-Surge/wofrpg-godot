extends Panel

func _ready():
	fb.connect("dbComplete", self, "dbComplete")
	fb.connect("failed", self, "failed")
	#following lines help with making sure the menu is visible
	$settingspanel.hide()
	$creditspanel.hide()
	get_node("../dialogue").hide()
	fb.getFromDB("newsinfo.json")

func dbComplete(result):
	$newspanel/RichTextLabel.bbcode_text = result.text

func failed(reason, action):
	print(reason)

func onSettings():
	$settingspanel.show()
func onSettingsHide():
	$settingspanel.hide()

func onPlay():
	pass #TODO

func onExpansions():
	get_node("../dialogue").show()

func onCredits():
	$creditspanel.show()

func onQuit():
	get_tree().quit(0)

func dialogueHide():
	get_node("../dialogue").hide()

func creditsHide():
	$creditspanel.hide()

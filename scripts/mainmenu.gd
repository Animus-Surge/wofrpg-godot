extends Panel

func _ready():
	fb.connect("dbComplete", self, "dbComplete")
	fb.connect("failed", self, "failed")
	$settingspanel.hide()
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
	pass #TODO (remake this thing)

func onQuit():
	get_tree().quit(0)

func dialogueHide():
	get_node("../dialogue").hide()

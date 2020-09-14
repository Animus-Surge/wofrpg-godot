extends Panel

func _ready():
	fb.connect("dbComplete", self, "dbComplete")
	$settingspanel.hide()
	fb.getFromDB("newsinfo")

func dbComplete(result):
	$newspanel/RichTextLabel.bbcode_text = result.text

func onSettings():
	$settingspanel.show()

func onPlay():
	pass #TODO

func onExpansions():
	get_node("../dialogue").show()

func onCredits():
	pass #TODO (remake this thing)

func onQuit():
	get_tree().quit(0)

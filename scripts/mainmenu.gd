extends Panel

func _ready():
	$settingspanel.hide()

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

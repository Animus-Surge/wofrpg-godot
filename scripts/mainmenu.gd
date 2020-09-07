extends Panel

func _ready():
	$settingspanel.hide()

func onSettings():
	$settingspanel.show()

func onPlay():
	pass

func onExpansions():
	get_node("../dialogue").show()

func onCredits():
	pass

func onQuit():
	get_tree().quit(0)

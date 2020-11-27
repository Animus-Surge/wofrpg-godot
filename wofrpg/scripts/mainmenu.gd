extends Panel

var loading = false
var backwards = false

func _ready():
	#warning-ignore:return_value_discarded
	#fb.connect("dbComplete", self, "dbComplete")
	#warning-ignore:return_value_discarded
	loading = true
	$AnimationPlayer.play_backwards("settings")
	#fb.connect("failed", self, "failed")
	$creditspanel.hide()
	#fb.getFromDB("newsinfo.json")
	gvars.setCurrentScene("menus")

#func dbComplete(result):
#	$newspanel/RichTextLabel.bbcode_text = result.text

func settings():
	$AnimationPlayer.play("settings")

func settingsHide():
	backwards = true
	$AnimationPlayer.play_backwards("settings")

func failed(reason, _action):
	print(reason)

func onPlay():
	gvars.load_scene("res://scenes/gamesys.tscn")

func onCredits():
	$creditspanel.show()

func onQuit():
	get_tree().quit(0)

func creditsHide():
	$creditspanel.hide()

func animDone(_anim_name):
	if backwards:
		$settingspanel.hide()
		backwards = false
	if loading:
		$settingspanel.hide()
		loading = false
		gvars.allReady()

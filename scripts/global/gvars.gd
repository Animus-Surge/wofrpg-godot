extends Node

puppet var clipaused = false
puppet var uiShowing = false

var sppaused = false

export (bool) var debug = false

func _ready():
	if !debug:
		scenes.load_scene("res://scenes/menus.tscn")
		gloader.startLoad()
		cfm.startLoad()
	else:
		print("DEBUG MODE ACTIVE")
	

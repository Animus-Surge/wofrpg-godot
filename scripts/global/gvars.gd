extends Node

puppet var clipaused = false
puppet var uiShowing = false

var sppaused = false

var loadedCharacter

var debug = true

var current

func _ready():
	if !debug:
		scenes.load_scene("res://scenes/menus.tscn")
		gloader.startLoad()
		cfm.startLoad()
	else:
		print("DEBUG MODE ACTIVE")

func setCurrentScene(scene):
	current = scene

extends Node

var sppaused = false
var uiShowing = false

var loadedCharacter
var save = "test-save"

var playerFlip

var debug = true

var current = "loadscreen"

func _ready():
	if !debug:
		scenes.load_scene("res://scenes/menus.tscn")
		gloader.startLoad()
		cfm.startLoad()
	else:
		print("DEBUG MODE ACTIVE")

func setCurrentScene(scene):
	current = scene

func inrange(callerPos, targetPos, distance) -> bool:
	if callerPos.distance_to(targetPos) <= distance: return true
	return false

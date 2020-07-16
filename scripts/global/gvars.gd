extends Node

puppet var clipaused = false
puppet var uiShowing = false

var sppaused = false

func _ready():
	scenes.load_scene("res://scenes/menus.tscn")
	

extends Control

var play = false
var settings = false
var quit = false

func _ready():
	gvars.currentScene = "mainmenu"
	gvars.onLoadedSceneReady()
	$AnimationPlayer.play("fader")

func onFaderComplete(_animation):
	if play:
		play = false
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/testmap.tscn")
	elif settings:
		settings = false
	elif quit:
		get_tree().quit(0)

func onPlay():
	play = true
	$AnimationPlayer.play_backwards("fader")

func onSettings():
	settings = true
	$AnimationPlayer.play_backwards("fader")

func onQuit():
	quit = true
	$AnimationPlayer.play_backwards("fader")

extends Control

var play = false
var settings = false
var quit = false

func _ready():
	pass

func onFaderComplete(_animation):
	if play:
		play = false
		$AnimationPlayer.play_backwards("fader")
	elif settings:
		settings = false
		$AnimationPlayer.play_backwards("fader")
	elif quit:
		get_tree().quit(0)

func onPlay():
	play = true
	$AnimationPlayer.play("fader")

func onSettings():
	settings = true
	$AnimationPlayer.play("fader")

func onQuit():
	quit = true
	$AnimationPlayer.play("fader")

func tree_entered():
	$AnimationPlayer.play("fader")

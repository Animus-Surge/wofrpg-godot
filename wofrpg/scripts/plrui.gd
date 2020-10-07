extends Control

onready var gvars = get_tree().get_root().get_node("globalvars")

func _on_Button_pressed():
	if Test.testscenes:
		get_tree().quit(0)
	else:
		gvars.load_scene("res://scenes/menus.tscn")

extends Control

onready var gvars = get_node("/root/globalvars")

func _on_Button_pressed():
	gvars.load_scene("res://scenes/menus.tscn")

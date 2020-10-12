extends Control

onready var test = get_tree().get_root().get_node("Test")

func quit():
	var gvars = get_tree().get_root().get_node("globalvars")
	if !is_instance_valid(test):
		gvars.load_scene("res://scenes/menus.tscn")
		gvars.paused = false
	else:
		if test.testscenes and gvars.debug:
			get_tree().quit(0)
		else: #TODO: make this better
			#print("blah")
			gvars.load_scene("res://scenes/menus.tscn")
			gvars.paused = false

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ESCAPE:
			$pausemenu.visible = !$pausemenu.visible
			var gvars = get_tree().get_root().get_node("globalvars")
			gvars.paused = !gvars.paused

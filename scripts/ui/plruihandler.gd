extends Control

func _ready():
	$pause.visible = false
	$inventory.visible = false

func _unhandled_key_input(event):
	if event.scancode == KEY_ESCAPE and event.pressed:
		if gvars.sppaused and !$pause.visible:
			pass #a different UI is showing
		elif !gvars.sppaused:
			$pause.visible = true
			gvars.sppaused = true
		elif gvars.sppaused:
			$pause.visible = false
			gvars.sppaused = false
	elif event.scancode == KEY_E and event.pressed and not gvars.sppaused:
		$inventory.visible = !$inventory.visible

func _button_input(action):
	if action == "resume":
		$pause.visible = false
		gvars.sppaused = false
	elif action == "exit-mm":
		scenes.load_scene("res://scenes/menus.tscn")
	elif action == "exit-ds":
		get_tree().quit(0)

extends Control

func _ready():
	$pause.visible = false
	$inventory.visible = false
	$npcinteraction.visible = false

func _unhandled_key_input(event):
	if event.scancode == KEY_ESCAPE and event.pressed:
		if globalvars.uiShowing:
			pass
		elif !globalvars.sppaused:
			$pause.visible = true
			globalvars.sppaused = true
		elif globalvars.sppaused:
			$pause.visible = false
			globalvars.sppaused = false
	elif event.scancode == KEY_E and event.pressed and not globalvars.sppaused:
		$inventory.visible = !$inventory.visible

func _button_input(action):
	if action == "resume":
		$pause.visible = false
		globalvars.sppaused = false
	elif action == "exit-mm":
		scenes.load_scene("res://scenes/menus.tscn")
	elif action == "exit-ds":
		get_tree().quit(0)

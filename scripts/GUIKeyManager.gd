extends Control

func _ready():
	get_node("PauseMenu").visible = false
	get_node("inventory").visible = false

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_E:
			get_node("inventory").visible = !get_node("inventory").visible
		elif event.pressed and event.scancode == KEY_ESCAPE:
			get_node("PauseMenu").visible = !get_node("PauseMenu").visible
			get_tree().paused = !get_tree().paused

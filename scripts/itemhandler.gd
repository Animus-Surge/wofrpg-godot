extends Area2D

var rnge = 400

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			if get_global_position().distance_to(get_node("../../objects/playerRoot").get_global_position()) <= rnge:
				print("Item can be picked up")
			else:
				print("Item cannot be picked up")

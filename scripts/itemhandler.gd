extends Area2D

var rnge = 1000
export (String) var itemid

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			if get_global_position().distance_to(get_node("../../objects/playerRoot").get_global_position()) <= rnge:
				get_tree().call_group("playerui", "addToInventory", gloader.loadItem(itemid))
				self.queue_free()

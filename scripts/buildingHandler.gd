extends Area2D

export (String) var building_name

func _mouse_entered():
	get_parent().modulate = Color(200, 200, 255, 0.1)

func _mouse_exited():
	get_parent().modulate = Color.white

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if building_name == "qtent-pos":
				get_tree().call_group("questingUI", "showUI")
			elif building_name == "shop-dummy-pos":
				print("Entering a shop!") #todo: add this shop

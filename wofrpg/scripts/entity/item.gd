extends Area2D

var item = {}

func set_item(i):
	item = i

func clear():
	item = {}

func _body_entered(body):
	print(body.type)

func _body_exited(body):
	print(body.type)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			get_node("../../CanvasLayer/UI").addItem(item)

extends Area2D

var item = {}
var inbounds = false

func set_item(i):
	item = i

func clear():
	item = {}

func _body_entered(body):
	if body.type == "PLAYER":
		inbounds = true

func _body_exited(body):
	if body.type == "PLAYER":
		inbounds = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and not item.empty() and inbounds:
		if event.button_index == BUTTON_LEFT and event.pressed:
			get_node("../../CanvasLayer/UI").addItem(item)

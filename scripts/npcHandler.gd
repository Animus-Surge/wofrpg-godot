extends Node2D

export (bool) var flipped = false

func _ready():
	get_node("Sprite").playing = true
	get_node("Sprite2").playing = true
	if flipped:
		get_node("Sprite").visible = false
		get_node("Sprite2").visible = true
	else:
		get_node("Sprite").visible = true
		get_node("Sprite2").visible = false

func _draw():
	if flipped:
		get_node("Sprite").visible = false
		get_node("Sprite2").visible = true
	else:
		get_node("Sprite").visible = true
		get_node("Sprite2").visible = false

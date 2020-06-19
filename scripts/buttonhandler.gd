extends HBoxContainer

signal saveCharacter

onready var graphic = get_node("TextureRect")

onready var hover = preload("res://images/mmbutton-graphic.png")
onready var click = preload("res://images/mmbutton-graphic-click.png")

func _ready():
	graphic.texture = hover
	graphic.self_modulate = Color.transparent

func _mouse_enter():
	graphic.self_modulate = Color.white

func _mouse_exit():
	graphic.self_modulate = Color.transparent
	
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			graphic.texture = click
			emit_signal("saveCharacter")
	else:
		graphic.texture = hover

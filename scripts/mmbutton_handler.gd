extends HBoxContainer

onready var graphic = get_node("TextureRect")

onready var hover = preload("res://images/mmbutton-graphic.png")
onready var click = preload("res://images/mmbutton-graphic-click.png")

func _ready():
	graphic.self_modulate = Color.transparent

func _mouse_enter():
	graphic.self_modulate = Color.white
	graphic.texture = hover

func _mouse_exit():
	graphic.self_modulate = Color.transparent

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			graphic.texture = click
			action()
	else:
		graphic.texture = hover

func action():
	if editor_description == "ng":
		get_parent().get_parent().get_node("ng-panel").visible = true
		get_parent().get_parent().get_node("set-panel").visible = false
		get_parent().get_parent().get_node("lg-panel").visible = false
	elif editor_description == "lg":
		get_parent().get_parent().get_node("lg-panel").visible = true
		get_parent().get_parent().get_node("set-panel").visible = false
		get_parent().get_parent().get_node("ng-panel").visible = false
	elif editor_description == "set":
		get_parent().get_parent().get_node("set-panel").visible = true
		get_parent().get_parent().get_node("ng-panel").visible = false
		get_parent().get_parent().get_node("lg-panel").visible = false
	elif editor_description == "exit":
		get_tree().quit(0)

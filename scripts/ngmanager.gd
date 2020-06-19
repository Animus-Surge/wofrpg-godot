extends HBoxContainer

var charName: String
var col1: Color
var col2: Color
var col3: Color
var col4: Color
var col5: Color
var tribes = []

func _ready():
	graphic.self_modulate = Color.transparent

func action():
	charName = get_parent().get_node("name").get_text()
	col1 = get_parent().get_node("body").color
	col2 = get_parent().get_node("wings").color
	col3 = get_parent().get_node("horns").color
	col4 = get_parent().get_node("eyes").color
	for i in get_parent().get_node("tribes_container").get_child_count():
		tribes.append(get_parent().get_node("tribes_container").get_child(i).pressed)
	saveCharacter()
	
	GVars.plrA = col1
	GVars.plrB = col2
	GVars.plrC = col3
	GVars.plrD = col4
	
func saveCharacter():
	var file = File.new()
	file.open("user://" + charName + ".save", File.WRITE)
	var info = {
		"name": charName,
		"tribes": tribes,
		"color_1": col1,
		"color_2": col2,
		"color_3": col3,
		"color_4": col4,
		"color_5": col5,
		"role":"null",
		"gender":"null"
	}
	file.store_line(to_json(info))
	file.close()

onready var graphic = get_node("TextureRect")

onready var hover = preload("res://images/mmbutton-graphic.png")
onready var click = preload("res://images/mmbutton-graphic-click.png")

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
			get_tree().change_scene("res://scenes/possibility.tscn")
	else:
		graphic.texture = hover

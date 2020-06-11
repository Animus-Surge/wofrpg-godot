extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var charName: String
var col1: Color
var col2: Color
var col3: Color
var col4: Color
var col5: Color
var tribes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _pressed():
	charName = get_parent().get_child(2).get_text()
	col1 = get_parent().get_child(3).color
	col2 = get_parent().get_child(4).color
	col3 = get_parent().get_child(5).color
	col4 = get_parent().get_child(6).color
	for i in get_parent().get_child(7).get_child_count():
		tribes.append(get_parent().get_child(7).get_child(i).pressed)
	saveCharacter()
	get_tree().change_scene("res://scenes/game.tscn")
	
func saveCharacter():
	var file = File.new()
	file.open("user://" + charName + ".save", File.WRITE)
	print(file.get_path())
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

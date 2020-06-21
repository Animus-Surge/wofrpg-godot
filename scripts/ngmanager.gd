extends Control

var charName: String
var col1: Color
var col2: Color
var col3: Color
var col4: Color
var col5: Color
var tribes = []
var gender
var role

func _ready():
	get_node("container/gender").add_item("Male")
	get_node("container/gender").add_item("Female")
	get_node("container/role").add_item("Warrior")
	get_node("container/role").add_item("Cleric")
	get_node("container/role").add_item("Rogue")
	get_node("container/role").add_item("Royalty")
	visible = false

func action():
	charName = get_node("container/name").get_text()
	col1 = get_node("container/body").color
	col2 = get_node("container/wings").color
	col3 = get_node("container/horns").color
	col4 = get_node("container/eyes").color
	for i in get_node("container/tribes").get_child_count():
		tribes.append(get_node("container/tribes").get_child(i).pressed)
	saveCharacter()
	
	GVars.plrA = col1
	GVars.plrB = col2
	GVars.plrC = col3
	GVars.plrD = col4
	
	if get_node("container/gender").selected == 0:
		gender = "male"
	elif get_node("container/gender").selected == 1:
		gender = "female"
		
	if get_node("container/role").selected == 0:
		role = "warrior"
	elif get_node("container/role").selected == 1:
		role = "warrior"
	elif get_node("container/role").selected == 2:
		role = "warrior"
	elif get_node("container/role").selected == 3:
		role = "warrior"
		
	loadscreen.loadScene("res://scenes/possibility.tscn")
	
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
		"role":role,
		"gender":gender
	}
	file.store_line(to_json(info))
	file.close()


func hideMenu():
	visible = false


func _on_HBoxContainer5_saveCharacter():
	action()

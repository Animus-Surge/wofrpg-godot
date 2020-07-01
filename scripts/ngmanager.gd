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
	
	var plrDict = {
		"name":charName,
		"gender":gender,
		"role":role,
		"colors":{
			"body":[
				col1.r8,
				col1.g8,
				col1.b8
			],
			"wings":[
				col2.r8,
				col2.g8,
				col2.b8
			],
			"horns":[
				col3.r8,
				col3.g8,
				col3.b8
			],
			"eyes":[
				col4.r8,
				col4.g8,
				col4.b8
			]
		},
		"tribes":{
			"hive":tribes[0],
			"ice":tribes[1],
			"leaf":tribes[2],
			"mud":tribes[3],
			"night":tribes[4],
			"rain":tribes[5],
			"sand":tribes[6],
			"sea":tribes[7],
			"silk":tribes[8],
			"sky":tribes[9]
		}
	}
	GVars._game_save(plrDict)

func hideMenu():
	visible = false

func _on_HBoxContainer5_saveCharacter():
	action()

extends Panel

onready var bodyCol = get_node("TabContainer/Colors/ColorPickerButton")
onready var wingCol = get_node("TabContainer/Colors/ColorPickerButton2")
onready var hornCol = get_node("TabContainer/Colors/ColorPickerButton3")
onready var eyeCol = get_node("TabContainer/Colors/ColorPickerButton4")
onready var tribes = get_node("TabContainer/Basic Details/tribes")
onready var cname = get_node("TabContainer/Basic Details/name")
onready var crole = get_node("TabContainer/Basic Details/Role")
onready var cgender = get_node("TabContainer/Basic Details/Gender")

func _ready():
	for tribe in gloader.baseTribes:
		tribes.add_item(tribe.name)

func create():
	pass

func createChar():
	pass
	

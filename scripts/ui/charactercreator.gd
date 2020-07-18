extends Panel

var slotToCreateTo: int

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
	var tribesList = []
	
	for itemindex in tribes.get_selected_items():
		tribesList.append(tribes.get_item_text(itemindex).to_lower())
	
	var details = {
		"name": cname,
		"gender": cgender,
		"role": crole,
		"tribes":tribesList,
		"colors":[
			{
				"part":"body",
				"r":bodyCol.color.r,
				"g":bodyCol.color.g,
				"b":bodyCol.color.b
			},
			{
				"part":"wings",
				"r":wingCol.color.r,
				"g":wingCol.color.g,
				"b":wingCol.color.b
			},
			{
				"part":"horns",
				"r":hornCol.color.r,
				"g":hornCol.color.g,
				"b":hornCol.color.b
			},
			{
				"part":"eyes",
				"r":eyeCol.color.r,
				"g":eyeCol.color.g,
				"b":eyeCol.color.b
			}
		]
	}
	var charfile = File.new()
	charfile.open("user://characters/" + cname.to_lower() + ".json", File.WRITE)
	print("Saving character: " + cname)
	charfile.store_line()

func init(slotnum: int):
	slotToCreateTo = slotnum
	print("Creating a new character at slot: " + String(slotnum))


func createChar():
	var tribes = 0
	for itemindex in tribes.get_selected_items():
		tribes+= 1
	if cname.text == "":
		pass #alert the player
	elif tribes == 0:
		pass #alert the player
	else:
		create()
	

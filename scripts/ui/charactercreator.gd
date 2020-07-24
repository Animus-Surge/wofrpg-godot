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
	var tribesList = []
	
	for itemindex in tribes.get_selected_items():
		tribesList.append(tribes.get_item_text(itemindex))
	
	var appearanceModifiers = []
	
	var skills = []
	
	var colors = []
	if appearanceModifiers.size() == 0: #TODO
		var body = {
			"r":bodyCol.color.r,
			"g":bodyCol.color.g,
			"b":bodyCol.color.b
		}
		var wings = {
			"r":bodyCol.color.r,
			"g":bodyCol.color.g,
			"b":bodyCol.color.b
		}
		var horns = {
			"r":bodyCol.color.r,
			"g":bodyCol.color.g,
			"b":bodyCol.color.b
		}
		var eyes = {
			"r":bodyCol.color.r,
			"g":bodyCol.color.g,
			"b":bodyCol.color.b
		}
		colors.append(body)
		colors.append(wings)
		colors.append(horns)
		colors.append(eyes)
	
	var details = {
		"name": cname.text,
		"gender": cgender.get_item_text(cgender.selected),
		"role": crole.get_item_text(crole.selected),
		"tribes":tribesList,
		"appearance":appearanceModifiers, #TODO
		"skills":skills,
		"colors":colors,
		"size":"default",
		"speed":"default"
	}
	var charfile = File.new()
	charfile.open("user://characters/" + cname.text.to_lower() + ".json", File.WRITE)
	charfile.store_line(to_json(details))
	print("Saved character: " + cname.text)
	get_tree().call_group("charlist", "created")
	cfm.characters.append(details)

func createChar():
	var errored = false
	var numtribes = 0
	cname.modulate = Color.white
	tribes.modulate = Color.white
	for itemindex in tribes.get_selected_items():
		numtribes+= 1
	if cname.text == "":
		get_node("TabContainer").set_current_tab(0)
		cname.modulate = Color.red
		errored = true
	if numtribes == 0:
		get_node("TabContainer").set_current_tab(0)
		tribes.modulate = Color.red
		errored = true
	
	if !errored: create()
	

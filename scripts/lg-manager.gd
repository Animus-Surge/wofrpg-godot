extends Control

var files = []

var indexSelected

func _ready():
	visible = false
	var dir = Directory.new()
	dir.open("user://saves")
	dir.list_dir_begin(true, true)
	print("Reading file data from user saves directory")
	
	while true:
		var file = dir.get_next()
		if file == "": break
		elif file.ends_with(".json"):
			files.append(file)
	
	for file in files:
		var data = File.new()
		data.open("user://saves/" + file, File.READ)
		print("Reading load data from file " + file)
		var fdata = JSON.parse(data.get_as_text())
		data.close()
		get_node("Panel/ItemList").add_item(fdata.result.get("save").get("player").get("plr-details").get("name"))
	get_node("Panel/HBoxContainer5").mouse_filter = Control.MOUSE_FILTER_IGNORE

func hideMenu():
	visible = false

func itemSelected(index):
	indexSelected = index
	get_node("Panel/HBoxContainer5").mouse_filter = Control.MOUSE_FILTER_PASS

func deselected():
	indexSelected = null
	get_node("Panel/HBoxContainer5").mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_HBoxContainer5_saveCharacter():
	GVars._game_load(files[indexSelected])

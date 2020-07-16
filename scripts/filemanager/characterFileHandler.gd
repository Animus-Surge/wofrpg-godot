extends Node

const path = "user://characters/"

var characters = []

func _ready():
	loadCharsList()

func create(data):
	var file = File.new()
	file.open(path + data.name.to_lower() + ".json", File.WRITE)
	file.store_line(to_json(data))

func loadCharacter(cname: String):
	var file = File.new()
	file.open(path + cname + ".json", File.READ)
	var contents = JSON.parse(file.get_as_text()).result
	
	#plug the character values into the detail handler

func loadCharsList():
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	var file = dir.get_next()
	while file != "":
		if !file.begins_with("."):
			var f = File.new()
			f.open(path + file, File.READ)
			get_tree().call_group("characterDisplay", "displayCharacter", JSON.parse(f.get_as_text()).result)
		file = dir.get_next()
	

func deleteCharacter(cname: String):
	var dir = Directory.new()
	dir.remove(path + cname + ".json")

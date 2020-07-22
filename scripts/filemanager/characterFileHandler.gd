extends Node

var characters = []

func startLoad():
	print("CFM Active")
	loadCharList()

func loadCharList():
	print("Attempting load of local character list...")
	var charDir = Directory.new()
	charDir.open("user://characters")
	charDir.list_dir_begin()
	
	var currentFile = charDir.get_next()
	var filesLoaded = 0
	
	while true:
		if currentFile != "":
			if currentFile.begins_with("."):
				pass
			else:
				filesLoaded += 1
				var charfile = File.new()
				charfile.open("user://characters/"+currentFile.get_file(), File.READ)
				var cdetails = JSON.parse(charfile.get_as_text()).result
				characters.append(cdetails)
				charfile.close()
			currentFile = charDir.get_next()
		else:
			break
	print("Characters loaded. Loaded: " + String(filesLoaded) + " files")

func deleteCharacter(slot):
	characters.remove(slot)

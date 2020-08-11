extends Node

var characters = []

func startLoad():
	loadCharList()

func loadCharList():
	logcat.stdout("Attempting load of local character list...", logcat.INFO)
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
# warning-ignore:unsafe_property_access
				var cdetails = JSON.parse(charfile.get_as_text()).result
				characters.append(cdetails)
				charfile.close()
			currentFile = charDir.get_next()
		else:
			break
	logcat.stdout("Characters loaded. Loaded: " + String(filesLoaded) + " files", logcat.INFO)

func delete(idx: int):
	logcat.stdout("Removed character: " + characters[idx].name, logcat.INFO)
	var cdir = Directory.new()
	cdir.remove("user://characters/" + characters[idx].name.to_lower() + ".json")
	characters.remove(idx)

func loadCharacter(charname) -> Dictionary:
	var data = {}
	var charfile = File.new()
	charfile.open("user://characters/" + charname.to_lower() + ".json", File.READ)
	data = JSON.parse(charfile.get_as_text()).result
	return data

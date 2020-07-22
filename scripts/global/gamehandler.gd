extends Panel

const savesPath = "user://saves/"

func _ready():
	var savesDir = Directory.new()
	savesDir.open(savesPath)
	savesDir.list_dir_begin()
	
	var saves = []
	
	var save = savesDir.get_next()
	while save != "":
		if !save.begins_with("."):
			print(save)
		save = savesDir.get_next()
		

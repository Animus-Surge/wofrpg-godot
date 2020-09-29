extends Node

const blankChar = {
	"name":"[empty]",
	"tribes":[],
	"role":null,
	"appearances":{
		"head":"nw",
		"body":"nw",
		"tail":"nw",
		"legs":"nw",
		"wings":"nw",
		"showSpine":false,
		"showTeardrop":false,
		"showBarb":false
	},
	"colors":{
		"scales":{"r":1,"g":1,"b":1},
		"wings":{"r":1,"g":1,"b":1},
		"horns":{"r":1,"g":1,"b":1},
		"eyes":{"r":1,"g":1,"b":1},
		"spine":{"r":1,"g":1,"b":1}
	},
	"skills":{}
}

onready var logcat = get_tree().get_root().get_node("logcat")

var characters = []

var headPal
var scalePal
var wingPal

func loadCharacterPalettes(charid: int):
	var path = "user://characters/slot-" + String(charid) + "/"

func saveCharacterPalettes(head: Image, scales: Image, wings: Image):
	pass

func startLoad():
	loadCharList()

func loadCharList():
	characters = []
	
	var c1 = File.new()
	var c2 = File.new()
	var c3 = File.new()
	var dir = Directory.new()
	var e1 = c1.open("user://characters/slot-0/slot-0.json", File.READ)
	var e2 = c2.open("user://characters/slot-1/slot-1.json", File.READ)
	var e3 = c3.open("user://characters/slot-2/slot-2.json", File.READ)
	
	if e1 != OK or e2 != OK or e3 != OK:
		if e1 == ERR_FILE_NOT_FOUND:
			logcat.stdout("Character file not found: slot-0.json Creating...", 2)
			c1.close()
			dir.make_dir_recursive("user://characters/slot-0")
			c1.open("user://characters/slot-0/slot-0.json", File.WRITE)
			c1.store_line(to_json(blankChar))
			c1.close()
		if e2 == ERR_FILE_NOT_FOUND:
			logcat.stdout("Character file not found: slot-1.json Creating...", 2)
			c2.close()
			dir.make_dir_recursive("user://characters/slot-1")
			c2.open("user://characters/slot-1/slot-1.json", File.WRITE)
			c2.store_line(to_json(blankChar))
			c2.close()
		if e3 == ERR_FILE_NOT_FOUND:
			logcat.stdout("Character file not found: slot-2.json Creating...", 2)
			c3.close()
			dir.make_dir_recursive("user://characters/slot-2")
			c3.open("user://characters/slot-2/slot-2.json", File.WRITE)
			c3.store_line(to_json(blankChar))
			c3.close()
		return
	
	characters.append(JSON.parse(c1.get_as_text()).result)
	characters.append(JSON.parse(c2.get_as_text()).result)
	characters.append(JSON.parse(c3.get_as_text()).result)
	
	c1.close()
	c2.close()
	c3.close()
	
	logcat.stdout("Characters loaded", 1)

func deleteChar(slotid: int):
	var slot = Directory.new()
	slot.remove("user://characters/slot-" + String(slotid) + "/slot-" + String(slotid) + ".json")
	var cfile = File.new()
	cfile.open("user://characters/slot-" + String(slotid) + "/slot-" + String(slotid) + ".json", File.WRITE)
	cfile.store_line(to_json(blankChar))
	cfile.close()
	logcat.stdout("Successfully deleted character in slot: " + String(slotid), 1)

func loadCharacter(charname) -> Dictionary:
	return {}

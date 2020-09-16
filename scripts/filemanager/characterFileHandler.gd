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

var characters = []

func startLoad():
	loadCharList()

func loadCharList():
	characters = []
	
	var c1 = File.new()
	var c2 = File.new()
	var c3 = File.new()
	c1.open("user://characters/slot-0/slot-0.json")
	c2.open("user://characters/slot-1/slot-1.json")
	c3.open("user://characters/slot-2/slot-2.json")
	
	characters.append(JSON.parse(c1.get_as_text()).result)
	characters.append(JSON.parse(c2.get_as_text()).result)
	characters.append(JSON.parse(c3.get_as_text()).result)
	
	c1.close()
	c2.close()
	c3.close()
	
	logcat.stdout("Characters loaded", logcat.INFO)

func deleteChar(slotid: int):
	var slot = Directory.new()
	slot.remove("user://characters/slot-" + String(slotid) + "/slot-" + String(slotid) + ".json")

func loadCharacter(charname) -> Dictionary:
	return {}

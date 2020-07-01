extends Node

# GLOBAL VARIABLES
var plrA = Color.white
var plrB = Color.white
var plrC = Color.white
var plrD = Color.white

var scene = 1

var itemData
var questData

var hasQuest = false
var currentQuest = {}

var currentSceneRoot

var loadFile = false

# GLOBAL FUNCTIONS
func _ready():
	var itemFile = File.new()
	itemFile.open("res://data/itemDictionary.json", File.READ)
	var data = JSON.parse(itemFile.get_as_text())
	itemFile.close()
	itemData = data.result
	
	_get_quest_info()
	
	#TODO: make it so all data files will be "moved" to the user folders
	
func _get_quest_info():
	var questFile = File.new()
	questFile.open("user://data/quests.json", File.READ)
	var qdata = JSON.parse(questFile.get_as_text())
	questFile.close()
	questData = qdata.result

func _game_save(playerObj: Dictionary):
	var save = {
		"save":{
			"date":OS.get_datetime(),
			"player":{
				"location":{
					"id":"sw-pos",
					"x":-1454,
					"y":395
				},
				"plr-details":playerObj,
				"inventory":{
					"slots":[],
					"equipment":{
						"weapon-primary":{},
						"weapon-secondary":{},
						"arm-head":{},
						"arm-body":{},
						"arm-tail":{},
						"arm-wings":{},
						"arm-legs":{},
						"backpack":{}
					}
				}
			}
		}
	}
	
	var saveFile = File.new()
	saveFile.open("user://saves/" + save.get("save").get("player").get("plr-details").get("name").to_lower() + ".json", File.WRITE)
	print("Saving file " + saveFile.get_path())
	saveFile.store_line(to_json(save))
	saveFile.close()


func _game_load(file: String):
	var saveFile = File.new()
	saveFile.open("user://saves/" + file, File.READ)
	print("Loading from file " + saveFile.get_path())
	var data = JSON.parse(saveFile.get_as_text())
	saveFile.close()
	loadFile = true
	
	var colorRoot = data.result["save"].get("player").get("plr-details").get("colors")
	
	plrA = Color(colorRoot.get("body")[0] / 255, colorRoot.get("body")[1] / 255, colorRoot.get("body")[2] / 255)
	plrB = Color(colorRoot.get("wings")[0] / 255, colorRoot.get("wings")[1] / 255, colorRoot.get("wings")[2] / 255)
	plrC = Color(colorRoot.get("horns")[0] / 255, colorRoot.get("horns")[1] / 255, colorRoot.get("horns")[2] / 255)
	plrD = Color(colorRoot.get("eyes")[0] / 255, colorRoot.get("eyes")[1] / 255, colorRoot.get("eyes")[2] / 255)
	
	get_tree().change_scene("res://scenes/possibility.tscn")

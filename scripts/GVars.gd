extends Node

# GLOBAL VARIABLES
var plrA = Color.white
var plrB = Color.white
var plrC = Color.white
var plrD = Color.white

var scene = 1

var playerLocation: Vector2

var itemData
var questData
var squestData
var dialogueData

var hasQuest = false
var currentQuest = {}
var questPart
var questPartInfo = {}
var questInteraction

var mapname

var currentSceneRoot

var loadFile = false

var plrName

# GLOBAL FUNCTIONS
func _ready():
	var itemFile = File.new()
	itemFile.open("res://data/itemDictionary.json", File.READ)
	print("Loading item dictionary")
	var data = JSON.parse(itemFile.get_as_text())
	itemFile.close()
	itemData = data.result
	
	var dialogueFile = File.new()
	dialogueFile.open("user://data/dialogues.json", File.READ)
	print("Loading dialogue info")
	var ddata = JSON.parse(dialogueFile.get_as_text())
	dialogueFile.close()
	dialogueData = ddata.result
	
	_get_quest_info()
	
func _get_quest_info():
	var questFile = File.new()
	questFile.open("user://data/quests.json", File.READ)
	print("Loading quest data")
	var qdata = JSON.parse(questFile.get_as_text())
	questFile.close()
	questData = qdata.result
	
	var squestFile = File.new()
	squestFile.open("user://data/side-quests.json", File.READ)
	print("Loading side quest data")
	var sqdata = JSON.parse(squestFile.get_as_text())
	squestFile.close()
	squestData = sqdata.result

func _character_load(charname: String):
	var charfile = File.new()
	charfile.open("user://characters/" + charname.to_lower() + ".json")

func loadSideQuest(sqid: String):
	questPart = 1
	currentQuest = squestData["side-quests"].get(sqid)
	

func questUpdate():
	questPartInfo = currentQuest.get("tasks").get("task-" + String(questPart))

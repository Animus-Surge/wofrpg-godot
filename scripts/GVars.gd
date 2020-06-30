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

# GLOBAL FUNCTIONS
func _ready():
	var itemFile = File.new()
	itemFile.open("res://data/itemDictionary.json", File.READ)
	var data = JSON.parse(itemFile.get_as_text())
	itemFile.close()
	itemData = data.result
	
	print(OS.get_user_data_dir())
	
	_get_quest_info()
	
	#TODO: make it so all data files will be "moved" to the user folders
	
func _get_quest_info():
	var questFile = File.new()
	questFile.open("user://data/quests.json", File.READ)
	var qdata = JSON.parse(questFile.get_as_text())
	questFile.close()
	questData = qdata.result

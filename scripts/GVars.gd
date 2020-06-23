extends Node

# GLOBAL VARIABLES
var plrA = Color.white
var plrB = Color.white
var plrC = Color.white
var plrD = Color.white

var scene = 1

var itemData

var currentSceneRoot

# GLOBAL SIGNALS
signal pickUpItem(args)

# GLOBAL FUNCTIONS
func _ready():
	var itemFile = File.new()
	itemFile.open("res://data/itemDictionary.json", File.READ)
	var data = JSON.parse(itemFile.get_as_text())
	itemFile.close()
	itemData = data.result

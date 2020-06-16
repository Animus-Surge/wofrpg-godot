extends Node

#GLOBAL VARIABLES

var plrA = Color.white
var plrB = Color.white
var plrC = Color.white
var plrD = Color.white

var itemData

func _ready():
	var itemFile = File.new()
	itemFile.open("res://data/itemDictionary.json", File.READ)
	var data = JSON.parse(itemFile.get_as_text())
	itemFile.close()
	itemData = data.result

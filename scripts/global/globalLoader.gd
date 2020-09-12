extends Node

const tribesPath = "res://data/tribes/"
const ctribesPath = "user://localuserdata/tribes"

const itemDict = "user://data/base/items/itemdict.json"

var loadedtribes: Dictionary
var itemdict: Array

func startLoad(): 
	loadTribes()
	logcat.stdout("All stuff loaded.", logcat.DEBUG)

#All tribes stored in user://data/tribes

func loadTribes():
	var tribesDir = Directory.new()
	tribesDir.open("user://data/tribes")
	tribesDir.list_dir_begin()
	
	var currentTribe = tribesDir.get_next()
	var tribes = []
	
	while currentTribe != "":
		if currentTribe.begins_with("."):
			currentTribe = tribesDir.get_next()
		else:
			if currentTribe.ends_with(".json"):
				tribes.append(currentTribe)
			currentTribe = tribesDir.get_next()
	
	for tribe in tribes:
		#parse the tribe data into master dictionary
		var tribeFile = File.new()
		tribeFile.open("user://data/tribes/" + tribe, File.READ)
		if tribeFile.get_as_text() == "":
			logcat.stdout("Tribe file: " + tribe + " empty.", logcat.ERROR)
			continue
		var data = JSON.parse(tribeFile.get_as_text()).result
		if data != {}:
			loadedtribes[data.tribename] = data
		else:
			logcat.stdout("Invalid tribe file: " + tribe, logcat.ERROR)
			continue
		logcat.stdout("Loaded tribe: " + data.tribename + " from expansion: " + data.addon, logcat.INFO)

func loadSkillset(characterSkills: Array) -> Array:
	var cskills = []
	for skill in characterSkills:
		var skillFile = File.new()
		skillFile.open("user://data/base/skills/" + skill.id.split("-", true, 1)[1] + ".json") #TODO: skill handling
		var fileParseResult = JSON.parse(skillFile.get_as_text()).result
		cskills.append(fileParseResult)
	return cskills

func loadItem(itemid) -> Dictionary:
	var dict = File.new()
	dict.open("res://data/itemDictionary.json", File.READ) #TODO: make the naming convention consistent
	var dictjson = JSON.parse(dict.get_as_text()).result
	if dictjson.has(itemid):
		return dictjson.get(itemid)
	else:
		return {}

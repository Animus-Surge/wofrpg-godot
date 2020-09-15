extends Node

const tribesPath = "res://data/tribes/"
const ctribesPath = "user://localuserdata/tribes"

const itemDict = "user://data/base/items/itemdict.json"

var loadedtribes: Dictionary
var itemdict: Array

func startLoad(): 
	loadTribes()
	loadSettings()
	logcat.stdout("All stuff loaded.", logcat.DEBUG)

#settings stored in user://settings.json

func loadSettings():
	var setfile = File.new()
	var error = setfile.open("user://settings.json", File.READ)
	if error != OK:
		logcat.stdout("Unable to open settings file. ERROR: " + error, logcat.ERROR)
		return
	var settings = JSON.parse(setfile.get_as_text()).result
	logcat.stdout("Settings loaded. Fullscreen: " + String(settings.fullscreen) + " Resolution Index: " + String(settings.resolution), logcat.DEBUG)
	OS.window_fullscreen = settings.fullscreen
	match settings.resolution:
		0: #1920x1080
			OS.window_size = Vector2(1920,1080)
		1: #DEFAULT: 1366x768
			OS.window_size = Vector2(1366,768)
		2: #1440x900
			OS.window_size = Vector2(1440,900)
		3: #1536x864
			OS.window_size = Vector2(1536,864)
		4: #2560x1440
			OS.window_size = Vector2(2560,1440)
		5: #1680x1050
			OS.window_size = Vector2(1680,1050)
		6: #1280x720
			OS.window_size = Vector2(1280,720)
		7: #1280x800
			OS.window_size = Vector2(1280,800)
		8: #1600x900
			OS.window_size = Vector2(1600,900)

func saveSettings():
	pass

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

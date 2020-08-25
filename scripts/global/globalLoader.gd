extends Node

const tribesPath = "res://data/tribes/"
const ctribesPath = "user://localuserdata/tribes"

const itemDict = "user://data/base/items/itemdict.json"

var baseTribes: Array
var itemdict: Array

func startLoad():
	loadBaseTribes()

func loadBaseTribes():
	var dir = Directory.new()
	if !dir.dir_exists(tribesPath):
		logcat.stdout("No base tribes have been defined!", logcat.ERROR) #replace this with an in game message
		return
	dir.open(tribesPath)
	logcat.stdout("Loading base tribes...", logcat.INFO)
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if !file.begins_with("."):
			var f = File.new()
			f.open(tribesPath + file, File.READ)
			baseTribes.append(JSON.parse(f.get_as_text()).result)
			f.close()
		file = dir.get_next()
	if baseTribes.size() == 0:
		logcat.stdout("No base tribes have been defined!", logcat.ERROR)
		return
	logcat.stdout("Base tribes loaded", logcat.INFO)

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

extends Node

const tribesPath = "user://data/base/tribes/"
const ctribesPath = "user://localuserdata/tribes"

const itemDict = "user://data/base/items/itemdict.json"

var baseTribes: Array
var itemdict: Array

func startLoad():
	loadBaseTribes()
	loadItems()

func loadBaseTribes():
	var dir = Directory.new()
	if !dir.dir_exists(tribesPath):
		printerr("ERROR: No base tribes have been defined!") #replace this with an in game message
		return
	dir.open(tribesPath)
	print("Loading base tribes...")
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
		printerr("ERROR: No base tribes have been defined!")
		return
	print("Base tribes loaded")

func loadItems():
	print("Loading item dictionary")
	var dict = File.new()
	dict.open(itemDict, File.READ)
	itemdict = JSON.parse(dict.get_as_text()).result.itemDict
	print("Loaded item dictionary")

func loadSkillset(characterSkills: Array) -> Array:
	var cskills = []
	for skill in characterSkills:
		var skillFile = File.new()
		skillFile.open("user://data/base/skills/" + skill.id.split("-", true, 1)[1] + ".json") #TODO: skill handling
		var fileParseResult = JSON.parse(skillFile.get_as_text()).result
		cskills.append(fileParseResult)
	return cskills

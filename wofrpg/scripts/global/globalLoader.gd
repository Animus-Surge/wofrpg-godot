extends Node

const tribesPath = "res://data/tribes/"
const ctribesPath = "user://localuserdata/tribes"

const itemDict = "user://data/base/items/itemdict.json"

var loadedtribes: Array
var tribeindexes: Array
var itemdict: Array

onready var logcat = get_tree().get_root().get_node("logcat")

func startLoad():
	loadSettings()
	loadAddons()
	loadTribes()
	logcat.stdout("All stuff loaded.", 0)

func loadSettings():
	var setfile = File.new()
	var error = setfile.open("user://settings.json", File.READ)
	if error != OK:
		logcat.stdout("Unable to open settings file. ERROR: " + String(error), 3)
		OS.window_size = Vector2(1366,768)
		OS.window_fullscreen = true
		if error == ERR_FILE_NOT_FOUND:
			setfile.open("user://settings.json", File.WRITE)
			setfile.store_line(to_json({"fullscreen":true,"resolution":1}))
			setfile.close()
			return
		return
	var settings = JSON.parse(setfile.get_as_text()).result
	logcat.stdout("Settings loaded. Fullscreen: " + String(settings.fullscreen) + " Resolution Index: " + String(settings.resolution), 0)
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
	setfile.close()

func saveSettings():
	pass

#Addons stored in user://addons

func loadAddons():
	var addondir = Directory.new()
	#TODO

#All tribes stored in res://data/tribes

func loadTribes():
	var tribesdir = Directory.new()
	tribesdir.open("res://data/tribes")
	tribesdir.list_dir_begin()
	var tribe = tribesdir.get_next()
	while tribe != "":
		if tribe.begins_with("."):
			tribe = tribesdir.get_next()
			continue
		var tfile = File.new()
		tfile.open("res://data/tribes/" + tribe, File.READ)
		var tribedata = JSON.parse(tfile.get_as_text()).result
		loadedtribes.append(tribedata)
		tribeindexes.append(tribedata.tribename)
		logcat.stdout("Loaded tribe: " + tribedata.modid + ":" + tribedata.tribename, 1)
		tribe = tribesdir.get_next()

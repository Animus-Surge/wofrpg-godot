extends Node

const tribesPath = "res://data/tribes/"
const ctribesPath = "user://localuserdata/tribes"

const itemDict = "user://data/base/items/itemdict.json"

var loadedtribes: Array
var tribeindexes: Array
var itemdict: Array

var persistentLogin = false

func startLoad():
	if !gvars.debug:
		login()
	loadSettings()
	loadAddons()
	loadTribes()
	checkDirs()
	logcat.stdout("All stuff loaded.", 0)

func login():
	var pwu = File.new()
	var err = pwu.open("user://temp/login.pwu", File.READ)
	if err == ERR_FILE_NOT_FOUND:
		logcat.stdout("Could not find login.pwu. Running singleplayer instance", logcat.INFO)
		gvars.load_scene("res://scenes/menus.tscn")
		return
	elif err == OK:
		#return
		var unpw = pwu.get_as_text().split(";")
		#warning-ignore: return_value_discarded
		fb.connect("completed", self,"success")
		#warning-ignore: return_value_discarded
		fb.connect("failed", self, "fail")
		fb.userLogin(unpw[0].strip_edges(), unpw[1].strip_edges())
		if unpw.size() == 3:
			if unpw[2].strip_edges() == "persistent":
				persistentLogin = true
	else:
		print(err)

func success(_action):
	if !persistentLogin:
		var dir = Directory.new()
		dir.remove("user://temp/login.pwu")
	gvars.load_scene("res://scenes/menus.tscn")
func fail(_reason, _action):
	print(_reason)

func checkDirs():
	var dir = Directory.new()
	if !dir.dir_exists("user://addons/characters"):
		dir.make_dir_recursive("user://addons/characters")

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
# warning-ignore:unused_variable
	var addondir = Directory.new()
	#TODO

func loadCustom() -> Array:
	var chars = []
	var path = "user://addons/characters/"
	var chardir = Directory.new()
	chardir.open(path)
	chardir.list_dir_begin()
	var file: String = chardir.get_next()
	while file != "":
		if !file.begins_with("."):
			if file.ends_with(".pck"):
				var err = !ProjectSettings.load_resource_pack(path + file, false)
				if !err:
					logcat.stdout("Loaded custom character from addon file " + file, 1)
					var cf = File.new()
					var er = cf.open("res://data/customchars/" + file.split(".")[0] + ".json", File.READ)
					if er == 0:
						var jr = JSON.parse(cf.get_as_text()).result
						chars.append(jr)
				else:
					logcat.stdout("Problems loading addon file " + file, 2)
		file = chardir.get_next()
	return chars
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
		logcat.stdout("Loaded tribe: " + tribedata.modid + ":" + tribedata.tribeid, 1)
		tribe = tribesdir.get_next()

func loadNPCInteraction(npcid) -> Dictionary:
	var icfile = File.new()
	var err = icfile.open("res://data/interactions/" + npcid + ".json", File.READ)
	if err != OK:
		return {}
	var interaction = JSON.parse(icfile.get_as_text()).result
	return interaction

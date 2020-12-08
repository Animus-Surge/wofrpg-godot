extends Node

const tribesPath = "res://data/tribes/"
const ctribesPath = "user://localuserdata/tribes"

const itemDict = "user://data/base/items/itemdict.json"

var loadedtribes: Array
var tribeindexes: Array
var itemdict: Array

var firstInstance = true

var characters: Array

var persistentLogin = false

######################
# SETTINGS VARIABLES #
######################

var defaultTribe
var customizerBackground

var ratio
var language

var fs: bool
var win: bool

var masterVolume: float
var sfxVolume: float
var musicVolume: float

func startLoad():
	if !gvars.debug:
		login()
	loadSettings()
	loadAddons()
	loadTribes()
	checkDirs()
	loadCharacters()
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
			setfile.store_line(to_json({"fullscreen":true,"resolution":1,"first-instance":true}))
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
	if settings.get("first-instance"):
		firstInstance = true
	else:
		firstInstance = false
	setfile.close()
	

func saveSettings():
	pass

#Addons stored in user://addons

func loadAddons():
# warning-ignore:unused_variable
	var addondir = Directory.new()
	#TODO

func loadCImage(path) -> Texture:
	var tex = ImageTexture.new()
	var err = tex.load(path)
	if err != OK:
		logcat.stdout("Couldn't load image from path \"" + path + "\"", logcat.ERROR)
		return null
	tex.flags = 0
	return tex

# All tribes stored in res://data/tribes

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

# NPC interactions

func loadNPCInteraction(npcid) -> Dictionary:
	var icfile = File.new()
	var err = icfile.open("res://data/interactions/" + npcid + ".json", File.READ)
	if err != OK:
		return {}
	var interaction = JSON.parse(icfile.get_as_text()).result
	return interaction

# characters

"""
New data structure (JSON format)

blank means a blank dictionary: {} or a blank string: ""

{
	cname:Surge
	ctribes:[icew,silw]
	cgender:male
	cident:male
	crole:servant
	clevel:35
	cinventory:{
		head:[blank,blank] (Armor,cosmetic,(OPTIONAL)hidden) (NOTE: all items listed here will be dictionary format)
		neck:[blank,collar]
		torso:[blank,blank]
		legs:[blank,shackles]
		tail:[blank,blank]
		wing:[blank,blank,true]
		slots:{
			size:35
			contents:[
				fish
				fish
				fish
				fish
				fish
				cloth
				cloth
				iron ingot
				ruby
				sapphire
				blank
				...
				blank
			]
		}
	}
	cskills:{ (in skill dictionary format)
		learned:[
			...
		]
		not learned:[
			...
		]
	}
	cquick: { (Quickbar slots, all items will be in skill dictionary format)
		left: bite
		right: tail slap
		1: hide
		2: dash
		3: nuzzle
		4: blank
	}
	cuseCustom:true
	(Required if cuseCustom)
	ccustomPath:user://characters/custom/Surge.png (contains all animation sequences)
	ccustomSize:[6,2] (x and y dimensions in frames)
	ccustomAnims:[
		{
			name:idle
			length:5
			fps:5
			row:1
		}
		{
			name:run
			length:6
			fps:5
			row:2
		}
	]
	(Following lines used with customizer, required if not cuseCustom)
	palette:user://characters/palettes/character-name_palette.png
	appearance:{
		head:iw
		hpattern:integer (To be used later)
		body:iw
		bpattern:integer
		legs:iw
		lpattern:integer
		tail:iw
		tpattern:integer
		wing:iw
		wpattern:integer
		spine:iw
		spattern:integer
		tdeco:iw
		tdpattern:integer
		useED:false
		useSP:true
		useTD:true
		useWI:false
	}
}
"""

func loadCharacters():
	var cdir = Directory.new()
	if cdir.dir_exists("user://characters"):
		cdir.open("user://characters")
		cdir.list_dir_begin()
		var current = cdir.get_next()
		while current != "":
			if current.begins_with(".") or current == "palettes" or current == "custom" or not current.ends_with(".json"):
				current = cdir.get_next()
				continue
			var file = File.new()
			file.open("user://characters/" + current, File.READ)
			characters.append(JSON.parse(file.get_as_text()).result)
			current = cdir.get_next()
	else:
		cdir.make_dir_recursive("user://characters/palettes")
		cdir.make_dir_recursive("user://characters/custom")
		logcat.stdout("Created characters directory.", logcat.DEBUG)

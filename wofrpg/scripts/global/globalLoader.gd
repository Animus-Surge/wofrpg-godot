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

var defaultTribe #TODO
var customizerBackground #TODO

var ratio = 1
var language = 1

var fs: bool
var win: bool

var masterVolume: float = 1.0
var sfxVolume: float = 1.0
var musicVolume: float = 1.0

func startLoad():
	if !gvars.debug:
		login()
	loadSettings()
	loadAddons()
	loadTribes()
	checkDirs()
#	loadCharacters()
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
	if !dir.dir_exists("user://characters"):
		dir.make_dir_recursive("user://characters/custom")
		dir.make_dir_recursive("user://characters/palettes")

func loadSettings():
	var setfile = File.new()
	var error = setfile.open("user://settings.json", File.READ)
	if error != OK:
		logcat.stdout("Unable to open settings file. ERROR: " + String(error), 3)
		OS.window_size = Vector2(1366,768)
		OS.window_fullscreen = true
		if error == ERR_FILE_NOT_FOUND:
			setfile.open("user://settings.json", File.WRITE)
			setfile.store_line(to_json({"fs":true,"win":true,"lang":"en_us","resolution":1,"mvol":1.0,"muvol":1.0,"sfxvol":1.0}))
			setfile.close()
	var settings = JSON.parse(setfile.get_as_text()).result
	if settings.has("fullscreen") or settings.empty():
		setfile.close()
		settings = {}
		#warning-ignore: return_value_discarded
		Directory.new().remove("user://settings.json")
		setfile.open("user://settings.json", File.WRITE)
		setfile.store_line(to_json({"fs":true,"win":true,"lang":"en_us","resolution":1,"mvol":1.0,"muvol":1.0,"sfxvol":1.0}))
		setfile.close()
		setfile.open("user://settings.json", File.READ)
		settings = JSON.parse(setfile.get_as_text()).result
	logcat.stdout("Settings loaded. Fullscreen: " + String(settings.fs) + " Resolution Index: " + String(settings.resolution), 0)
	fs = settings.fs
	win = settings.win
	ratio = settings.resolution
	language = settings.lang
	musicVolume = settings.muvol
	masterVolume = settings.mvol
	sfxVolume = settings.sfxvol
	pass #TODO: Have Polezno show if A: user has no loaded characters and B: user has opted to use tutorials
	setfile.close()
	applySettings()

func saveSettings():
	applySettings()
# warning-ignore:return_value_discarded
	Directory.new().remove("user://settings.json")
	var setfile = File.new()
	setfile.open("user://settings.json", File.WRITE)
	var data = {
		"fs":fs,
		"win":win,
		"lang":"en_us",
		"resolution":1,
		"mvol":1.0,
		"muvol":1.0,
		"sfxvol":1.0
	}
	setfile.store_line(to_json(data))
	setfile.close()

func applySettings():
	OS.window_size = Vector2(1366,768)
	OS.window_fullscreen = fs
	OS.window_borderless = win
	OS.window_maximized = win

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
		if not tribe.ends_with(".json"):
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
	characters.clear()
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

func saveChar(partChoice:Array,colors:Texture,name:String) -> bool:
	if Directory.new().file_exists("user://characters/" + name + ".json"):
		return false
	var tribes = []
	var appearance = []
	
	for part in partChoice:
		appearance.append(loadedtribes[part].tribeid)
		if tribes.has(loadedtribes[part].tribeid):
			continue
		tribes.append(loadedtribes[part].tribeid)
	
	var pngPath = "user://characters/palettes/pal-" + name.to_lower() + ".png"
# warning-ignore:return_value_discarded
	colors.get_data().save_png(pngPath)
	
	var cdata = {
		"cname":name,
		"ctribes":tribes,
		"cgender":"unimplemented",
		"crole":"unimplemented",
		"clevel":0,
		"cscale":1,
		"ctraits":"unimplemented",
		"cinventory":"unimplemented",
		"cskills":"unimplemented",
		"cquick":"unimplemented",
		"cuseCustom":false,
		"cpal":pngPath,
		"cappearance":appearance #TODO: have this decoded beforehand
	}
	var charfile = File.new()
	charfile.open("user://characters/" + name.to_lower() + ".json", File.WRITE)
	charfile.store_line(to_json(cdata))
	charfile.close()
	return true

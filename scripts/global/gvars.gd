extends Node

enum REMOVE_REASONS {DROP, QUEST, DIED}
enum TRIBES_BUILTIN {NIGHTWING, SKYWING}

const DEFAULT_SAVE_DATA = {
	"character-location":{
		"x":0,	
		"y":0
	},
	"character-scene":"possibility",
	"skill-tree":"data/tree.json",
	"stats":{
		"level":0,
		"xp":0,
		"health":100,
		"mana":0,
		"max-health":100,
		"max-mana":0
	},
	"stat-modifiers":{
		"melee-atk":1,
		"ranged-atk":1,
		"flight-duration":1,
		"speed":1,
		"knockback":1
	},
	"character-inventory":{
		"reg":[],
		"arm-head":{},
		"arm-neck":{},
		"arm-body":{},
		"arm-wing":{},
		"arm-tail":{},
		"arm-legs":{}
	},
	"gold-count":0
}

var sppaused = false
var uiShowing = false

var loadedCharacter
var save = "test-save"

var playerFlip

var debug = true
var loggedIn = false

var current = "loadscreen"

func _ready():
	if !debug:
		print("==============> GAME START <==============")
		gloader.startLoad()
		cfm.startLoad()
		scenes.load_scene("res://scenes/useracct.tscn")
	else:
		logcat.stdout("DEBUG MODE ACTIVE", logcat.DEBUG)

func setCurrentScene(scene):
	current = scene

func inrange(callerPos, targetPos, distance) -> bool:
	if callerPos.distance_to(targetPos) <= distance: return true
	return false

func loadConfigFile():
	var cfgFile = File.new()
	if !cfgFile.file_exists("user://login.ids"):
		logcat.stdout("No user configuration file found. Unable to automatically log in.", logcat.WARNING)
		return
	var err = cfgFile.open_encrypted_with_pass("user://login.ids", File.READ, OS.get_unique_id())
	if !err == OK:
		logcat.stdout("Error when attempting to load user config file. " + String(err), logcat.ERROR)
		return
	var details = cfgFile.get_as_text().split(' ')
	fb.login(details[0], details[1])

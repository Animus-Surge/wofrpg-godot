extends Node

onready var gloader = get_tree().get_root().get_node("gloader")
onready var cfm = get_tree().get_root().get_node("cfm")
onready var logcat = get_tree().get_root().get_node("logcat")
var fb
onready var timer = get_tree().get_root().get_node("timer")
onready var test = get_node("/root/Test")

const LOCALHOST = "127.0.0.1"

var plrpalette: ImageTexture setget setPalette
var plrdata:Dictionary setget setPlayerData

func setPalette(palette: ImageTexture):
	plrpalette = palette

func setPlayerData(data:Dictionary):
	plrdata = data

var sppaused = false
var uiShowing = false

var debug = false
var loggedIn = false

var paused = false

var current = "loadscreen"

func _ready():
	if !debug:
		if is_instance_valid(test):
			if test.debug:
				test.connect("complete", self, "_complete")
		print("==============> GAME START <==============")
		gloader.startLoad()
		cfm.startLoad()
		load_scene("res://scenes/gamesys.tscn")

func _complete():
	if test.testscenes:
		fb = get_tree().get_root().get_node("fb")
		gloader.startLoad()
		logcat.stdout("DEBUG MODE ACTIVE", 0)
	else:
		fb = get_tree().get_root().get_node("fb")
		load_scene("res://scenes/gamesys.tscn")

func debugComplete():
	gloader.startLoad()
	logcat.stdout("DEBUG MODE ACTIVE", 0)

func setCurrentScene(scene):
	current = scene

func inrange(callerPos, targetPos, distance) -> bool:
	if callerPos.distance_to(targetPos) <= distance: return true
	return false

func loadConfigFile():
	var cfgFile = File.new()
	if !cfgFile.file_exists("user://login.ids"):
		logcat.stdout("No user configuration file found. Unable to automatically log in.", 2)
		return
	var err = cfgFile.open_encrypted_with_pass("user://login.ids", File.READ, OS.get_unique_id())
	if !err == OK:
		logcat.stdout("Error when attempting to load user config file. " + String(err), 3)
		return
	var details = cfgFile.get_as_text().split(' ')
	fb.login(details[0], details[1])

#=====Scene Loader System=====

var scn
var wait
var tmax = 100

func load_scene(scene: String):
	#print("Bop")
	#print(current)
	if current != "loadscreen":
		#print("Current is not loadscreen")
		get_node("/root/" + current).queue_free()
		get_node("/root/loadscreen").show()
	scn = ResourceLoader.load_interactive(scene)
	set_process(true)
	
	wait = 1

func _process(_delta):
	if scn == null:
		set_process(false)
		return
	if wait > 0:
		wait -= 1
		return
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + tmax:
		var err = scn.poll()
		if err == ERR_FILE_EOF:
			var resource = scn.get_resource()
			scn = null
			timer.wait_time = 2
			timer.start()
			yield(timer, "timeout")
			get_node("/root").add_child(resource.instance())
			get_node("/root/loadscreen").hide()
			break
		elif err == OK:
			#print("Beep boop")
			continue
		else:
			scn = null
			logcat.stdout("An error occured while loading a scene.", 4)
			break #TODO


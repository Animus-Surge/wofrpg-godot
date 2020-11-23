extends Node

const LOCALHOST = "127.0.0.1"

signal doneLoading()

var plrpalette = null setget setPalette
var plrdata:Dictionary setget setPlayerData
var plrframes: SpriteFrames = null setget setFrames

func setPalette(palette: ImageTexture):
	plrpalette = palette

func setFrames(frames: SpriteFrames):
	plrframes = frames

func setPlayerData(data:Dictionary):
	plrdata = data

var sppaused = false
var uiShowing = false

var useCustom = false
var debug = false
var loggedIn = false
var username = ""
var splr = false

var userattributes

var paused = false

var current = "loadscreen"

###################
# UTILITY CLASSES #
###################

class Sorter:
	static func itemsort_alphabetical(a,b): #Will sort the items by alphabetical name
		if a.itemname < b.itemname:
			return true
		return false 

func _ready():
	#var mpstate = Node.new()
	#mpstate.set_script(load("res://scripts/global/state.gd"))
	#mpstate.name = "State"
	#get_tree().get_root().add_child(mpstate)
	gloader.startLoad()
	cfm.startLoad()
	if !debug:
		print("==============> GAME START <==============")
		#load_scene("res://scenes/menus.tscn")
	else:
		print("==============> DEBUG MODE <==============")

func debugComplete():
	gloader.startLoad()
	logcat.stdout("DEBUG MODE ACTIVE", 0)

func setCurrentScene(scene):
	current = scene

func inrange(callerPos, targetPos, distance) -> bool:
	if callerPos.distance_to(targetPos) <= distance: return true
	return false

#=====Scene Loader System=====

var scn
var wait
var tmax = 100

func load_world(world_name: String, expansion = "base"):
	var worldDataFile=File.new()
	

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
			emit_signal("doneLoading")
			break
		elif err == OK:
			#print("Beep boop")
			continue
		else:
			scn = null
			logcat.stdout("An error occured while loading a scene. Error code: " + String(err), 4)
			break #TODO


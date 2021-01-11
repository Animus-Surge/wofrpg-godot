extends Node

const LOCALHOST = "127.0.0.1"

signal doneLoading()

var plrpalette = null setget setPalette
var plrdata:Dictionary setget setPlayerData
var plrframes = null setget setFrames

func setPalette(palette: ImageTexture):
	plrpalette = palette

func setFrames(frames):
	plrframes = frames

func setPlayerData(data:Dictionary):
	plrdata = data

var sppaused = false
var uiShowing = false
var useCustom = false
var loggedIn = false
var username = ""
var splr = false
var userattributes
var paused = false

##############
# DEBUG MODE #
##############
var debug = true

var current = "loadscreen"

###################
# UTILITY CLASSES #
###################

class Sorter:
	static func itemsort_alphabetical(a,b): #Will sort the items by alphabetical name
		if a.itemname < b.itemname:
			return true
		return false 

##########
# GLOBAL #
##########

func _ready():
	gloader.startLoad()
	if !debug:
		print("==============> GAME START <==============")
	else:
		print("==============> DEBUG MODE <==============")
		var debugplayer = File.new()
		var err = debugplayer.open("user://characters/debug king.json", File.READ)
		if err != OK:
			print(err)
			return
		setPlayerData(JSON.parse(debugplayer.get_as_text()).result)
		var pal = ImageTexture.new()
		err = pal.load("user://characters/palettes/pal-debug king.png")
		if err != OK:
			pal = load("res://images/character/palettes/palette-main.tex")
		pal.flags = 0
		setPalette(pal)

func setCurrentScene(scene):
	current = scene

func inrange(callerPos, targetPos, distance) -> bool:
	if callerPos.distance_to(targetPos) <= distance: return true
	return false

#=====Scene Loader System=====

var scn
var wait
var tmax = 100

func load_world(_world_name: String, _expansion = "base"):
	var _worldDataFile=File.new()

func load_scene(scene: String):
	if current != "loadscreen":
		get_node("/root/" + current).queue_free()
		get_node("/root/loadscreen/loadscreen").show()
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
			emit_signal("doneLoading")
			break
		elif err == OK:
			continue
		else:
			scn = null
			logcat.stdout("An error occured while loading a scene. Error code: " + String(err), 4)
			break #TODO

func allReady():
	if !debug:
		get_tree().get_root().get_node("loadscreen/loadscreen").hide()

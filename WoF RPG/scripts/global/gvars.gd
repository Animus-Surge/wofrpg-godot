extends Node

#global debug constants
const DEBUG = false
const TOUCHSCREEN = false

#global variables
var mouseCaptured = false
var paused = false
var dead = false
var currentScene = ""

var itemdict

func _ready():
	set_process(false)
	#load data files

####################
# SCENE MANAGEMENT #
####################

var loader
var wait
var tmax = 100

func loadScene(_scene_path):
	loader = ResourceLoader.load_interactive(_scene_path)
	if loader == null:
		return #TODO: error checking and correction attempting
	set_process(true)
	if currentScene != "":
		get_tree().get_root().get_node(currentScene).queue_free()
		currentScene = ""
	get_tree().get_root().get_node("loadscreen").show()
	wait = 1

func onLoadedSceneReady():
	get_tree().get_root().get_node("loadscreen").hide()

func _process(_delta):
	if loader == null:
		set_process(false)
		return
	
	if wait > 0:
		wait -= 1
		return
	
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + tmax:
		var err = loader.poll()
		
		if err == ERR_FILE_EOF:
			var resource = loader.get_resource()
			loader = null
			get_tree().get_root().add_child(resource.instance())
			break
		elif err == OK:
			continue
		else:
			#TODO: error handling
			loader = null
			break

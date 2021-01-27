extends Node

#global debug constants
const DEBUG = false
const TOUCHSCREEN = false

#global variables
var mouseCaptured = false
var paused = false
var dead = false

var itemdict

func _ready():
	var idict = File.new()
	idict.open("res://data/itemdict.json", File.READ)
	itemdict = JSON.parse(idict.get_as_text()).result

#scene management
func loadScene(_scene_path):
	pass

func _process(_delta):
	pass #TODO

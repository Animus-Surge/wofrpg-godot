extends Node

#global constants
const DEBUG = false

#global variables
var mouseCaptured = false
var paused = false

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

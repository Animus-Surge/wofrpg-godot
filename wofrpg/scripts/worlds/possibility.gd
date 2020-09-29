extends Node2D

onready var globalvars = get_tree().get_root().get_node("globalvars")
onready var logcat = get_tree().get_root().get_node("logcat")

func _ready():
	globalvars.current = "possibility"
	logcat.stdout("Loaded Scene: Possibility", 1)

#TODO: management functions for chunking and world animations

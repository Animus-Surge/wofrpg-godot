extends Node2D

func _ready():
	globalvars.current = "possibility"
	logcat.stdout("Loaded Scene: Possibility", logcat.INFO)

#TODO: management functions for chunking and world animations

extends Node

export (String) var sceneName

func _ready():
	gvars.setCurrentScene(sceneName)

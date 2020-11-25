extends Node

export (String) var sceneName

func _ready():
	gvars.setCurrentScene(sceneName)
	if sceneName != "loadscreen":
		gvars.allReady()

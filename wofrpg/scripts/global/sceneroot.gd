extends Node

export (String) var sceneName
export (bool) var readiness_check = true

func _ready():
	gvars.setCurrentScene(sceneName)
	if sceneName != "loadscreen" and readiness_check:
		gvars.allReady()

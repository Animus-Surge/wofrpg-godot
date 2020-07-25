extends Node

export (String) var sceneName

func _ready():
	globalvars.current = sceneName

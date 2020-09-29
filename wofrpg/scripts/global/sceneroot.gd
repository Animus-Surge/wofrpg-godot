extends Node

export (String) var sceneName

onready var glvars = get_tree().get_root().get_node("globalvars")
var globalvars

func _ready():
	if !is_instance_valid(glvars):
		if Test.debug:
			Test.connect("complete", self, "_complete")
		else:
			glvars.setCurrentScene(sceneName)
	else:
		glvars.setCurrentScene(sceneName)

func _complete():
	globalvars = get_tree().get_root().get_node("globalvars")
	globalvars.setCurrentScene(sceneName)

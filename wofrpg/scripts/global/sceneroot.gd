extends Node

export (String) var sceneName

onready var glvars = get_tree().get_root().get_node("globalvars")
onready var test = get_node("/root/Test")
var globalvars

func _ready():
	if !is_instance_valid(glvars):
		if test.debug:
			test.connect("complete", self, "_complete")
		else:
			glvars.setCurrentScene(sceneName)
	else:
		glvars.setCurrentScene(sceneName)

func _complete():
	globalvars = get_tree().get_root().get_node("globalvars")
	globalvars.setCurrentScene(sceneName)

extends Node

export (String) var sceneName

var glvars
onready var test = get_node("/root/Test")
var globalvars

func _ready():
	if !is_instance_valid(glvars):
		if is_instance_valid(test) and test.debug:
			test.connect("complete", self, "_complete")
		else:
			set_process(true)
	else:
		glvars.setCurrentScene(sceneName)

func _process(_delta):
	if !is_instance_valid(glvars):
		glvars = get_tree().get_root().get_node("globalvars")
		glvars.setCurrentScene(sceneName)
	else:
		set_process(false)

func _complete():
	globalvars = get_tree().get_root().get_node("globalvars")
	globalvars.setCurrentScene(sceneName)

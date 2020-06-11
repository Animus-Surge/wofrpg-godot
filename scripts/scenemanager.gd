extends Node

func _ready():
	pass
	
func loadScene(scene: String):
	if(scene != null):
		get_tree().change_scene(scene)

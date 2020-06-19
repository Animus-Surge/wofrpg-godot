extends Node


func loadScene(scene: String):
	if(scene != null):
		get_tree().change_scene(scene)

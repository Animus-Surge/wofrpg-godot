extends Node2D

export (String) var id

func _ready():
	GVars.currentSceneRoot = id

extends Node

var characters = []

func startLoad():
	loadCharList()

func makeCharacterDirectory(charname) -> String:
	var dir = "user://characters/" + charname
	var cdir = Directory.new()
	cdir.make_dir(dir)
	return dir

func loadCharList():
	pass

func delete(idx: int):
	pass

func loadCharacter(charname) -> Dictionary:
	return {}

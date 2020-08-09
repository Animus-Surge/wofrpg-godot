extends Node

var data = {}
var loadedsave

func createNew(data: Dictionary, savename):
	var gamedata = data
	print("Converting game data to JSON")
	for key in globalvars.DEFAULT_SAVE_DATA:
		gamedata[key] = globalvars.DEFAULT_SAVE_DATA[key]
	var savedir = Directory.new()
	savedir.make_dir("user://saves/" + savename)
	var savejson = File.new()
	savejson.open("user://saves/" + savename + "/save.json", File.WRITE)
	print("Storing game data")
	savejson.store_line(to_json(gamedata))
	savejson.close()
	savedir.make_dir("user://saves/" + savename + "/data")
	print("Save complete. Copying game files to data folder")
	#TODO

func removesave(savename: String):
	pass #TODO

func loadsave(savename:String):
	loadedsave = savename
	var savefile = File.new()
	savefile.open("user://saves/" + savename + "/save.json", File.READ)
	var savedata = JSON.parse(savefile.get_as_text()).result
	data = savedata
	savefile.close()
	spgs.pos = Vector2(data["character-location"].x, data["character-location"].y)
	scenes.load_scene("res://scenes/" + data["character-scene"] + ".tscn")

func savegame(playerpos: Vector2):
	var _savedir = Directory.new()
	_savedir.remove("user://saves/" + loadedsave + "/save.json")
	var savefile = File.new()
	savefile.open("user://saves/" + loadedsave + "/save.json", File.WRITE)
	var savedata = {
		"date":"blank",
		"character":spgs.charname
	}
	for key in globalvars.DEFAULT_SAVE_DATA:
		savedata[key] = globalvars.DEFAULT_SAVE_DATA[key]
	
	savedata["character-location"].x = playerpos.x
	savedata["character-location"].y = playerpos.y
	
	savefile.store_line(to_json(savedata))
	savefile.close()
	print("Successfully saved game: " + loadedsave)

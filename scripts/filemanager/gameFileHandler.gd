extends Node

func createNew(data: Dictionary, savename):
	var gamedata = data
	for key in globalvars.DEFAULT_SAVE_DATA:
		gamedata[key] = globalvars.DEFAULT_SAVE_DATA[key]
	var savedir = Directory.new()
	savedir.make_dir("user://saves/" + savename)
	var savejson = File.new()
	savejson.open("user://saves/" + savename + "/save.json", File.WRITE)
	savejson.store_line(to_json(gamedata))
	savejson.close()
	savedir.make_dir("user://saves/" + savename + "/data")

func removesave(savename: String):
	pass #TODO

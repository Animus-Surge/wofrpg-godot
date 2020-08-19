extends Panel

var character

var saves = []
onready var saveslist = get_node("Panel/ItemList")

func _ready():
	get_node("Panel/Button2").disabled = true
	get_node("Panel/Button3").disabled = true
	$savename.hide()
	if globalvars.debug:
		character = "Kelp".to_lower() #debug flag
		loadsaves(character)

func hideMenu():
	hide()
	character = null

func showMenu(ctr):
	character = ctr
	refresh()
	show()

func loadsaves(ctr):
	saves = []
	$Panel/ItemList.clear()
	var numfiles = 0
	var savesdir = Directory.new()
	savesdir.open("user://saves")
	savesdir.list_dir_begin()
	logcat.stdout("Loading user saves", logcat.INFO)
	var save = savesdir.get_next()
	while save != "":
		if !save.begins_with("."):
			var savejson = File.new()
			if save == "test-save":
				save = savesdir.get_next()
				continue
			savejson.open(savesdir.get_current_dir() + "/" + save + "/save.json", File.READ)
			var savedata = JSON.parse(savejson.get_as_text()).result
			if savedata.character == character:
				saves.append(save)
				numfiles += 1
		save = savesdir.get_next()
	logcat.stdout("Loaded " + String(numfiles) + " files", logcat.INFO)
	
	for s in saves:
		$Panel/ItemList.add_item(s)

func onSelectItem(index):
	get_node("Panel/Button2").disabled = false
	get_node("Panel/Button3").disabled = false

func refresh():
	logcat.stdout("Refreshing saves", logcat.DEBUG)
	loadsaves(character)

func loadsave():
	var selectedsave = $Panel/ItemList.get_item_text(Array($Panel/ItemList.get_selected_items())[0])
	gfm.loadsave(selectedsave)

func newsave():
	$savename.show()

func createsave():
	var savename = $savename/Panel/saveName.text
	$savename/Panel/saveName.set("custom_colors/font_color", null)
	if savename == "":
		$savename/Panel/saveName.set("custom_colors/font_color", Color.red)
	else:
		logcat.stdout("Creating new save: " + savename, logcat.INFO)
		var data = {
			"date":"blank",
			"character":character
		}
		gfm.createNew(data, savename)
		$savename.hide()
		refresh()

func removesave():
	gfm.removesave($Panel/ItemList.get_item_text(Array($Panel/ItemList.get_selected_items())[0]))

func cancelcreate():
	$savename.hide()
	$savename/Panel/saveName.text = ""

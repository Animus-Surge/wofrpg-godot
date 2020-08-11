extends Control

onready var charList = get_node("Panel/ItemList")

func _ready():
	$Panel.visible = true
	$Panel2.visible = false
	refresh()

func showCreateMenu():
	$Panel.visible = false
	$Panel2.visible = true

func showSelectMenu():
	$Panel.visible = true
	$Panel2.visible = false
	refresh()

func refresh():
	charList.unselect_all()
	charList.clear()
	$Panel/play.disabled = true
	$Panel/delete.disabled = true
	logcat.stdout("Refreshed character list", logcat.DEBUG)
	for c in cfm.characters:
		charList.add_item(c.name)

func charItemSelected(index):
	var characterDetails = cfm.characters[index]
	var tribes = ""
	for tribe in characterDetails.tribes:
		tribes = tribes + tribe + " "
	get_node("Panel/details").text = characterDetails.name + "\n" + characterDetails.gender + "\n" + characterDetails.role + "\n" + tribes
	$Panel/play.disabled = false
	$Panel/delete.disabled = false

func created():
	showSelectMenu()

func create():
	showCreateMenu()

func onPlay():
	get_node("../../../gameselect").call("showMenu", charList.get_item_text(charList.get_selected_items()[0]))
	setGlobalColorValues()
	showSelectMenu()
	get_node("../..").hide()

func setGlobalColorValues():
	var chardata = cfm.loadCharacter(charList.get_item_text(charList.get_selected_items()[0]))
	spgs.body = Color(chardata.colors[0].r, chardata.colors[0].g, chardata.colors[0].b)
	spgs.wings = Color(chardata.colors[1].r, chardata.colors[1].g, chardata.colors[1].b)
	spgs.horns = Color(chardata.colors[2].r, chardata.colors[2].g, chardata.colors[2].b)
	spgs.eyes = Color(chardata.colors[3].r, chardata.colors[3].g, chardata.colors[3].b)
	spgs.charname = chardata.name

func confdelete():
	cfm.delete(charList.get_selected_items()[0])
	refresh()

func onDelete():
	get_node("../../../conf-dialogue").visible = true

func onParentVisibilityChanged():
	charList.unselect_all()
	$Panel/play.disabled = true
	$Panel/delete.disabled = true

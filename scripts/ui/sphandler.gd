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
	print("Refreshed character list")
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
	spgs.init(cfm.characters[charList.get_selected_items()[0]])
	scenes.load_scene("res://scenes/possibility.tscn")

func onDelete():
	pass #TODO

func onParentVisibilityChanged():
	charList.unselect_all()
	$Panel/play.disabled = true
	$Panel/delete.disabled = true

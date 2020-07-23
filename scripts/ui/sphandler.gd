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

func refresh():
	charList.clear()
	for c in cfm.characters:
		charList.add_item(c.name)

func charItemSelected(index):
	var characterDetails = cfm.characters[index]
	get_node("Panel/details").text = characterDetails.name + "\n" + characterDetails.gender + "\n" + characterDetails.role + "\n" + "TODO"

func created():
	showSelectMenu()
	refresh()

func create():
	showCreateMenu()

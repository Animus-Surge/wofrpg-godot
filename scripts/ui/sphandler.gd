extends Control

func _ready():
	$Panel.visible = true
	$Panel2.visible = false

func showCreateMenu():
	$Panel.visible = false
	$Panel2.visible = true

func showSelectMenu():
	$Panel.visible = true
	$Panel2.visible = false

func showAllCharacters():
	for character in cfm.characters:
		var charSlot = load("res://obects/ui/Character.tscn").instance()
		charSlot.setDetails(character.name, null)

func refresh():
	pass

func create(slot):
	showCreateMenu()
	$Panel2.call("init", slot)

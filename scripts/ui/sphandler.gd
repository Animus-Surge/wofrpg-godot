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
	pass


func create(slot):
	showCreateMenu()
	#pass slot num to charactercreator.gd

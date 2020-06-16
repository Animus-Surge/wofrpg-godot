extends Node2D

export (String) var itemName
export (Texture) var itemTexture

signal pickUpItem(name, texture)
signal npcInteract

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if editor_description == "item":
				emit_signal("pickUpItem", itemName, itemTexture)
			elif editor_description == "NPC":
				emit_signal("npcInteract")

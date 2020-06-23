extends Area2D

export (String) var itemName
export (Texture) var itemTexture
export (String) var usage

export (String) var npcname
export (String, MULTILINE) var questcomplete
export (String, MULTILINE) var questinprogress
export (String, MULTILINE) var questdesc
export (String, MULTILINE) var confirmMessage
export (String, MULTILINE) var declineMessage
export (bool) var isQuest = false

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _input_event(viewport, event, shape_idx):
	if editor_description == "item":
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				get_tree().call_group("inventorySys", "add_item", itemName, itemTexture, usage)
				get_parent().remove_child(self)
	elif editor_description == "npc":
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				if isQuest:
					get_tree().call_group("npcInteract", "showInteraction", [npcname, questdesc, questinprogress, questcomplete, itemName, itemTexture, confirmMessage, declineMessage])
				else:
					pass

func setItemInfo(itemName: String, itemTexture: Texture, usage: String):
	self.itemName = itemName
	self.itemTexture = itemTexture
	self.usage = usage

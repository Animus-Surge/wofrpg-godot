extends Area2D

export (String) var itemName
export (Texture) var itemTexture
export (String) var usage

export (String) var questId
export (String) var npcID
export (String) var npcName

export (bool) var isShop

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
				if !isShop:
					get_tree().call_group("npcInteract", "showInteraction", npcID, npcName)
				else:
					pass

func setItemInfo(itemName: String, itemTexture: Texture, usage: String):
	self.itemName = itemName
	self.itemTexture = itemTexture
	self.usage = usage

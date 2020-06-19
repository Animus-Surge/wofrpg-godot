extends Area2D

export (String) var itemName
export (Texture) var itemTexture
export (String) var usage

# warning-ignore:unused_signal
signal npcInteract
signal pickUpItem(iname, texture, usage)

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("pickUpItem", itemName, itemTexture, usage)
			get_parent().remove_child(self)

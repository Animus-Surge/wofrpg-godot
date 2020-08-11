extends TextureButton

var slotitem: Dictionary #Slot item is an itemdictionary

var isButtonDown = false

func _gui_input(event):
	if !isButtonDown:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == BUTTON_LEFT: #use the item
				isButtonDown = true
			elif event.pressed and event.button_index == BUTTON_RIGHT: #drop the item
				isButtonDown = true
				get_node("../../../..").call("removeItemFromInventory", slotitem, globalvars.REMOVE_REASONS.DROP)
		else:
			isButtonDown = false

func setItem(item):
	slotitem = item
	get_node("TextureRect").texture = load(item.get("texture"))
	isButtonDown = false

func clear():
	slotitem = {}
	get_node("TextureRect").texture = null
	isButtonDown = false

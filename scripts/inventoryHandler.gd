extends Node

var slots = Array()

func _ready():
	slots = get_children()
	for slot in slots:
		slot.removeItem()
		
func addItem(itemName : String, itemTexture : Texture):
	print("Adding item: " + itemName + " to the inventory")
	for slot in slots:
		if !slot.itemInSlot:
			slot.addItem(itemName, itemTexture)


func itemPickUp(args):
	print("Signal received")
	addItem(args[0], args[1])

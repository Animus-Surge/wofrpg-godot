extends Node

var slots = Array()

func _ready():
	slots = get_children()
	for slot in slots:
		slot.clear()
		
func add_item(itemName : String, itemTexture : Texture, itemUsage : String):
	for slot in slots:
		if !slot.itm:
			slot.addItem(itemName, itemTexture, itemUsage)
			return

func inventoryContains(itemName : String, itemTexture : Texture):
	for slot in slots:
		if slot.itm == itemName:
			if slot.txture == itemTexture:
				get_tree().call_group("npcInteract", "inventoryContains")
				slot.clear()

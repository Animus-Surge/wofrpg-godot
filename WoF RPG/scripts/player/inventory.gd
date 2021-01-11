extends Panel

onready var islot = preload("res://ui/invslot.tscn")

var numSlots = 20
var storedItems = []

func _ready():
	for x in range(numSlots):
		storedItems.append({})
		var slot = islot.instance()
		slot.slotid = x
		slot.connect("use", self, "_item_use")
		slot.connect("drop", self, "_item_drop")
		$ScrollContainer/GridContainer.add_child(slot)

func addItem(item) -> bool:
	for x in range(numSlots):
		if storedItems[x].empty():
			storedItems[x] = item
			$ScrollContainer/GridContainer.get_child(x).set_item(item)
			print("Stored an item")
			return true
	return false

func _item_use(slotid):
	print("Using an item from slot: " + String(slotid))

func _item_drop(slotid):
	print("Dropping an item from slot: " + String(slotid))

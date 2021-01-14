extends "res://scripts/entity/interactable.gd"

export(String, "ingot_gold", "ingot_iron", "gem_ruby", "gem_sapphire") var itemid = "gold" # USED FOR DEBUGGING ONLY
var storedItem

func _ready():
	for item in gvars.itemdict:
		if item.id == itemid:
			storedItem = item
			break
	$MeshInstance.mesh = load(storedItem.model)
	$MeshInstance.set("material/0", load(storedItem.material))
	if storedItem.has("offset"):
		$MeshInstance.translation = Vector3(storedItem.offset.x, storedItem.offset.y, storedItem.offset.z)
	if storedItem.has("size_offset"):
		$MeshInstance.scale = Vector3(storedItem.size_offset.x, storedItem.size_offset.y, storedItem.size_offset.z)
	TYPE = "item"
	display = storedItem.name

func _interacted():
	if get_parent().get_parent().get_node("CanvasLayer/Control/inventory").addItem(storedItem):
		queue_free()

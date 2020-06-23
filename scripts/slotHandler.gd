extends TextureRect

var itm
var txture
var usage

signal iteminfo(itemName, itemTexture, itemUsage)

func _init():
	itm = null
	
func addItem(itemName : String, itemSprite : Texture, itemUsage : String):
	itm = itemName
	txture = itemSprite
	get_node("Icon").texture = itemSprite
	usage = itemUsage

func clear():
	itm = null
	get_node("Icon").texture = null
	usage = null
	
func _gui_input(event):
	if itm:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_RIGHT and event.pressed:
				var interactableScript = preload("res://scripts/interactable.gd")
				var item = Area2D.new()
				var itemSprite = Sprite.new()
				var itemClickBounds = CollisionShape2D.new()
				var boundsShape = RectangleShape2D.new()
				
				boundsShape.extents = Vector2(17, 17)
				itemClickBounds.shape = boundsShape
				
				itemSprite.texture = txture
				
				item.add_child(itemSprite)
				item.add_child(itemClickBounds)
				
				item.set_script(interactableScript)
				
				connect("iteminfo", item, "setItemInfo")
				emit_signal("iteminfo", itm, txture, usage)
				disconnect("iteminfo", item, "setItemInfo")
				
				item.editor_description = "item"
				
				GVars.currentSceneRoot.get_node("items").add_child(item)
				clear()
			elif event.button_index == BUTTON_LEFT and event.pressed:
				parseUses()

func parseUses():
	var tokens = usage.split(" ")
	var function = tokens[0]
	tokens.remove(0)
	if function == "print":
		var args: String
		for word in tokens:
			if word == ";":
				break
			args = args + word + " "
		print(args)

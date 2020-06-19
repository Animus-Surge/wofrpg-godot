extends TextureRect

var item
var txture
var usage

func _init():
	item = null
	
func addItem(itemName : String, itemSprite : Texture, itemUsage : String):
	item = itemName
	txture = itemSprite
	get_node("Icon").texture = itemSprite
	usage = itemUsage
	print(usage)

func clear():
	item = null
	get_node("Icon").texture = null
	
func _gui_input(event):
	if item:
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
				item.itemName = item
				item.itemTexture = txture
				item.usage = usage
				
				GVars.currentSceneRoot.add_child(item)
				clear()
			elif event.button_index == BUTTON_LEFT and event.pressed:
				parseUses()

func parseUses():
	var tokens = usage.split(" ")
	var function = ""
	var args = ""
	for token in tokens:
		if function == "":
			if token == "print":
				function = "print"
			elif token == "end":
				pass
			elif token == ";":
				if function == "print":
					print(args)
				function = ""
				continue
		elif function == "print":
			args += token + " "
	print("Used an item")

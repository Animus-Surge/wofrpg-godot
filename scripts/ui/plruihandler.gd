extends Control

var invslots = []
var itemsininventory = []

var currentLevel
var xp
var mana
var hp

var levelupxp
var maxmana
var maxhp

func _ready():
	$pause.visible = false
	#$inventory.visible = false
	$npcinteraction.visible = false

func checkStats():
	if hp <= 0:
		pass #kill the player and take them to the respawn point
	if xp >= levelupxp:
		pass #level up the player and add two skill points to their skill point counter

func _unhandled_key_input(event):
	if event.scancode == KEY_ESCAPE and event.pressed:
		if globalvars.uiShowing:
			pass
		elif !globalvars.sppaused:
			$pause.visible = true
			globalvars.sppaused = true
		elif globalvars.sppaused:
			$pause.visible = false
			globalvars.sppaused = false
	elif event.scancode == KEY_E and event.pressed and not globalvars.sppaused:
		$inventory.visible = !$inventory.visible

func _button_input(action):
	if action == "resume":
		$pause.visible = false
		globalvars.sppaused = false
	elif action == "exit-mm":
		gfm.savegame(get_parent().get_global_position())
		scenes.load_scene("res://scenes/menus.tscn")
	elif action == "exit-ds":
		gfm.savegame(get_parent().get_global_position())
		get_tree().quit(0)

func addToInventory(item: Dictionary):
	itemsininventory.append(item)
	updateInventory()

func removeItemFromInventory(item: Dictionary, reason):
	if reason == globalvars.REMOVE_REASONS.DROP:
		pass #TODO: make item prefab and have the world handle creation of an item at player's feet
	elif reason == globalvars.REMOVE_REASONS.DIED:
		pass #same as above
	elif reason == globalvars.REMOVE_REASONS.QUEST:
		pass #update the quest
	itemsininventory.remove(itemsininventory.find(item))
	updateInventory()

func updateInventory():
	clearAllSlots()
	var slotidx = 0
	for item in itemsininventory:
		$inventory/ScrollContainer/GridContainer.get_child(slotidx).call("setItem", item)
		slotidx += 1

func clearAllSlots():
	for slot in invslots:
		slot.call("clear")

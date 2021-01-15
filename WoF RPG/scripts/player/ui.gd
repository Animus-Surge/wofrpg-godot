extends Control

var panelShowing = false

func _ready():
	$entityDetails.hide()
	$interactionPanel.hide()
	$inventory.hide()
	$skillTree.hide()

# Crosshair hover over object interaction dialogue

#Object will either be an NPC name, an item name, or nothing.
#Type will be either NPC or Item (for now)
func interact(type, object):
	match type:
		"npc":
			$crosshair/Label.text = "PRESS F TO INTERACT WITH " + object
		"item":
			$crosshair/Label.text = "PRESS F TO PICK UP " + object
		_:
			$crosshair/Label.text = ""

############################
# ENTITY INFORMATION PANEL #
############################

func showEntityInfo(node, data):
	if node == null: 
		$entityDetails.hide()
		return
	match node.TYPE:
		"enemy":
			$entityDetails.show()
			var hpt = String(data.hitpoints) + "/" + String(data.maxhitpoints)
			$entityDetails/Label.text = data.entityname
			$entityDetails/ProgressBar/Label.text = hpt
			$entityDetails/ProgressBar.max_value = data.maxhitpoints
			$entityDetails/ProgressBar.value = data.hitpoints
		"npc": #NPC hitpoints depend on a specific property. Storyline characters can't be killed, other NPCs can, but it affects reputation in whichever village/tribe you've killed the NPC.
			if node.npctype == "story":
				$entityDetails.show()
				#Show name and class
			elif node.npctype == "generic":
				$entityDetails.show()
				var hpt = String(node.hp)
				$entityDetails/Label.text = data.entityname
				$entityDetails/ProgressBar/Label.text = hpt
				$entityDetails/ProgressBar.max_value = data.maxhitpoints
				$entityDetails/ProgressBar.value = data.hitpoints
		"player":
			pass
		"damageable":
			$entityDetails.show()
			var hpt = String(node.hp)
			$entityDetails/Label.text = data.entityname
			$entityDetails/ProgressBar/Label.text = hpt
			$entityDetails/ProgressBar.max_value = data.maxhitpoints
			$entityDetails/ProgressBar.value = data.hitpoints
		_:
			$entityDetails.hide()

######################
# INTERACTION SYSTEM #
######################

var interactionShowing = false

#{"ename":String,"speech":String,"portrait":Path (unused currently, optional), "opts":[](Unused)}
func interaction(data: Dictionary):
	gvars.mouseCaptured = false
	interactionShowing = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$interactionPanel/ename.text = data.ename
	$interactionPanel/speech.text = data.speech
	$interactionPanel.show()

#######################
# SKILL TREE HANDLING #
#######################

var loadedSkilltree #Won't be set unless loading a save and on initial skill tree open

func skillTree():
	pass

#############
# CHAT #
#############

onready var chatmessage = preload("res://ui/chatcomponent.tscn")
var isChatting

func sendMessage():
	if isChatting:
		pass #TODO

#######################
# GLOBAL INPUT EVENTS #
#######################

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		if interactionShowing or panelShowing or isChatting:
			gvars.mouseCaptured = true
			interactionShowing = false
			panelShowing = false
			isChatting = false
			$chatpanel/chatline.text = ""
			$chatpanel/chatline.set_focus_mode(Control.FOCUS_NONE)
			$chatpanel/chatline.release_focus()
			$inventory.hide()
			$interactionPanel.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			gvars.paused = !gvars.paused
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if !gvars.paused else Input.MOUSE_MODE_VISIBLE)
			gvars.mouseCaptured = !gvars.paused
	elif Input.is_action_just_pressed("inventory"):
		if !interactionShowing and !panelShowing and !gvars.paused and !isChatting:
			panelShowing = true
			gvars.mouseCaptured = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$inventory.show()
		elif panelShowing:
			if $inventory.visible:
				$inventory.hide()
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				panelShowing = false
				gvars.mouseCaptured = true
#	elif Input.is_action_just_pressed("ui_chat"):
#		if isChatting: #Ignore it if the player is already using the chat
#			return
#		else:
#			isChatting = true
#			gvars.mouseCaptured = false
#			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#			$chatpanel/chatline.set_focus_mode(Control.FOCUS_ALL)
#			$chatpanel/chatline.grab_focus()
#			$chatpanel/chatline.text = ""
#	elif Input.is_action_just_pressed("ui_accept"):
#		if isChatting:
#			isChatting = false
#			$chatpanel/chatline.release_focus()
#			gvars.mouseCaptured = true
#			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#			$chatpanel/chatline.set_focus_mode(Control.FOCUS_NONE)
#			var message = chatmessage.instance()
#			message.get_node("message").text = $chatpanel/chatline.text
#			message.get_node("uname").text = "Kevin"
#			$chatpanel/chatscroll/chatcontainer.add_child(message)
#			$chatpanel/chatline.text = ""

func _process(_delta):
	if gvars.paused:
		$chatpanel/chatline.editable = false
	else:
		$chatpanel/chatline.editable = true

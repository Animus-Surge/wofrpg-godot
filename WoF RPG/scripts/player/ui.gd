extends Control

var panelShowing = false

func _ready():
	$entityDetails.hide()
	$interactionPanel.hide()
	$inventory.hide()
	$skillTree.hide()

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
# INVENTORY #
#############

# Moved to inventory.gd

#######################
# GLOBAL INPUT EVENTS #
#######################

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		if interactionShowing or panelShowing:
			gvars.mouseCaptured = true
			interactionShowing = false
			panelShowing = false
			$inventory.hide()
			$interactionPanel.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			gvars.paused = !gvars.paused
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if !gvars.paused else Input.MOUSE_MODE_VISIBLE)
			gvars.mouseCaptured = !gvars.paused
	elif Input.is_action_just_pressed("inventory"):
		if !interactionShowing and !panelShowing and !gvars.paused:
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

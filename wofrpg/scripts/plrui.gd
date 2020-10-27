extends Control

var uishowing = false

onready var font = preload("res://fonts/pixel.tres")

func _ready():
	$interaction.hide()

func quit():
	if get_tree().has_network_peer():
		get_tree().set_network_peer(null) #AKA: disconnect the player
	var gvars = get_tree().get_root().get_node("globalvars")
	gvars.load_scene("res://scenes/menus.tscn")
	gvars.paused = false

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ESCAPE:
			if uishowing:
				uishowing = false
				$interaction.hide()
			$pausemenu.visible = !$pausemenu.visible
			var gvars = get_tree().get_root().get_node("globalvars")
			gvars.paused = !gvars.paused

#######################
# INTERACTION HANDLER #
#######################

var metchars = [] #Will be saved in save data file

var interaction
var startAt: String
var currentPos: String

var npcid

var nevermet = false
var npcUseRandom = false

# warning-ignore:shadowed_variable
func initInteraction(npcid):
	npcUseRandom = false
	self.npcid = npcid
	if metchars.has(npcid):
		nevermet = false
	else:
		nevermet = true
		metchars.append(npcid)
	
	var ifile = File.new()
	var err = ifile.open("res://data/interactions/" + npcid + ".json", File.READ)
	assert(err == OK)
	
	var idata = JSON.parse(ifile.get_as_text()).result
	if startAt == "":
		onenter(idata.onEnter)
	if idata.has("interaction"):
		interaction = idata.interaction
		updateInteraction()
	elif idata.has("random") and npcUseRandom:
		interaction = idata.random
		randSpeech()

func randSpeech():
	randomize()
	var num = int(randf() * interaction.size())
	var ipos = interaction[num]
	$interaction/ibar/ScrollContainer/npcdialogue.text = ipos.text
	$interaction/face.texture = load("res://images/ui/interactions/" + npcid + "/reaction-" + ipos.face + ".png")

func updateInteraction():
	for btn in $interaction/ibar/opts/GridContainer.get_children(): btn.queue_free()
	
	if currentPos == "":
		assert(startAt != null)
		currentPos = startAt
		$interaction.show()
	
	var iposition = interaction[currentPos]
	
	$interaction/ibar/ScrollContainer/npcdialogue.text = iposition.text
	if iposition.animated:
		$interaction/face/AnimationPlayer.play(npcid + "-" + iposition.face)
	else:
		$interaction/face/AnimationPlayer.stop()
		$interaction/face.texture = load("res://images/ui/interactions/" + npcid + "/reaction-" + iposition.face + ".png")
	
	for opt in iposition.opts:
		var btn = Button.new()
		btn.set_script(load("res://scripts/ui/interactionopt.gd"))
		btn.set("goto", opt.goto)
		if opt.locked:
			if opt.unlockCondition.has("variable"):
				if get(opt.unlockCondition.variable.name) == opt.unlockCondition.variable.value:
					btn.text = opt.text
				else:
					btn.text = "[LOCKED]"
					btn.disabled = true
		else:
			btn.text = opt.text
		btn.set("custom_fonts/font", font)
		btn.flat = true
		btn.size_flags_horizontal = SIZE_EXPAND_FILL
		btn.set("custom_colors/font_color_hover", Color(0.66, 0.67, 0, 1))
		btn.set("custom_colors/font_color_pressed", Color(0.5, 0.44, 0, 1))
		btn.set("custom_colors/font_color", Color(0.36, 0.36, 0.36, 1))
		$interaction/ibar/opts/GridContainer.add_child(btn)

func ibtnPress(to):
	assert(to != "")
	if to == "%CLOSE":
		$interaction.hide()
	elif to.begins_with("%IT"): # Format: %IT:iw-siw-wolf_surge:begood
		$interaction.hide() #TODO
	elif to.begins_with("%QUEST"):
		$interaction.hide() #TODO
	elif to.begins_with("%UPDATE"):
		$interaction.hide() #TODO
	else:
		currentPos = to
		updateInteraction()

func onenter(data):
	$interaction/ibar/npcname.text = data.cname
	$interaction/ibar.texture = load("res://images/ui/interactions/" + npcid + "/interaction-bar.png")
	for pos in data.positions:
		var canStartHere = true
		for condition in pos.conditions:
			if condition.has("variable"):
				if get(condition.variable.name) == condition.variable.value:
					continue
				else:
					canStartHere = false
		if canStartHere:
			if pos.lcname == "random":
				npcUseRandom = true
			startAt = pos.lcname
			break

func _on_interaction_visibility_changed():
	if !$interaction.visible:
		interaction = {}
		startAt = ""
		currentPos = ""

####################
# INVENTORY SYSTEM #
####################

#TODO

###############
# SHOP SYSTEM #
###############

#TODO

extends Control

var uishowing = false

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

func initInteraction(npcid):
	npcid = npcid
	if metchars.has(npcid):
		nevermet = false
	else:
		nevermet = true
		metchars.append(npcid)
	
	var ifile = File.new()
	var err = ifile.open("res://data/interactions/" + npcid)
	assert(err == OK)
	
	var idata = JSON.parse(ifile.get_as_text()).result
	onenter(idata.onEnter)
	if idata.has("interaction"):
		interaction = idata.interaction
		updateInteraction()
	elif idata.has("random"):
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
	if iposition.faceAnimated:
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
		$interaction/ibar/opts/GridContainer.add_child(btn)

func ibtnPress(to):
	assert(to != "")
	if to == "%CLOSE":
		$interaction.hide()
	
	else:
		currentPos = to
		updateInteraction()

func onenter(data):
	$interaction/ibar/npcname.text = data.cname
	$interaction/ibar.texture = load("res://images/ui/interactions/" + npcid + "/interaction-bar.png")
	if data.has("positions"):
		pass

func _on_interaction_visibility_changed():
	if !$interaction.visible:
		interaction = {}
		startAt = ""
		currentPos = ""

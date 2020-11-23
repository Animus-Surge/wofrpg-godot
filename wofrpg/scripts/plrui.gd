extends Control

var uishowing = false
var chatfocus = false

onready var font = preload("res://fonts/pixel.tres")

func _ready():
# warning-ignore:return_value_discarded
	State.connect("chatMessage", self, "showChatMessage")
	$interaction.hide()
	$quest_taskpanel.hide()
	$inventory.hide()
	initInventory()

func quit():
	if get_tree().has_network_peer():
		get_tree().set_network_peer(null) #AKA: disconnect the player
	gvars.load_scene("res://scenes/menus.tscn")
	gvars.paused = false
	uishowing = false

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ESCAPE:
			if uishowing:
				uishowing = false
				$interaction.hide()
				$chatpanel/LineEdit.release_focus()
				$chatpanel/LineEdit.text = ""
				return
			else:
				$pausemenu.visible = !$pausemenu.visible
				gvars.paused = !gvars.paused
		if event.scancode == KEY_E:
			if !uishowing:
				$inventory.visible = !$inventory.visible
		if event.scancode == KEY_ENTER:
			if chatfocus and $chatpanel/LineEdit.text.strip_edges() != "":
				State.sendChatMessage($chatpanel/LineEdit.text.strip_edges())
				$chatpanel/LineEdit.release_focus()
				$chatpanel/LineEdit.text = ""
		if event.scancode == KEY_TAB:
			if !chatfocus:
				$chatpanel/LineEdit.grab_focus()

func _process(_delta):
	gvars.uiShowing = uishowing

#######################
# INTERACTION HANDLER #
#######################

var metchars = [] #Will be saved in save data file

var interaction
var startAt: String
var currentPos: String

var npcid
var characterName

var nevermet = false
var npcUseRandom = false

# warning-ignore:shadowed_variable
func initInteraction(npcid, cname):
	characterName = cname
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
	uishowing = true
	gvars.paused = true
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
					btn.text = opt.text.format({"name":characterName})
				else:
					btn.text = "[LOCKED]"
					btn.disabled = true
		else:
			btn.text = opt.text.format({"name":characterName})
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
		initQuest(to.split(":")[1])
		$interaction.hide()
	elif to.begins_with("%UPDATE"):
		questUpdate()
		$interaction.hide()
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
					break
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
		npcid = ""
		uishowing = false
		gvars.paused = false

###################
# QUESTING SYSTEM #
###################

var currentQuest: Dictionary
var cqname: String = ""
var part = 0
var cqpart: Dictionary

func initQuest(questName):
	part = 0
	var qfile = File.new()
	var err = qfile.open("res://data/quests/quest_" + questName + ".json", File.READ)
	if err != OK:
		pass #TODO: fullscreen dialogue
		return
	cqname = questName
	currentQuest = JSON.parse(qfile.get_as_text()).result
	cqpart = {}
	questUpdate()
	$quest_taskpanel.show()

func questUpdate():
	if cqpart.empty():
		cqpart = currentQuest.questParts[part]
		$quest_taskpanel/Label.text = cqpart.name
		return
	if !cqpart.onTaskComplete.empty():
		if cqpart.onTaskComplete.has("run"):
			match cqpart.onTaskComplete.run:
				"COMPLETE":
					qcomp()
					return
		elif cqpart.onTaskComplete.has("variable"):
			set(cqpart.onTaskComplete.variable.name, cqpart.onTaskComplete.variable.value)
	part += 1
	cqpart = {}
	questUpdate() #Calls itself to update the data

#Quest helper functions

func qcomp():
	var onQC = currentQuest.onCompleted
	part = 0
	cqpart = {}
	currentQuest = {}
	
	if onQC.has("add"):
		pass
	elif onQC.has("run"):
		pass
	$quest_taskpanel.hide()

####################
# INVENTORY SYSTEM #
####################

var inventory = []

onready var itemslot = preload("res://objects/ui/slot.tscn")

export(int) var slot_count = 20

func initInventory():
	for x in range(slot_count):
		var slot = itemslot.instance()
		slot.slotnum = x
		slot.connect("use", self, "itemUse")
		slot.connect("drop", self, "itemDrop")
		slot.clearSlot()
		$inventory/scroll/GridContainer.add_child(slot)

func updateInventory():
	for slot in $inventory/scroll/GridContainer:
		slot.clearSlot()
	inventory.sort_custom(gvars.Sorter, "itemsort_alphabetical")
	
	for x in range(inventory.size()):
		$inventory/scroll/GridContainer.get_child(x).setItem(inventory[x])

func addItem(item):
	inventory.append(item)
	updateInventory()

func removeItem(item):
	inventory.remove(inventory.find(item))
	updateInventory()

func itemDrop(item, _slot):
	removeItem(item)

func itemUse(item, _slot):
	if item.onUse.has("call"):
		if item.onUse.call.begins_with("print"):
			logcat.stdout(item.onUse.call.split(":")[1], logcat.DEBUG)

#TODO

###############
# SHOP SYSTEM #
###############

#TODO

###############
# CHAT SYSTEM #
###############

func chatFocus():
	print("Chat Gained Focus")
	uishowing = true
	chatfocus = true

func chatFocusLost():
	uishowing = false
	chatfocus = false
	print("Chat Lost Focus")

func showChatMessage(sender, message):
	var completemessage = ""
	if sender == gvars.username:
		completemessage = "[color=#0ff]" + sender + "[/color]: "
	else:
		completemessage = sender + ": "
	completemessage += message
	logcat.stdout("CHAT APPENDED TO: " + message + " FROM " + sender, logcat.DEBUG)
	$chatpanel/RichTextLabel.append_bbcode(completemessage + "\n")

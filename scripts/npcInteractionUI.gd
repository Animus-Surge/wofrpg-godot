extends Panel

var questActive = false
var questCompleted = false

var requires = false

var dialogue : Dictionary
var diaBase
var section
var basenum

func _ready():
	visible = false

func showInteraction(npcid, npcname):
	basenum = 1
	dialogue = GVars.dialogueData["dialogues"].get(npcid)
	get_node("Label").text = npcname
	diaBase = dialogue.get("base-1")
	section = diaBase
	updateUI()
	
	visible = true
	get_tree().paused = true

func showQuestInteraction(npcid, npcname):
	pass

func buttonPress(goto):
	if goto is Dictionary:
		var sidequest = goto.get("squestID")
		GVars.loadSideQuest(sidequest)
		visible = false
		get_tree().paused = false
	else:
		if goto == "exit":
			visible = false
			get_tree().paused = false
		elif goto == "base+":
			basenum+=1
			diaBase = dialogue.get("base-" + String(basenum))
			section = diaBase
			updateUI()
		elif goto == "o1":
			section = diaBase.get("o1")
			updateUI()
		elif goto == "o2":
			section = diaBase.get("o2")
			updateUI()
		elif goto == "o3":
			section = diaBase.get("o3")
			updateUI()
		elif goto == "base++":
			basenum += 2
			diaBase = dialogue.get("base-" + String(basenum))
			section = diaBase
			updateUI()

func updateUI():
	get_node("Button").visible = true
	get_node("Button2").visible = true
	get_node("Button3").visible = true
	
	get_node("Label2").text = section.get("main")
	if section.get("opt1") != null:
		if section.get("opt1").locked:
			get_node("Button").text = "[LOCKED]"
			get_node("Button").disabled = true
		else:
			get_node("Button").text = section.get("opt1").get("text")
			get_node("Button").setGoto(section.get("opt1").get("goto"))
			get_node("Button").disabled = false
	else: get_node("Button").visible = false
	if section.get("opt2") != null:
		if section.get("opt2").locked:
			get_node("Button2").text = "[LOCKED]"
			get_node("Button2").disabled = true
		else:
			get_node("Button2").text = section.get("opt2").get("text")
			get_node("Button2").setGoto(section.get("opt2").get("goto"))
			get_node("Button2").disabled = false
	else: get_node("Button2").visible = false
	if section.get("opt3") != null:
		if section.get("opt3").locked:
			get_node("Button3").text = "[LOCKED]"
			get_node("Button3").disabled = true
		else:
			get_node("Button3").text = section.get("opt3").get("text")
			get_node("Button3").setGoto(section.get("opt3").get("goto"))
			get_node("Button3").disabled = false
	else: get_node("Button3").visible = false

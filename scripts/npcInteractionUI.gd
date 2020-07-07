extends Control

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
	get_node("TextureRect2/Label").text = npcname
	diaBase = dialogue.get("base-1")
	section = diaBase
	
	get_node("TextureRect2").texture = load("res://images/ui/interactions/" + dialogue.get("npc") + "/interaction-bar.png")
	if dialogue.get("npc") == "iw-siw-wolf_surge":
		get_node("TextureRect2/Label").set("custom_colors/font_color", Color.black)
		get_node("TextureRect2/Label2").set("custom_colors/font_color", Color.black)
		get_node("TextureRect2/Button").set("custom_colors/font_color", Color.black)
		get_node("TextureRect2/Button2").set("custom_colors/font_color", Color.black)
		get_node("TextureRect2/Button3").set("custom_colors/font_color", Color.black)
		get_node("TextureRect2/Button4").set("custom_colors/font_color", Color.black)
	else:
		get_node("TextureRect2/Label").set("custom_colors/font_color", Color.white)
		get_node("TextureRect2/Label2").set("custom_colors/font_color", Color.white)
		get_node("TextureRect2/Button").set("custom_colors/font_color", Color.white)
		get_node("TextureRect2/Button2").set("custom_colors/font_color", Color.white)
		get_node("TextureRect2/Button3").set("custom_colors/font_color", Color.white)
		get_node("TextureRect2/Button4").set("custom_colors/font_color", Color.white)
	
	updateUI()
	
	get_tree().paused = true
	visible = true

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
		elif goto == "o4":
			section = diaBase.get("o4")
			updateUI()
		elif goto == "o5":
			section = diaBase.get("o5")
			updateUI()
		elif goto == "o6":
			section = diaBase.get("o6")
			updateUI()
		elif goto == "base++":
			basenum += 2
			diaBase = dialogue.get("base-" + String(basenum))
			section = diaBase
			updateUI()

func updateUI():
	get_node("TextureRect2/Button").visible = true
	get_node("TextureRect2/Button2").visible = true
	get_node("TextureRect2/Button3").visible = true
	
	if get_node("extras").is_playing():
		get_node("extras").stop()
	
	if section.get("reaction") != "anim":
		get_node("TextureRect").texture = load("res://images/ui/interactions/" + dialogue.get("npc") + "/reaction-" + section.get("reaction") + ".png")
	else:
		var anim = dialogue.get("npc") + "-" + section.get("anim")
		get_node("extras").play(anim)
		
	get_node("TextureRect2/Label2").text = section.get("main")
	if section.get("opt1") != null:
		if section.get("opt1").locked:
			get_node("TextureRect2/Button").text = "[LOCKED]"
			get_node("TextureRect2/Button").disabled = true
		else:
			get_node("TextureRect2/Button").text = section.get("opt1").get("text")
			get_node("TextureRect2/Button").setGoto(section.get("opt1").get("goto"))
			get_node("TextureRect2/Button").disabled = false
	else: get_node("TextureRect2/Button").visible = false
	if section.get("opt2") != null:
		if section.get("opt2").locked:
			get_node("TextureRect2/Button2").text = "[LOCKED]"
			get_node("TextureRect2/Button2").disabled = true
		else:
			get_node("TextureRect2/Button2").text = section.get("opt2").get("text")
			get_node("TextureRect2/Button2").setGoto(section.get("opt2").get("goto"))
			get_node("TextureRect2/Button2").disabled = false
	else: get_node("TextureRect2/Button2").visible = false
	if section.get("opt3") != null:
		if section.get("opt3").locked:
			get_node("TextureRect2/Button3").text = "[LOCKED]"
			get_node("TextureRect2/Button3").disabled = true
		else:
			get_node("TextureRect2/Button3").text = section.get("opt3").get("text")
			get_node("TextureRect2/Button3").setGoto(section.get("opt3").get("goto"))
			get_node("TextureRect2/Button3").disabled = false
	else: get_node("TextureRect2/Button3").visible = false
	if section.get("opt4") != null:
		if section.get("opt4").locked:
			get_node("TextureRect2/Button4").text = "[LOCKED]"
			get_node("TextureRect2/Button4").disabled = true
		else:
			get_node("TextureRect2/Button4").text = section.get("opt3").get("text")
			get_node("TextureRect2/Button4").setGoto(section.get("opt3").get("goto"))
			get_node("TextureRect2/Button4").disabled = false
	else: get_node("TextureRect2/Button4").visible = false

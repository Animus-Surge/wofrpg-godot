extends Panel

var currentDialogue: Dictionary

var part: Dictionary

var npcid

func loadDialogue(npcid, npcname):
	$ibar/namelabel.text = npcname
	
	$ibar.texture = load("res://images/ui/interactions/" + npcid + "/interaction-bar.png")
	logcat.stdout("Loading NPC interaction: " + npcid, logcat.INFO)
	self.npcid = npcid
	
	var dialogue = File.new()
	if !dialogue.file_exists("user://saves/" + globalvars.save + "/data/dialogues/" + npcid + ".json"):
		logcat.stdout("Dialogue data file: " + npcid + ".json does not exist. Creating from resource...", logcat.WARNING)
		var dir = Directory.new()
		dir.copy("res://data/" + npcid + ".json", "user://saves/" + globalvars.save + "/data/dialogues/" + npcid + ".json")
	dialogue.open("user://saves/" + globalvars.save + "/data/dialogues/" + npcid + ".json", File.READ)
	currentDialogue = JSON.parse(dialogue.get_as_text()).result
	
	part = currentDialogue.dialogues.start
	
	globalvars.uiShowing = true
	show()
	
	showPart()

func showPart():
	var index = 2
	while index < 6:
		$ibar.get_child(index).show()
		index += 1
	index = 2
	
	if part.has("anim"):
		if part.anim:
			$animatedInteractions.play(npcid + "-" + part.reaction)
	else:
		$animatedInteractions.stop()
		$reaction.texture = load("res://images/ui/interactions/" + npcid + "/reaction-" + part.reaction + ".png")
	
	for option in part.opts:
		if option.locked:
			$ibar.get_child(index).text = "[LOCKED]"
			$ibar.get_child(index).disabled = true
		else:
			$ibar.get_child(index).call("setGoto", option.goto)
			var formattedText = option.text.format({"plr":spgs.charname})
			$ibar.get_child(index).text = formattedText
		index += 1
	
	while index < 6:
		$ibar.get_child(index).hide()
		index += 1
	
	$ibar/speechlabel.text = part.text

func buttonPress(goto: String):
	if goto == "exit":
		globalvars.uiShowing = false
		hide()
		return
	part = currentDialogue.dialogues.get(goto)
	showPart()

extends Panel

var questList = []
var descList = []
var indexSelected

var currentQuest

func _ready():
	visible = false

func showUI():
	
	get_node("Label2").text = ""
	
	for quest in GVars.questData["quests"]:
		questList.append(GVars.questData["quests"].get(quest))
	
	for quest in questList:
		if !quest.get("locked") and !quest.get("completed"):
			get_node("ScrollContainer/VBoxContainer/ItemList").add_item(quest.get("name"))
			descList.append(quest.get("desc"))
	
	get_tree().paused = true
	visible = true

func _close():
	visible = false
	get_tree().paused = false
	indexSelected = null
	get_node("Button2").disabled = true
	questList.clear()
	get_node("ScrollContainer/VBoxContainer/ItemList").clear()

func _quest_selected(index):
	indexSelected = index
	get_node("Label2").text = descList[index]
	get_node("Button2").disabled = false

func _acceptQuest():
	if !GVars.hasQuest:
		currentQuest = questList[indexSelected]
		GVars.hasQuest = true
		GVars.currentQuest = currentQuest
		get_tree().call_group("questingUI", "displayQuestOnHud", questList[indexSelected].get("name"), questList[indexSelected].get("tasks").get("task-1").get("title"))
		_close()
	else:
		pass

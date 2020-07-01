extends Panel

var currentTask = {}

func _ready():
	visible = false

func displayQuestOnHud(quest, task):
	currentTask = task
	get_node("title").text = quest
	get_node("currentTask").text = currentTask.title
	visible = true

func _update(task):
	get_node("currentTask").text = task.get("title")

func questComplete():
	get_node("title").text = ""
	visible = false
	GVars.questData["quests"].get(GVars.currentQuest).completed = true
	GVars.currentQuest.clear()

# TODO: make this thing be able to show a list of tasks regarding the current
# quest. Also make it so you can have up to three side quests not related to
# the current quest

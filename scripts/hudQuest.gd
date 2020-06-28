extends Panel

var parts: Array
var qname: String

func _ready():
	visible = false

func displayQuestOnHud(quest, task):
	get_node("title").text = quest
	get_node("currentTask").text = task
	visible = true

func _update(task):
	get_node("currentTask").text = task.get("title")

func questComplete():
	get_node("title").text = ""
	visible = false

# TODO: make this thing be able to show a list of tasks regarding the current
# quest. Also make it so you can have up to three side quests not related to
# the current quest

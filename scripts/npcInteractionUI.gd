extends Panel

var questActive = false
var questCompleted = false

var requires = false

var npcname
var questip
var questcomplete
var questdesc
var requiresTexture : Texture
var requiresName
var confirm
var decline

func _ready():
	visible = false

func showInteraction(args : Array):
	npcname = args[0]
	questdesc = args[1]
	questip = args[2]
	questcomplete = args[3]
	requiresName = args[4]
	requiresTexture = args[5]
	confirm = args[6]
	decline = args[7]
	get_node("Label").text = npcname
	visible = true
	get_tree().paused = true
	requires = false
	if questActive and !questCompleted:
		get_tree().call_group("inventorySys", "inventoryContains", requiresName, requiresTexture)
		if !requires:
			get_node("Label2").text = questip
			get_node("Button").text = "Close"
		get_node("Button2").visible = false
	elif questCompleted:
		get_node("Label2").text = "Oi lad... back for more?" #todo
		get_node("Button").text = "Close"
		get_node("Button2").visible = false
	elif !questActive and !questCompleted:
		get_node("Label2").text = questdesc
		get_node("Button").text = "Accept"
		get_node("Button2").text = "Decline"
	
	get_node("Button3").visible = false
	get_node("Button4").visible = false
	
func confirm():
	get_node("Button2").visible = false
	get_node("Button").text = "Close"
	get_node("Label2").text = confirm
	questActive = true

func decline():
	get_node("Button2").visible = false
	get_node("Button").text = "Close"
	get_node("Label2").text = decline

func inventoryContains():
	requires = true
	get_node("Label2").text = questcomplete
	questActive = false
	questCompleted = true
	get_node("Button").text = "Close"

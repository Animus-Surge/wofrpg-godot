extends Control

onready var test = get_tree().get_root().get_node("Test")

var interactionShowing = false

func _ready():
	$interaction.hide()

func quit():
	var gvars = get_tree().get_root().get_node("globalvars")
	if !is_instance_valid(test):
		gvars.load_scene("res://scenes/menus.tscn")
		gvars.paused = false
	else:
		if test.testscenes and gvars.debug:
			get_tree().quit(0)
		else: #TODO: make this better
			#print("blah")
			gvars.load_scene("res://scenes/menus.tscn")
			gvars.paused = false

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ESCAPE:
			if interactionShowing:
				interactionShowing = false
				hideInteraction()
				return
			$pausemenu.visible = !$pausemenu.visible
			var gvars = get_tree().get_root().get_node("globalvars")
			gvars.paused = !gvars.paused

func hideInteraction():
	$interaction.hide()
	get_node("/root/globalvars").paused = false

func showInteraction(data, npcid):
	var gvars = get_tree().get_root().get_node("globalvars")
	gvars.paused = true
	$interaction/face.texture = load("res://images/ui/interactions/" + npcid + "/reaction-" + data.interaction.start.face + ".png")
	$interaction/ibar.texture = load("res://images/ui/interactions/" + npcid + "/interaction-bar.png")
	$interaction.show()
	interactionShowing = true
	$interaction/ibar/ScrollContainer/npcdialogue.text = data.interaction["start"].text
	$interaction/ibar/npcname.text = data.cname

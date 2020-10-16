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

#Interaction Handler

func hideInteraction():
	$interaction/face/AnimationPlayer.stop()
	$interaction.hide()
	get_node("/root/globalvars").paused = false

var cpart: Dictionary
var cpartid: String
var interaction: Dictionary
var interactionid: String

func showInteraction(data, npcid):
	interactionid = npcid
	interaction = data.interaction
	$interaction/ibar/npcname.text = data.cname
	var gvars = get_tree().get_root().get_node("globalvars")
	gvars.paused = true
	$interaction/ibar.texture = load("res://images/ui/interactions/" + npcid + "/interaction-bar.png")
	$interaction.show()
	interactionShowing = true
	ipart("start") #TODO: quest handlers

func ipart(id):
	$interaction/face/AnimationPlayer.stop()
	for opt in $interaction/ibar/opts/GridContainer.get_children():
		opt.queue_free()
	cpartid = id;
	cpart = interaction[id]
	if cpart.faceAnimated:
		$interaction/face/AnimationPlayer.play(interactionid + "-" + cpart.face)
	else:
		$interaction/face.texture = load("res://images/ui/interactions/" + interactionid + "/reaction-" + cpart.face + ".png")
	$interaction/ibar/ScrollContainer/npcdialogue.text = cpart.text
	for opt in cpart.opts:
		var btn = Button.new()
		btn.flat = true
		btn.set("custom_fonts/font", load("res://fonts/pixel.tres"))
		btn.enabled_focus_mode = Control.FOCUS_NONE
		if !opt.locked:
			btn.text = opt.text
		else:
			btn.text = "[LOCKED]"
		btn.set_script(load("res://scripts/ui/interactionopt.gd"))
		btn.locked = opt.locked
		btn.goto = opt.goto
		btn.set("custom_colors/font_color_hover", Color(0.66, 0.67, 0, 1))
		btn.set("custom_colors/font_color_pressed", Color(0.5, 0.44	, 0, 1))
		btn.set("custom_colors/font_color", Color(0.36, 0.36, 0.36, 1))
		btn.connect("optClicked", self, "buttonPress")
		$interaction/ibar/opts/GridContainer.add_child(btn)

func buttonPress(goto: String):
	if goto.find("%QUEST:") != -1:
		pass
	match goto:
		"%CLOSE":
			hideInteraction()
		_:
			ipart(goto)

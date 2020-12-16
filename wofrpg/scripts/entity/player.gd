extends KinematicBody2D

# Player Constants
const type = "PLAYER"
const MOVEMENT_SPEED = 750


puppet var vel = Vector2.ZERO
puppet var pos = Vector2()

signal interact()
# warning-ignore:unused_signal
signal checkThere()

signal readyToShow()

#custom character variables
puppet var usecc = false #if set to true hides all but the body graphic and disables colormasks

var charname
var username

var pal

var customScale: Vector2

var cframes

func _input(event):
	pass #TODO: revamp this so it's configurable

#Frames used when custom character is neccessary
func updateDetails(data, _palette, _frames = null):
	if !get_tree().has_network_peer() or is_network_master():
		data = gvars.plrdata
		_palette = gvars.plrpalette
	
	setplrdetails(data, _palette)
	emit_signal("readyToShow")

func setplrdetails(data: Dictionary, palette):
	pass

func nextFrame():
	pass # Replace with function body.

func _physics_process(_delta):
	pass

func animation():
	
	if vel == Vector2.ZERO: #idle
		if !usecc:
			pass
	else: #run/trot
		if !usecc:
			pass

func interacted(npcid, cname):
	get_parent().get_parent().get_node("CanvasLayer/UI").initInteraction(npcid, cname)

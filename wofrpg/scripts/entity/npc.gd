extends KinematicBody2D

export (SpriteFrames) var frames
export (String) var npcid

export(String) var npcname

export (float) var resize = 1

export(bool)var flipped = false

var inboundsPlayer
var hidden = false

const type = "NPC"

onready var gvars = get_tree().get_root().get_node("globalvars")

func check():
	if get_parent().get_node("player").charname == npcname:
		print("Hiding NPC: " + npcname)
		hidden = true
		hide()

func _ready():
# warning-ignore:return_value_discarded
	get_parent().get_node("player").connect("checkThere", self, "check")
	scale = Vector2(resize, resize)
	$appearance.play()
	$Label.hide()

func _physics_process(_delta):
	if gvars.paused:
		$appearance.stop()
	else:
		$appearance.play()
	
	if flipped:
		$appearance.flip_h = true
		$CollisionShape2D.disabled = true
		$CollisionShape2D2.disabled = false
	else:
		$appearance.flip_h = false
		$CollisionShape2D.disabled = false
		$CollisionShape2D2.disabled = true

func _on_Area2D_body_entered(body):
	if body.type == "PLAYER":
		body.connect("interact", self, "playerInteract")
		$Label.show()
		inboundsPlayer = body

func _on_Area2D_body_exited(body):
	if body.type == "PLAYER":
		body.disconnect("interact", self, "playerInteract")
		$Label.hide()
		inboundsPlayer = null

func playerInteract():
	if !hidden:
		inboundsPlayer.call("interacted", npcid)

extends KinematicBody2D

export (SpriteFrames) var frames
export (String) var npcid

export (float) var resize = 1

export(bool)var flipped = false

var inboundsPlayer

const type = "NPC"

onready var gvars = get_tree().get_root().get_node("globalvars")

func _ready():
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
	inboundsPlayer.call("interacted", npcid)

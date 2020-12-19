extends KinematicBody2D

const SPEED = 300

#multiplayer variables
puppet var vel = Vector2.ZERO
puppet var pos = Vector2()

func _ready():
	if gvars.DEBUG or !get_tree().has_network_peer() or is_network_master():
		$Camera2D.current = true

func _physics_process(_delta):
	var vect = Vector2()
	vect.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vect.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	vel = vect.normalized()
	vel = move_and_slide(vel * SPEED)
	anim()

func anim():
	if vel.x > 0:
		$graphics/flip.hide()
		$graphics/nonflip.show()
	elif vel.x < 0:
		$graphics/flip.show()
		$graphics/nonflip.hide()

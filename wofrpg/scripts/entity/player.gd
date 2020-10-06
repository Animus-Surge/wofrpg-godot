extends KinematicBody2D

const MOVEMENT_SPEED = 300

var vel = Vector2.ZERO

func _ready():
	pass #todo: color handling

func _physics_process(delta):
	var vect = Vector2()
	vect.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vect.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if vect.x > 0:
		for x in range(6):
			$graphics.get_child(x).flip_h = false
	elif vect.x < 0:
		for x in range(6):
			$graphics.get_child(x).flip_h = true
	
	if vect == Vector2.ZERO:
		$graphics/AnimationPlayer.play("test-idle")
	else:
		pass
	
	vel = vect.normalized() * MOVEMENT_SPEED
	
	vel = move_and_slide(vel)

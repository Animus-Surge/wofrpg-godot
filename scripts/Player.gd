extends KinematicBody2D

export (float) var maxSpeed = 100
export (float) var friction = 10

var vel = Vector2.ZERO

func _physics_process(delta):
	var vect = Vector2.ZERO
	vect.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vect.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	vect = vect.normalized()
	if vect != Vector2.ZERO:
		vel = vel.move_toward(vect * maxSpeed, friction * delta)
	else:
		vel = vel.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide(vel)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			print("Attacking")

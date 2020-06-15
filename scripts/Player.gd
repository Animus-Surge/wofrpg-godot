extends KinematicBody2D

export (float) var maxSpeed = 100
export (float) var friction = 10

var vel = Vector2.ZERO

func _ready():
	var colA = GVars.plrA
	var colB = GVars.plrB
	var colC = GVars.plrC
	var colD = GVars.plrD
	
	get_child(0).self_modulate = colA
	get_child(1).self_modulate = colA
	get_child(2).self_modulate = colB
	get_child(3).self_modulate = colC
	get_child(4).self_modulate = colD
	
	get_child(0).play("idle-body")
	get_child(1).play("idle-body-shadow")
	get_child(2).play("idle-wings")
	get_child(3).play("idle-horns")
	get_child(4).play("idle-eyes")
	
	get_child(0).playing = true
	get_child(1).playing = true
	get_child(2).playing = true
	get_child(3).playing = true
	get_child(4).playing = true

func _physics_process(delta):
	var vect = Vector2.ZERO
	vect.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vect.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if vect.x < 0:
		get_child(0).flip_h = true
		get_child(1).flip_h = true
		get_child(2).flip_h = true
		get_child(3).flip_h = true
		get_child(4).flip_h = true
	elif vect.x > 0:
		get_child(0).flip_h = false
		get_child(1).flip_h = false
		get_child(2).flip_h = false
		get_child(3).flip_h = false
		get_child(4).flip_h = false
	
	vect = vect.normalized()
	if vect != Vector2.ZERO:
		vel = vel.move_toward(vect * maxSpeed, friction * delta)
		get_child(0).play("run-body")
		get_child(1).play("run-body-shadow")
		get_child(2).play("run-wings")
		get_child(3).play("run-horns")
		get_child(4).play("run-eyes")
	else:
		vel = vel.move_toward(Vector2.ZERO, friction * delta)
		get_child(0).play("idle-body")
		get_child(1).play("idle-body-shadow")
		get_child(2).play("idle-wings")
		get_child(3).play("idle-horns")
		get_child(4).play("idle-eyes")
	
	move_and_slide(vel)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			print("Attacking") #play the attack animation (tail attack)

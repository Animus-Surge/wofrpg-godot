extends KinematicBody2D

const speed = 2000
const friction = 3250

var vel: Vector2

var flipped = false

func _ready():
	pass

func _physics_process(delta):
	if !globalvars.sppaused:
		var vect = Vector2.ZERO
		vect.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		vect.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
		vect = vect.normalized()
		
		if vect.x > 0:
			flipped = false
		elif vect.x < 0:
			flipped = true
		
		if vect != Vector2.ZERO:
			vel = vel.move_toward(vect * speed, friction * delta)
			animation("run")
		else:
			vel = vel.move_toward(Vector2.ZERO, friction * delta)
			animation("idle")
		
		vel = move_and_slide(vel)
	else:
		$AnimationPlayer.stop()

func animation(anim:String):
	if flipped:
		$flip.visible = true
		$reg.visible = false
	else:
		$flip.visible = false
		$reg.visible = true
	
	if anim == "idle":
		$AnimationPlayer.play("idle-plr")
	elif anim == "run":
		$AnimationPlayer.play("run-plr")

extends KinematicBody2D

const speed = 300

var velocity: Vector2

puppet var pupvel: Vector2
puppet var puploc: Vector2
puppet var flipped = false

func _ready():
	pass

func _physics_process(delta):
	if is_network_master():
		if !gvars.clipaused:
			var vel = Vector2.ZERO
			vel.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			vel.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			
			velocity = vel.normalized() * speed
			
			rset_unreliable("puploc", position)
			rset_unreliable("pupvel", velocity)
	else:
		position = puploc
		velocity = pupvel
	
	if velocity.x > 0:
		flipped = true
	elif velocity.x < 0:
		flipped = false
	
	if velocity != Vector2.ZERO:
		$AnimationPlayer.play("run-plr")
	else:
		$AnimationPlayer.play("idle-plr")
	
	if flipped:
		$flip.visible = true
		$reg.visible = false
	else:
		$flip.visible = false
		$reg.visible = true
	
	velocity = move_and_slide(velocity * delta)
	
	if not is_network_master():
		puploc = position

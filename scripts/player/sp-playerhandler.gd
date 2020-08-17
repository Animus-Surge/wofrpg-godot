extends KinematicBody2D

const speed = 1200
const friction = 3250

var fireball = preload("res://objects/projectile/fireball.tscn")

var vel: Vector2

var flipped = false

var fbcooldown = false

func _ready():
	if !globalvars.debug:
		get_node("reg/body").modulate = spgs.body
		get_node("reg/bodys").modulate = spgs.body
		get_node("reg/wings").modulate = spgs.wings
		get_node("reg/horns").modulate = spgs.horns
		get_node("reg/eyes").modulate = spgs.eyes
		
		get_node("flip/body").modulate = spgs.body
		get_node("flip/bodys").modulate = spgs.body
		get_node("flip/wings").modulate = spgs.wings
		get_node("flip/horns").modulate = spgs.horns
		get_node("flip/eyes").modulate = spgs.eyes
		
		position = spgs.pos
		
		print("Loaded character colors")

func _unhandled_input(event):
	if event is InputEventMouseButton and not globalvars.sppaused and not globalvars.uiShowing:
		if event.pressed and event.button_index == BUTTON_RIGHT and not fbcooldown:
			get_node("Timer").wait_time = 0.5
			get_node("Timer").start()
			fbcooldown = true
			get_tree().call_group("projectilehandler", "summonFireball")

func _physics_process(delta):
	if !globalvars.sppaused and !globalvars.uiShowing:
		var vect = Vector2.ZERO
		vect.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		vect.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
		vect = vect.normalized()
		
		if vect.x > 0:
			flipped = false
			globalvars.playerFlip = false
		elif vect.x < 0:
			flipped = true
			globalvars.playerFlip = true
		
		if vect != Vector2.ZERO:
			vel = vel.move_toward(vect * speed, friction * delta)
			animation("run")
		#	animation("idle")
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


func cooldownExpire():
	fbcooldown = false

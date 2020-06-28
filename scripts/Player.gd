extends KinematicBody2D

export (float) var maxSpeed = 100
export (float) var friction = 10

var vel = Vector2.ZERO

var flippedG = false

var attacking = false

func _ready():
	var colA = GVars.plrA
	var colB = GVars.plrB
	var colC = GVars.plrC
	var colD = GVars.plrD
	
	get_node("sprites/norm/ir/body").self_modulate = colA
	get_node("sprites/norm/ir/body-shadow").self_modulate = colA
	get_node("sprites/norm/ir/wings").self_modulate = colB
	get_node("sprites/norm/ir/horns").self_modulate = colC
	get_node("sprites/norm/ir/eyes").self_modulate = colD
	get_node("sprites/flip/norm/ir/body").self_modulate = colA
	get_node("sprites/flip/norm/ir/body-shadow").self_modulate = colA
	get_node("sprites/flip/norm/ir/wings").self_modulate = colB
	get_node("sprites/flip/norm/ir/horns").self_modulate = colC
	get_node("sprites/flip/norm/ir/eyes").self_modulate = colD
	
	get_node("sprites/norm/atk/body").playing = false
	get_node("sprites/norm/atk/body-shadow").playing = false
	get_node("sprites/norm/atk/wings").playing = false
	get_node("sprites/norm/atk/horns").playing = false
	get_node("sprites/norm/atk/eyes").playing = false
	get_node("sprites/flip/norm/atk/body").playing = false
	get_node("sprites/flip/norm/atk/body-shadow").playing = false
	get_node("sprites/flip/norm/atk/wings").playing = false
	get_node("sprites/flip/norm/atk/horns").playing = false
	get_node("sprites/flip/norm/atk/eyes").playing = false
	
	get_node("sprites/norm/atk/body").frame = 0
	get_node("sprites/norm/atk/body-shadow").frame = 0
	get_node("sprites/norm/atk/wings").frame = 0
	get_node("sprites/norm/atk/horns").frame = 0
	get_node("sprites/norm/atk/eyes").frame = 0
	get_node("sprites/flip/norm/atk/body").frame = 0
	get_node("sprites/flip/norm/atk/body-shadow").frame = 0
	get_node("sprites/flip/norm/atk/wings").frame = 0
	get_node("sprites/flip/norm/atk/horns").frame = 0
	get_node("sprites/flip/norm/atk/eyes").frame = 0
	
	animation(flippedG, "idle", false)

func _physics_process(delta):
	if not attacking:
		var vect = Vector2.ZERO
		vect.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		vect.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
		if vect.x < 0:
			flippedG = true
		elif vect.x > 0:
			flippedG = false
	
		vect = vect.normalized()
		if vect != Vector2.ZERO:
			vel = vel.move_toward(vect * maxSpeed, friction * delta)
			animation(flippedG, "run", false)
		else:
			vel = vel.move_toward(Vector2.ZERO, friction * delta)
			animation(flippedG, "idle", false)
		
#		if vel != Vector2.ZERO:
#			animation(flippedG, "run", false)
#		else:
#			animation(flippedG, "idle", false)
		
		vel = move_and_slide(vel)

func _unhandled_key_input(event):
	if event.scancode == KEY_SPACE and event.pressed:
		animation(flippedG, "tail", true)

func animation(flipped: bool, anim: String, attack_anim: bool):	
	if flipped:
		get_node("sprites/flip").visible = true
		get_node("sprites/norm").visible = false
	else:
		get_node("sprites/flip").visible = false
		get_node("sprites/norm").visible = true
	
	if !attack_anim:
		if !attacking:
			get_node("sprites/flip/norm/ir").visible = true
			get_node("sprites/norm/ir").visible = true
			
			get_node("sprites/flip/norm/atk").visible = false
			get_node("sprites/norm/atk").visible = false
			
			get_node("sprites/norm/ir/body").play(anim + "-body")
			get_node("sprites/norm/ir/body-shadow").play(anim + "-body-shadow")
			get_node("sprites/norm/ir/wings").play(anim + "-wings")
			get_node("sprites/norm/ir/horns").play(anim + "-horns")
			get_node("sprites/norm/ir/eyes").play(anim + "-eyes")
			get_node("sprites/flip/norm/ir/body").play(anim + "-body")
			get_node("sprites/flip/norm/ir/body-shadow").play(anim + "-body-shadow")
			get_node("sprites/flip/norm/ir/wings").play(anim + "-wings")
			get_node("sprites/flip/norm/ir/horns").play(anim + "-horns")
			get_node("sprites/flip/norm/ir/eyes").play(anim + "-eyes")
	else:
		if vel == Vector2.ZERO: #aka... the player is NOT running (this is TEMPORARY)
			attacking = true
			
			get_node("sprites/flip/norm/ir").visible = false
			get_node("sprites/norm/ir").visible = false
		
			get_node("sprites/flip/norm/atk").visible = true
			get_node("sprites/norm/atk").visible = true
			
			get_node("sprites/norm/atk/body").playing = true
			get_node("sprites/norm/atk/body-shadow").playing = true
			get_node("sprites/norm/atk/wings").playing = true
			get_node("sprites/norm/atk/horns").playing = true
			get_node("sprites/norm/atk/eyes").playing = true
			get_node("sprites/flip/norm/atk/body").playing = true
			get_node("sprites/flip/norm/atk/body-shadow").playing = true
			get_node("sprites/flip/norm/atk/wings").playing = true
			get_node("sprites/flip/norm/atk/horns").playing = true
			get_node("sprites/flip/norm/atk/eyes").playing = true

func atkFinish():
	attacking = false
	get_node("sprites/flip/norm/ir").visible = true
	get_node("sprites/norm/ir").visible = true
	get_node("sprites/flip/norm/atk").visible = false
	get_node("sprites/norm/atk").visible = false
	
	get_node("sprites/norm/atk/body").playing = false
	get_node("sprites/norm/atk/body-shadow").playing = false
	get_node("sprites/norm/atk/wings").playing = false
	get_node("sprites/norm/atk/horns").playing = false
	get_node("sprites/norm/atk/eyes").playing = false
	get_node("sprites/flip/norm/atk/body").playing = false
	get_node("sprites/flip/norm/atk/body-shadow").playing = false
	get_node("sprites/flip/norm/atk/wings").playing = false
	get_node("sprites/flip/norm/atk/horns").playing = false
	get_node("sprites/flip/norm/atk/eyes").playing = false
	
	get_node("sprites/norm/atk/body").frame = 0
	get_node("sprites/norm/atk/body-shadow").frame = 0
	get_node("sprites/norm/atk/wings").frame = 0
	get_node("sprites/norm/atk/horns").frame = 0
	get_node("sprites/norm/atk/eyes").frame = 0
	get_node("sprites/flip/norm/atk/body").frame = 0
	get_node("sprites/flip/norm/atk/body-shadow").frame = 0
	get_node("sprites/flip/norm/atk/wings").frame = 0
	get_node("sprites/flip/norm/atk/horns").frame = 0
	get_node("sprites/flip/norm/atk/eyes").frame = 0

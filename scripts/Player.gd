extends KinematicBody2D

export (float) var maxSpeed = 100
export (float) var friction = 10

var vel = Vector2.ZERO

var flippedG = false

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
	
	animation(flippedG, "idle")

func _physics_process(delta):
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
		animation(flippedG, "run")
	else:
		vel = vel.move_toward(Vector2.ZERO, friction * delta)
		animation(flippedG, "idle")
		
	
	vel = move_and_slide(vel)
	
func animation(flipped: bool, anim: String):
	if flipped:
		get_node("sprites/norm/ir/body").visible = false
		get_node("sprites/norm/ir/body-shadow").visible = false
		get_node("sprites/norm/ir/wings").visible = false
		get_node("sprites/norm/ir/horns").visible = false
		get_node("sprites/norm/ir/eyes").visible = false
		get_node("sprites/flip/norm/ir/body").visible = true
		get_node("sprites/flip/norm/ir/body-shadow").visible = true
		get_node("sprites/flip/norm/ir/wings").visible = true
		get_node("sprites/flip/norm/ir/horns").visible = true
		get_node("sprites/flip/norm/ir/eyes").visible = true
	else:
		get_node("sprites/norm/ir/body").visible = true
		get_node("sprites/norm/ir/body-shadow").visible = true
		get_node("sprites/norm/ir/wings").visible = true
		get_node("sprites/norm/ir/horns").visible = true
		get_node("sprites/norm/ir/eyes").visible = true
		get_node("sprites/flip/norm/ir/body").visible = false
		get_node("sprites/flip/norm/ir/body-shadow").visible = false
		get_node("sprites/flip/norm/ir/wings").visible = false
		get_node("sprites/flip/norm/ir/horns").visible = false
		get_node("sprites/flip/norm/ir/eyes").visible = false
	
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
	
	
	
	

extends KinematicBody

const TYPE = "player"

onready var fireball = preload("res://entities/prefabs/fireball.tscn")

var lookSensitivity: float = 5.0
var minlook = -75
var maxlook = 75
var mm = Vector3()

var firstperson = true

var speed = 5
var jump = 10
var grav = 15
var vel = Vector3()

#cooldowns
var mcool = 0.5
var rangecool = 2

func _ready():
	gvars.mouseCaptured = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$camerarig/firstperson.current = firstperson
	$camerarig/thirdperson.current = !firstperson
	rotation_degrees = Vector3.ZERO

func _input(event):
	#Make sure that player input events only happen when UI isn't taking the
	#input space
	if get_parent().get_node("CanvasLayer/Control").interactionShowing: return
	if event is InputEventMouseMotion:
		mm = event.relative

func _process(delta):
	#Input events
	if Input.is_action_just_pressed("misc_camerafptp") and gvars.mouseCaptured:
		print("Switching camera")
		firstperson = !firstperson
	#mouse look
	if gvars.mouseCaptured:
		var rot = Vector3(mm.y, mm.x, 0) * lookSensitivity * delta
		
		rotation_degrees.y -= rot.y
		$camerarig.rotation_degrees.x += rot.x
		$camerarig.rotation_degrees.x = clamp($camerarig.rotation_degrees.x, minlook, maxlook)
		
		$camerarig/firstperson.current = firstperson
		$camerarig/thirdperson.current = !firstperson
		
		mm = Vector3() #todo: pvp

var colliding = false

func checkHover():
	var entityOver = $camerarig/hoverOver.is_colliding()
	if entityOver and $camerarig/hoverOver.get_collider().TYPE == "damageable":
		var node = $camerarig/hoverOver.get_collider()
		get_parent().get_node("CanvasLayer/Control").showEntityInfo(node, {"hitpoints": node.hp, "maxhitpoints": node.maxhp, "entityname": node.ename})
	elif entityOver and $camerarig/hoverOver.get_collider().TYPE == "npc":
		var node = $camerarig/hoverOver.get_collider()
		get_parent().get_node("CanvasLayer/Control").showEntityInfo(node, {"hitpoints": node.hp, "maxhitpoints": node.maxHP, "entityname": node.npcid})
	else:
		get_parent().get_node("CanvasLayer/Control").showEntityInfo(null, {})

func _physics_process(delta):
	if gvars.mouseCaptured:
		var ctype = ""
		colliding = $camerarig/RayCast.is_colliding()
		checkHover()
		if colliding:
			ctype = $camerarig/RayCast.get_collider().TYPE
		if Input.is_action_just_pressed("attack_primary") and colliding:
			if ctype == "damageable":
				$camerarig/RayCast.get_collider().recieve_damage(10.0)
		elif Input.is_action_just_pressed("attack_secondary"):
			var fb = fireball.instance()
			fb.transform = $camerarig/Position3D.global_transform
			fb.velocity = fb.transform.basis.z * fb.SPEED
			get_parent().get_node("projectiles").add_child(fb)
		elif Input.is_action_just_pressed("interact") and colliding:
			if ctype == "interactable" || ctype == "npc":
				$camerarig/RayCast.get_collider()._interacted()
		
		vel.x = 0
		vel.z = 0
		
		var movement = Vector3()
		
		if Input.is_action_pressed("ui_up"):
			movement.z += 1
		if Input.is_action_pressed("ui_down"):
			movement.z -= 1
		if Input.is_action_pressed("ui_left"):
			movement.x += 1
		if Input.is_action_pressed("ui_right"):
			movement.x -= 1
		
		movement = movement.normalized()
		
		var direction = (transform.basis.z * movement.z + transform.basis.x * movement.x)
		
		vel.x = direction.x * speed
		vel.z = direction.z * speed
		
		vel.y -= grav * delta
		
		if Input.is_action_pressed("jump") and is_on_floor():
			vel.y = jump
		
		vel = move_and_slide(vel, Vector3.UP)

extends KinematicBody

const TYPE = "player"

var lookSensitivity: float = 5.0
var minlook = -20
var maxlook = 75
var mm = Vector3()

var captured = true
var firstperson = true

var speed = 5
var jump = 10
var grav = 15
var vel = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$camerarig/firstperson.current = firstperson
	$camerarig/thirdperson.current = !firstperson

func _input(event):
	if event is InputEventMouseMotion:
		mm = event.relative
	if event is InputEventKey and captured:
		if event.pressed and event.scancode == KEY_ESCAPE:
			Input.set_mouse_mode(0)
			captured = false
	if event is InputEventMouseButton and !captured:
		if event.pressed and event.button_index == BUTTON_LEFT:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			captured = true

func _process(delta):
	#Input events
	if Input.is_action_just_pressed("misc_camerafptp") and captured:
		print("Switching camera")
		firstperson = !firstperson
	#mouse look
	if captured:
		var rot = Vector3(mm.y, mm.x, 0) * lookSensitivity * delta
		
		rotation_degrees.y -= rot.y
		$camerarig.rotation_degrees.x += rot.x
		$camerarig.rotation_degrees.x = clamp($camerarig.rotation_degrees.x, minlook, maxlook)
		
		$camerarig/firstperson.current = firstperson
		$camerarig/thirdperson.current = !firstperson
		
		mm = Vector3() #todo: pvp

func _physics_process(delta):
	if Input.is_action_just_pressed("attack_primary") and captured:
		if $RayCast.is_colliding() and $RayCast.TYPE == "damageable":
			$RayCast.get_collider().recieve_damage(10.0)
	
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

extends KinematicBody

const TYPE = "player"

onready var fireball = preload("res://entities/prefabs/fireball.tscn")

var lookSensitivity: float = 4.0
var minlook = -75
var maxlook = 75
var mm = Vector3()

var firstperson = true
var dead = false

var speed = 5
var jump = 10
var grav = 15
var vel = Vector3()

#cooldowns
var mcool = 0.5
var rangecool = 2
var cool1
var cool2
var cool3
var cool4 #TODO: abilities

var canmelee = true
var canrange = true
var can1
var can2
var can3
var can4

#stats and effects
var hp
var maxhp = 300
var regenrate = 2

var stamina
var sregenrate = 0.8
var sdimrate = 0.4

var hunger
var diminishrate = 20 #will be modified depending on the action and status effects

var mana
var maxmana = 100
 
var statuseffects = []

var skills = [] #array of dictionaries containing all unlocked skills and their levels

func _ready():
	gvars.mouseCaptured = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$camerarig/firstperson.current = firstperson
	$camerarig/thirdperson.current = !firstperson
	rotation_degrees = Vector3.ZERO
	
	#stat handling - TODO: implement saving and loading of stat values, including maxhp and maxmana
	hp = maxhp
	mana = maxmana
	hunger = 100
	stamina = 100

func _input(event):
	#Make sure that player input events only happen when UI isn't taking the
	#input space
	if get_parent().get_parent().get_node("CanvasLayer/Control").interactionShowing: return
	if event is InputEventMouseMotion:
		mm = event.relative

func _process(delta):
	if hp <= 0:
		gvars.mouseCaptured = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#death animation
		#respawn after some time
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
	
	#info handling
	var plrinfo = {"hp":hp, "maxhp":maxhp, "mana":mana,"maxmana":maxmana,"stamina":stamina,"hunger":hunger}
	get_parent().get_parent().get_node("CanvasLayer/Control").updatePlayerDetails(plrinfo)

var colliding = false

func checkHover():
	var entityOver = $camerarig/hoverOver.is_colliding()
	if entityOver:
		if $camerarig/hoverOver.get_collider().TYPE == "damageable":
			var node = $camerarig/hoverOver.get_collider()
			get_parent().get_parent().get_node("CanvasLayer/Control").showEntityInfo(node, {"hitpoints": node.hp, "maxhitpoints": node.maxhp, "entityname": node.ename})
		elif $camerarig/hoverOver.get_collider().TYPE == "npc":
			var node = $camerarig/hoverOver.get_collider()
			get_parent().get_parent().get_node("CanvasLayer/Control").showEntityInfo(node, {"hitpoints": node.hp, "maxhitpoints": node.maxHP, "entityname": node.npcid})
		else:
			get_parent().get_parent().get_node("CanvasLayer/Control").showEntityInfo(null, {})
	else:
		get_parent().get_parent().get_node("CanvasLayer/Control").showEntityInfo(null, {})
	
	#crosshair dialogue
	if colliding:
		var type = $camerarig/RayCast.get_collider()
		if type.TYPE != "ground" and type.TYPE != "damageable" and type.TYPE != "projectile" and type.TYPE:
			get_parent().get_parent().get_node("CanvasLayer/Control").interact(type.TYPE, type.display)
		else:
			get_parent().get_parent().get_node("CanvasLayer/Control").interact(null, null)
	else:
		get_parent().get_parent().get_node("CanvasLayer/Control").interact(null, null)
	
	#interact type
	var ctype = ""
	if colliding:
		ctype = $camerarig/RayCast.get_collider().TYPE
	if Input.is_action_just_pressed("interact") and colliding:
		if ctype == "interactable" || ctype == "npc" || ctype == "item":
			$camerarig/RayCast.get_collider()._interacted()

# Checks if any of the ability/attack buttons are pressed
func checkAttack():
	var ctype = ""
	if colliding:
		ctype = $camerarig/RayCast.get_collider().TYPE
	if Input.is_action_just_pressed("attack_primary") and colliding and canmelee:
		if ctype == "damageable":
			$camerarig/RayCast.get_collider().recieve_damage(10.0)
		canmelee = false
		$mcool.start()
	elif Input.is_action_just_pressed("attack_secondary") and canrange:
		var fb = fireball.instance()
		fb.transform = $camerarig/Position3D.global_transform
		fb.velocity = fb.transform.basis.z * fb.SPEED
		get_parent().get_parent().get_node("projectiles").add_child(fb)
		canrange = false
		$rcool.start()
	elif Input.is_action_just_pressed("ability_1"):
		pass #TODO
	elif Input.is_action_just_pressed("ability_2"):
		pass #TODO
	elif Input.is_action_just_pressed("ability_3"):
		pass #TODO
	elif Input.is_action_just_pressed("ability_4"):
		pass #TODO

func _physics_process(delta):
	if gvars.mouseCaptured:
		
		colliding = $camerarig/RayCast.is_colliding()
		checkHover()
		checkAttack()
		
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
		
		var sprinting = false
		if Input.is_action_pressed("movement_sprint"):
			pass
		
		vel.x = direction.x * speed * (1.5 if sprinting else 1.0)
		vel.z = direction.z * speed * (1.5 if sprinting else 1.0)
		
		vel.y -= grav * delta
		
		if Input.is_action_pressed("jump") and is_on_floor():
			vel.y = jump
		
		vel = move_and_slide(vel, Vector3.UP)

func recieve_damage(damage):
	hp -= damage

#Cooldown timer callbacks

func _on_rcool_timeout():
	canrange = true

func _on_mcool_timeout():
	canmelee = false

func _on_1cool_timeout():
	pass # Replace with function body.

func _on_2cool_timeout():
	pass # Replace with function body.

func _on_3cool_timeout():
	pass # Replace with function body.

func _on_4cool_timeout():
	pass # Replace with function body.

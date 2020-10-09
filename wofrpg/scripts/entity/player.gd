extends KinematicBody2D

const MOVEMENT_SPEED = 600

puppet var vel = Vector2.ZERO
puppet var pos

onready var bodymaskNWr = load("res://images/character/nigw/run/nw-base-run-mask.png")
onready var bodymaskNWi = load("res://images/character/nigw/idle/nw-body-mask.png")

var gvars
onready var gloader = get_tree().get_root().get_node("gloader")

var ready = false

var runb
var runbmask
var runh
var runhmask
var runs
var rune
var runt
var runw
var runwmask

func _ready():
	set_physics_process(false)
	set_process(true)

func _process(_delta):
	if is_instance_valid(gvars):
		setplrdetails(gvars.plrdata, [gvars.plrhead, gvars.plrbody, gvars.plrwing])
		set_process(false);
		ready = true
		set_physics_process(true)
	else:
		gvars = get_tree().get_root().get_node("globalvars")

#Get the player details from the server, unless network master. Called for EACH player object
sync func setplrdetails(data, palettes): #palettes: [head, body, wing]
	for tribe in gloader.loadedtribes:
		if data.appearances.body == tribe.tribename:
			$graphics/body.texture = load(tribe.appearancesidle[2])
			$graphics/body.get_material().set_shader_param("mask", load(tribe.appearancesidlemask[2]))
	for tribe in gloader.loadedtribes:
		if data.appearances.head == tribe.tribename:
			$graphics/head.texture = load(tribe.appearancesidle[0])
			$graphics/head.get_material().set_shader_param("mask", load(tribe.appearancesidlemask[0]))
	for tribe in gloader.loadedtribes:
		if data.appearances.tail == tribe.tribename:
			$graphics/tail.texture = load(tribe.appearancesidle[3])
			$graphics/tail.get_material().set_shader_param("mask", load(tribe.appearancesidlemask[3]))
	for tribe in gloader.loadedtribes:
		if data.appearances.legs == tribe.tribename:
			$graphics/legs.texture = load(tribe.appearancesidle[1])
			$graphics/legs.get_material().set_shader_param("mask", load(tribe.appearancesidlemask[1]))
	for tribe in gloader.loadedtribes:
		if data.appearances.wings == tribe.tribename:
			$graphics/wings.texture = load(tribe.appearancesidle[4])
			$graphics/wings.get_material().set_shader_param("mask", load(tribe.appearancesidlemask[4]))
	for tribe in gloader.loadedtribes:
		if data.appearances.spine == tribe.tribename:
			$graphics/spine.texture = load(tribe.appearancesidle[5])
	
	#spine/tdec/edrop
	
	$graphics/body.get_material().set_shader_param("palette", palettes[1])
	$graphics/tail.get_material().set_shader_param("palette", palettes[1])
	$graphics/legs.get_material().set_shader_param("palette", palettes[1])
	$graphics/head.get_material().set_shader_param("palette", palettes[0])
	$graphics/wings.get_material().set_shader_param("palette", palettes[2])
	$graphics/spine.self_modulate = Color(data.colors.spineRaw[0], data.colors.spineRaw[1], data.colors.spineRaw[2])


func _physics_process(delta):
	if !get_tree().has_network_peer() and ready:
		if !gvars.paused:
			var vect = Vector2()
			vect.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			vect.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			
			if vect.x > 0:
				for x in range(6):
					$graphics.get_child(x).flip_h = false
			elif vect.x < 0:
				for x in range(6):
					$graphics.get_child(x).flip_h = true
			
			if vect == Vector2.ZERO:
				#$graphics/AnimationPlayer.play("test-idle")
				$graphics/tail.show()
				$graphics/legs.show()
				#$graphics/body.get_material().set_shader_param("mask", bodymaskNWi)
			else:
				#$graphics/AnimationPlayer.play("test-run")
				$graphics/tail.hide()
				$graphics/legs.hide()
				#$graphics/body.get_material().set_shader_param("mask", bodymaskNWr)
			vel = vect.normalized() * MOVEMENT_SPEED
			
			vel = move_and_slide(vel)
			pos = position
		else:
			$graphics/AnimationPlayer.stop()
	else:
		if is_network_master():
			var vect = Vector2()
			vect.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			vect.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			
			if vect.x > 0:
				for x in range(6):
					$graphics.get_child(x).flip_h = false
			elif vect.x < 0:
				for x in range(6):
					$graphics.get_child(x).flip_h = true
			
			if vect == Vector2.ZERO:
				#$graphics/AnimationPlayer.play("test-idle")
				$graphics/tail.show()
				$graphics/legs.show()
				#$graphics/body.get_material().set_shader_param("mask", bodymaskNWi)
			else:
				#$graphics/AnimationPlayer.play("test-run")
				$graphics/tail.hide()
				$graphics/legs.hide()
				#$graphics/body.get_material().set_shader_param("mask", bodymaskNWr)
			vel = vect.normalized() * MOVEMENT_SPEED
			
			vel = move_and_slide(vel)
			pos = position
		else:
			if vel.x > 0:
				for x in range(6):
					$graphics.get_child(x).flip_h = false
			elif vel.x < 0:
				for x in range(6):
					$graphics.get_child(x).flip_h = true
			
			if vel == Vector2.ZERO:
				#$graphics/AnimationPlayer.play("test-idle")
				$graphics/tail.show()
				$graphics/legs.show()
				#$graphics/body.get_material().set_shader_param("mask", bodymaskNWi)
			else:
				#$graphics/AnimationPlayer.play("test-run")
				$graphics/tail.hide()
				$graphics/legs.hide()
				#$graphics/body.get_material().set_shader_param("mask", bodymaskNWr)
			position = pos

extends KinematicBody2D

const MOVEMENT_SPEED = 600

puppet var vel = Vector2.ZERO
puppet var pos = Vector2.ZERO

onready var bodymaskNWr = load("res://images/character/nigw/run/nw-base-run-mask.png")
onready var bodymaskNWi = load("res://images/character/nigw/idle/nw-body-mask.png")

var gvars

var ready = false

func _ready():
	set_process(true)

func _process(_delta):
	if is_instance_valid(gvars):
		setplrdetails(gvars.plrhead, gvars.plrbody, gvars.plrwing, false, false, false)
		set_process(false);
		ready = true
	else:
		gvars = get_tree().get_root().get_node("globalvars")

sync func setplrdetails(head:ImageTexture, body:ImageTexture, wing:ImageTexture, edrop: bool, spine: bool, tdec: bool):
	pass

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
				$graphics/AnimationPlayer.play("test-idle")
				$graphics/tail.show()
				$graphics/legs.show()
				#$graphics/body.get_material().set_shader_param("mask", bodymaskNWi)
			else:
				$graphics/AnimationPlayer.play("test-run")
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
				$graphics/AnimationPlayer.play("test-idle")
				$graphics/tail.show()
				$graphics/legs.show()
				#$graphics/body.get_material().set_shader_param("mask", bodymaskNWi)
			else:
				$graphics/AnimationPlayer.play("test-run")
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
				$graphics/AnimationPlayer.play("test-idle")
				$graphics/tail.show()
				$graphics/legs.show()
				#$graphics/body.get_material().set_shader_param("mask", bodymaskNWi)
			else:
				$graphics/AnimationPlayer.play("test-run")
				$graphics/tail.hide()
				$graphics/legs.hide()
				#$graphics/body.get_material().set_shader_param("mask", bodymaskNWr)
			position = pos

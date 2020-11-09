extends KinematicBody2D

#Custom character uses body sprite, graphics gets scaled with custom scaling in (GS-ADV-DETAILS)
# Multiplayer data: [username, {playerdata}]
#
#
#
#
#

var MOVEMENT_SPEED = 750

puppet var vel = Vector2.ZERO
puppet var pos = Vector2()

const type = "PLAYER"

signal interact()
signal checkThere()

#custom character variables
puppet var usecc = false #if set to true hides all but the body graphic and disables colormasks

var charname
var username

var run
var runmask
var rune

var idle
var idlemask
var idlee

var customScale: Vector2

func _ready():
	if !get_tree().has_network_peer() or is_network_master():
		$Camera2D.current = true
		setplrdetails(gvars.plrdata, gvars.plrpalette)
		$Label.hide()
		for entity in get_parent().get_children():
			if entity.type == "NPC":
				entity.playerInstanced()
		

func _input(event):
	if !gvars.paused:
		if event is InputEventKey:
			if event.scancode == KEY_F and event.pressed:
				emit_signal("interact")

func updateDetails(data:Array, _palette):
	var pal = ImageTexture.new()
	setplrdetails(data[1], pal)
	$Label.text = data[2]
	username = data[2]
	$Label.show()

func setplrdetails(data: Dictionary, palette):
	if data.has("custom") and data.custom and data.has("cframes"):
		usecc = true
		$graphics.scale = $graphics.scale * data.size
		$graphics.position = $graphics.position * data.size
		$graphics/base.visible = false
		$graphics/customlooks.frames = load(data.cframes)
		$graphics/customlooks.play("idle")
		#TODO: custom stats
		if !gvars.loggedIn:
			$graphics.scale = $graphics.scale * data.size
			$graphics.position = $graphics.position * data.size
			$"cs-flip".position = $"cs-flip".position * data.size
			$"cs-flip".scale = $"cs-flip".scale * data.size
			$"cs-nonflip".position = $"cs-nonflip".position * data.size
			$"cs-nonflip".scale = $"cs-nonflip".scale * data.size
			charname = data.cname
			emit_signal("checkThere")
		return
	charname = data.name
	match data.tribes.size():
		1: #Purebred
			for tribe in gloader.loadedtribes:
				if data.tribes[0] == tribe.tribeid:
					var updated = false
					for modifier in data.modifiers:
						if tribe.apps[0].appModifiers.has(modifier): #Uses first index (purebred by default)
							match modifier.replacesPart:
								"main":
									$graphics/base.texture = load(modifier.idle)
									idle = load(modifier.idle)
									run = load(modifier.run)
									if modifier.idlemask != "none":
										$graphics/base.set_material(load("res://godot-resources/shaders/characterParts.shader"))
										$graphics/base.material.set_shader_param("mask", load(modifier.idlemask))
										$graphics/base.material.set_shader_param("palette", palette)
										idlemask = load(modifier.idlemask)
										runmask = load(modifier.runmask)
									else:
										$graphics/base.set_material(null)
									updated = true
								"eyedrop": #Doesn't use mask
									$graphics/eyedrop.texture = load(modifier.idle)
					if !updated:
						$graphics/base.texture = load(tribe.apps[0].idle)
						idle = load(tribe.apps[0].idle)
						idle = load(tribe.apps[0].idlemask)
						run = load(tribe.apps[0].run)
						runmask = load(tribe.apps[0].runmask)
						$graphics/base.set_material(load("res://godot-resources/shaders/characterParts.shader"))
						$graphics/base.material.set_shader_param("mask", load(tribe.apps[0].idlemask))
						$graphics/base.material.set_shader_param("palette", palette)
		2: #Hybrid: Uses first index tribe as file reference, then scans apps for additionalTribe to match second index
			pass

func _physics_process(_delta):
	if !get_tree().has_network_peer():
		if !gvars.paused:
			var vect = Vector2()
			vect.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			vect.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			
			vel = vect.normalized() * MOVEMENT_SPEED
			
			vel = move_and_slide(vel)
			pos = position
			animation()
		else:
			$graphics/AnimationPlayer.stop()
			$graphics/customlooks.stop()
	else:
		if is_network_master():
			if !gvars.uishowing and !gvars.interactionShowing:
				var vect = Vector2()
				vect.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
				vect.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
				
				vel = vect.normalized() * MOVEMENT_SPEED
				vel = move_and_slide(vel)
				pos = position
				animation()
				
				rset_unreliable("pos", position)
				rset_unreliable("vel", vel)
			else:
				vel = Vector2.ZERO
		else:
			position = pos
			animation()

func animation():
	if vel.x > 0:
		for x in range(2):
			$graphics.get_child(x).flip_h = false
		$"cs-nonflip".disabled = false
		$"cs-flip".disabled = true
	elif vel.x < 0:
		for x in range(2):
			$graphics.get_child(x).flip_h = true
		$"cs-nonflip".disabled = true
		$"cs-flip".disabled = false
	
	if vel == Vector2.ZERO:
		if !usecc:
			$graphics/AnimationPlayer.play("test-idle")
			
			$graphics/base.texture = idle
			$graphics/base.material.set_shader_param("mask", idlemask)
			
			for x in range(1):
				$graphics.get_child(x).scale = Vector2(2.035, 2.035)
		else:
			$graphics/customlooks.play("idle")
	else:
		if !usecc:
			$graphics/AnimationPlayer.play("test-run")
			
			$graphics/base.texture = run
			$graphics/base.material.set_shader_param("mask", runmask)
			
			for x in range(1):
				$graphics.get_child(x).scale = Vector2(2.372, 2.372)
		else:
			$graphics/customlooks.play("run")

func interacted(npcid):
	get_parent().get_parent().get_node("CanvasLayer/UI").initInteraction(npcid)

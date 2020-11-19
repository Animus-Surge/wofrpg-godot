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

var runb
var runbmask
var runh
var runhmask
var runw
var runwmask
var runs
var runsmask
var rune
var runt
var runtmask

var idleb
var idlebmask
var idleh
var idlehmask
var idlew
var idlewmask
var idles
var idlesmask
var idlee
var idlet
var idletmask

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
				emit_signal("interact", charname)

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
		$graphics/body.visible = false
		$graphics/spine.visible = false
		$graphics/head.visible = false
		$graphics/legs.visible = false
		$graphics/tail.visible = false
		$graphics/tdec.visible = false
		$graphics/wings.visible = false
		$graphics/edrop.visible = false
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
	for tribe in gloader.loadedtribes:
		if data.appearances.body == tribe.tribename:
			idleb = load(tribe.appearancesidle[2])
			idlebmask = load(tribe.appearancesidlemask[2])
			runb = load(tribe.appearancesrun[0])
			runbmask = load(tribe.appearancesrunmask[0])
			break
	for tribe in gloader.loadedtribes:
		if data.appearances.head == tribe.tribename:
			idleh = load(tribe.appearancesidle[0])
			idlehmask = load(tribe.appearancesidlemask[0])
			runh = load(tribe.appearancesrun[1])
			runhmask = load(tribe.appearancesrunmask[1])
			break
	for tribe in gloader.loadedtribes:
		if data.appearances.tail == tribe.tribename:
			$graphics/tail.texture = load(tribe.appearancesidle[3])
			$graphics/tail.get_material().set_shader_param("mask", load(tribe.appearancesidlemask[3]))
			break
	for tribe in gloader.loadedtribes:
		if data.appearances.legs == tribe.tribename:
			$graphics/legs.texture = load(tribe.appearancesidle[1])
			$graphics/legs.get_material().set_shader_param("mask", load(tribe.appearancesidlemask[1]))
			break
	for tribe in gloader.loadedtribes:
		if data.appearances.wings == tribe.tribename:
			idlew = load(tribe.appearancesidle[4])
			idlewmask = load(tribe.appearancesidlemask[4])
			runw = load(tribe.appearancesrun[2])
			runwmask = load(tribe.appearancesrunmask[2])
			break
	for tribe in gloader.loadedtribes:
		if data.appearances.spine == tribe.tribename:
			idles = load(tribe.appearancesidle[5])
			idlesmask = load(tribe.appearancesidlemask[5])
			runs = load(tribe.appearancesrun[3])
			runsmask = load(tribe.appearancesrunmask[3])
			break
	for tribe in gloader.loadedtribes:
		for df in tribe.decoflags:
			if df == "eyedrop":
				rune = load(tribe.appearancesrun[4])
				idlee = load(tribe.appearancesidle[6])
				#TODO: different tribes have different teardrop anims
			if df == "tdec":
				if data.appearances.tdec != "Select...":
					if data.appearances.tdec == tribe.tribename:
						idlet = load(tribe.appearancesidle[7])
						idletmask = load(tribe.appearancesidlemask[6])
						runt = load(tribe.appearancesrun[5])
						runtmask = load(tribe.appearancesrunmask[4])
	$graphics/spine.visible = data.appearances.sshow
	$graphics/edrop.visible = data.appearances.eshow
	$graphics/tdec.visible = data.appearances.tshow
	
	$graphics/body.get_material().set_shader_param("palette", palette)
	$graphics/tail.get_material().set_shader_param("palette", palette)
	$graphics/legs.get_material().set_shader_param("palette", palette)
	$graphics/head.get_material().set_shader_param("palette", palette)
	$graphics/wings.get_material().set_shader_param("palette", palette)
	$graphics/spine.get_material().set_shader_param("palette", palette)
	$graphics/tdec.get_material().set_shader_param("palette", palette)

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
		for x in range(9):
			$graphics.get_child(x).flip_h = false
		$"cs-nonflip".disabled = false
		$"cs-flip".disabled = true
	elif vel.x < 0:
		for x in range(9):
			$graphics.get_child(x).flip_h = true
		$"cs-nonflip".disabled = true
		$"cs-flip".disabled = false
	
	if vel == Vector2.ZERO:
		if !usecc:
			$graphics/AnimationPlayer.play("test-idle")
			$graphics/tail.show()
			$graphics/legs.show()
			
			$graphics/body.texture = idleb
			$graphics/body.get_material().set_shader_param("mask", idlebmask)
			$graphics/head.texture = idleh
			$graphics/head.get_material().set_shader_param("mask", idlehmask)
			$graphics/wings.texture = idlew
			$graphics/wings.get_material().set_shader_param("mask", idlewmask)
			$graphics/spine.texture = idles
			$graphics/spine.get_material().set_shader_param("mask", idlesmask)
			$graphics/edrop.texture = idlee
			$graphics/tdec.texture = idlet
			$graphics/tdec.get_material().set_shader_param("mask", idletmask)
			for x in range(8):
				$graphics.get_child(x).scale = Vector2(0.503, 0.503)
		else:
			$graphics/customlooks.play("idle")
	else:
		if !usecc:
			$graphics/AnimationPlayer.play("test-run")
			$graphics/tail.hide()
			$graphics/legs.hide()
			
			$graphics/body.texture = runb
			$graphics/body.get_material().set_shader_param("mask", runbmask)
			$graphics/head.texture = runh
			$graphics/head.get_material().set_shader_param("mask", runhmask)
			$graphics/wings.texture = runw
			$graphics/wings.get_material().set_shader_param("mask", runwmask)
			$graphics/spine.texture = runs
			$graphics/spine.get_material().set_shader_param("mask", runsmask)
			$graphics/edrop.texture = rune
			$graphics/tdec.texture = runt
			$graphics/tdec.get_material().set_shader_param("mask", runtmask)
			for x in range(8):
				$graphics.get_child(x).scale = Vector2(0.65, 0.65)
		else:
			$graphics/customlooks.play("run")

func interacted(npcid, cname):
	get_parent().get_parent().get_node("CanvasLayer/UI").initInteraction(npcid, cname)

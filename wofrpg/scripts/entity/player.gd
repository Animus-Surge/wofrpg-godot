extends KinematicBody2D

# Player Constants
const type = "PLAYER"
const MOVEMENT_SPEED = 750
const partIDs = ["head","body","spine","wings","legs","tail","tdec"]

# movement variables
puppet var vel = Vector2.ZERO
puppet var pos = Vector2()

#signals
# warning-ignore:unused_signal
signal interact()
signal readyToShow()

#custom character variables
puppet var usecc = false #if set to true hides all but the body graphic and disables colormasks

var charname
var username

var pal

var flipped = false
var dancing = false

var customScale: Vector2

var cframes

func _ready():
	if gvars.debug or !get_tree().has_network_peer():
		updateDetails()

# warning-ignore:unused_argument
func _input(event):
	pass #TODO: revamp this so it's configurable

#Frames used when custom character is neccessary
func updateDetails(data = {}, _palette = null, _frames = null):
	if !get_tree().has_network_peer() or is_network_master():
		$Camera2D.current = true
		data = gvars.plrdata
		_palette = gvars.plrpalette
	
	setplrdetails(data, _palette)
	emit_signal("readyToShow")

# warning-ignore:unused_argument
func setplrdetails(data: Dictionary, palette = null):
	print(data)
	if data.cuseCustom:
		pass #TODO
		return
	else:
		#if !palette:
		#	pass #TODO: error check
		
		var index = 0
		for app in data.cappearance:
			var tribedata = {}
			for tribe in gloader.loadedtribes:
				if tribe.tribeid == app:
					tribedata = tribe
					break
			if !tribedata.empty():
				$graphics/flip.get_node(partIDs[index]).texture = load(tribedata.idle.idletex)
				$graphics/nonflip.get_node(partIDs[index]).texture = load(tribedata.idle.idletex)
				
				$graphics/flip.get_node(partIDs[index]).material.set_shader_param("mask", load(tribedata.idle.mask))
				$graphics/nonflip.get_node(partIDs[index]).material.set_shader_param("mask", load(tribedata.idle.mask))
				
				var row = -1
				#var partOpt = false
				for part in tribedata.idle.parts:
					if part.partid == partIDs[index]:
						row = part.row
						#if part.has("optional"):
							#partOpt = part.optional
						break
				if row != -1:
					$graphics/flip.get_node(partIDs[index]).show()
					$graphics/nonflip.get_node(partIDs[index]).show()
					$graphics/flip.get_node(partIDs[index]).region_rect.position = Vector2(
						$graphics/flip.get_node(partIDs[index]).region_rect.position.x,
						448 * (row - 1)
					)
					$graphics/nonflip.get_node(partIDs[index]).region_rect.position = Vector2(
						$graphics/nonflip.get_node(partIDs[index]).region_rect.position.x,
						448 * (row - 1)
					)
				else:
					$graphics/flip.get_node(partIDs[index]).hide()
					$graphics/nonflip.get_node(partIDs[index]).hide()
			index += 1
		for child in $graphics/flip.get_children():
			child.material.set_shader_param("palette", palette)
		for child in $graphics/nonflip.get_children():
			child.material.set_shader_param("palette", palette)

func _physics_process(_delta):
	if gvars.debug or !get_tree().has_network_peer():
		vel = Vector2()
		vel.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		vel.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
		var vect = vel.normalized()
		
		if vect.x > 0:
			flipped = false
		elif vect.x < 0:
			flipped = true
		
		if !dancing:
			vect = move_and_slide(vect * MOVEMENT_SPEED)
	elif is_network_master():
		vel = Vector2()
		vel.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		vel.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
		vel = vel.normalized()
		
		if vel.x > 0:
			flipped = false
		elif vel.x < 0:
			flipped = true
		
		if !dancing:
			vel = move_and_slide(vel * MOVEMENT_SPEED)
	else:
		pass
	animation()

func animation():
	
	if flipped:
		$graphics/flip.show()
		$graphics/nonflip.hide()
	else:
		$graphics/flip.hide()
		$graphics/nonflip.show()
	
	if vel == Vector2.ZERO: #idle
		if !usecc:
			pass
	else: #run/trot, will be determined by sprint keybind
		if !usecc:
			pass

func interacted(npcid, cname):
	get_parent().get_parent().get_node("CanvasLayer/UI").initInteraction(npcid, cname)

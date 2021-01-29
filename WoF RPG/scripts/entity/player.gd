extends KinematicBody2D

var tribe #TODO

const SPEED = 100

puppet var pos = Vector2()
puppet var velocity = Vector2.ZERO

func _ready():
	if !get_tree().has_network_peer() or is_network_master():
		$Camera2D.current = true

func _physics_process(delta):
	if get_tree().has_network_peer(): # Online game...
		if is_network_master(): # Local client
			var vect = Vector2()
			vect.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			vect.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			
			velocity = vect.normalized() * SPEED
			velocity = move_and_slide(velocity)
			
			rset(pos, position)
		else: # Nonlocal client
			position = pos
	else: # Offline game
		var vect = Vector2()
		vect.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		vect.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
		velocity = vect.normalized() * SPEED
		velocity = move_and_slide(velocity)
		
		#pos is not used when offline gamemode is active

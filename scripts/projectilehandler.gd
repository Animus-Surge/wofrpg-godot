extends Node2D

var fireball = preload("res://objects/projectile/fireball.tscn")

func _ready():
	pass

func _process(delta):
	var playerglobal = get_node("../../objects/playerRoot").get_global_position()
	playerglobal.y -= 361
	set_global_position(playerglobal)

func summonFireball():
	if globalvars.playerFlip:
		var ball = fireball.instance()
		get_parent().add_child(ball)
		ball.spawn($flip.global_position, get_global_mouse_position())
	else:
		var ball = fireball.instance()
		get_parent().add_child(ball)
		ball.spawn($reg.global_position, get_global_mouse_position())
		#ball.set(get_local_mouse_position()/15, get_node("reg").get_global_position())

extends Node2D

var fireball = preload("res://objects/projectile/fireball.tscn")

func _ready():
	pass

func _process(delta):
	set_global_position(get_node("../../objects/playerRoot").get_global_position())

func summonFireball():
	if globalvars.playerFlip:
		var ball = fireball.instance()
		get_parent().add_child(ball)
		ball.set(get_local_mouse_position()/15, get_node("flip").get_global_position())
	else:
		var ball = fireball.instance()
		get_parent().add_child(ball)
		ball.set(get_local_mouse_position()/15, get_node("reg").get_global_position())

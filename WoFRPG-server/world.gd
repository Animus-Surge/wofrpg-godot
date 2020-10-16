extends Node2D

onready var plr = load("res://player.tscn")

puppetsync func spawn(pos, id, _data, _palette):
	var player = plr.instance()
	
	player.position = pos
	player.set_network_master(id)
	player.name = String(id)
	
	$players.add_child(player)

puppetsync func erasePlayer(id):
	$players.get_node(String(id)).queue_free()

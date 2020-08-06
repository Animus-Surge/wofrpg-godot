extends Node2D

onready var plr = load("res://objects/entity/mp-playerRoot.tscn")

puppet func spawn(pos, id):
	var player = plr.instance()
	
	player.position = pos
	player.name = id
	player.set_network_master(id)
	
	$players.add_child(player)

puppet func remove(id):
	$players.get_node(String(id)).queue_free()

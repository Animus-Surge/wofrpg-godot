extends Node2D

onready var plr = load("res://player.tscn")

puppetsync func spawn(pos, id, _data):
	var player = plr.instance()
	
	player.position = pos
	player.set_network_master(id)
	player.name = String(id)
	
	$entities.add_child(player)

puppetsync func erasePlayer(id):
	lc.logmsg("Erasing player ID: " + String(id), 1)
	$entities.get_node(String(id)).queue_free()

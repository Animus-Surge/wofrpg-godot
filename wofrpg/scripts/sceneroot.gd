extends Node

onready var plr = load("res://objects/entity/player.tscn")
export (String) var scene_name = "scene-name"

func _ready():
	gvars.setCurrentScene(scene_name)
	if !gvars.loggedIn or gvars.splr:
		var player = plr.instance()
		player.position = get_node("world/spawn").position
		$entities.add_child(player)
		return
	timer.wait_time = 0.5
	timer.start()
	yield(timer, "timeout")
	if !get_tree().has_network_peer():
		var player = plr.instance()
		player.position = get_node("world/spawn").position
		$entities.add_child(player)

puppet func spawn(_pos, id, data):
	var spawnpoint:Vector2 = get_node("world/spawn").position
	print(spawnpoint)
	var player = plr.instance()
	
	player.set_network_master(id)
	player.name = String(id)
	player.position = spawnpoint
	
	$entities.add_child(player)
	player.updateDetails(data, null)

puppet func erasePlayer(id):
	$entities.get_node(String(id)).queue_free()

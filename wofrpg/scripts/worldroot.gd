extends Node

onready var plr = load("res://objects/entity/player.tscn")
export (String) var scene_name = "scene-name"

func _ready():
	gvars.setCurrentScene(scene_name)
	if !gvars.loggedIn or gvars.splr or gvars.debug:
		var player = plr.instance()
		player.position = get_node("world/spawn").position
		$entities.add_child(player)
		gvars.allReady()
		return
	timer.wait_time = 0.5
	timer.start()
	yield(timer, "timeout")
	if !get_tree().has_network_peer():
		var player = plr.instance()
		player.position = get_node("world/spawn").position
		$entities.add_child(player)
	gvars.allReady()

puppet func spawn(_pos, id, data, palette, frames = null):
	var spawnpoint:Vector2 = get_node("world/spawn").position
	print(spawnpoint)
	var player = plr.instance()
	
	player.set_network_master(id)
	player.name = String(id)
	player.position = spawnpoint
	
	var pal = Image.new()
	var img
	if palette != null:
		pal.create_from_data(32,1,false,Image.FORMAT_RGBA8,Marshalls.base64_to_raw(palette))
		img = ImageTexture.new()
		img.create_from_image(pal, 0)
	
	#if frames != null:
	#	frames = Marshalls.base64_to_variant(frames, true)
	
	$entities.add_child(player)
	player.updateDetails(data, img)

puppet func erasePlayer(id):
	if $entities.get_node_or_null(String(id)) != null:
		$entities.get_node(String(id)).queue_free()

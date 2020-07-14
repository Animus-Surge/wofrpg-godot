extends Node

var scn
var wait
var tmax = 100

func load_scene(scene: String):
	get_tree().change_scene("res://scenes/loadscreen.tscn")
	var root = get_tree().get_root()
	for child in root.get_children():
		print(child.name)
	scn = ResourceLoader.load_interactive(scene)
	#todo: error handling
	set_process(true)
	
	wait = 1

func _process(delta):
	if scn == null:
		set_process(false)
		return
	if wait > 0:
		wait -= 1
		return
	
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + tmax:
		var err = scn.poll()
		if err == ERR_FILE_EOF:
			for child in get_tree().get_root().get_children():
				print(child.name)
			var resource = scn.get_resource()
			scn = null
			get_node("/root").add_child(resource.instance())
			get_node("/root/loadscreen").queue_free()
			#get_node("/root/loadscreen").hide()
			break
		elif err == OK:
			continue
		else:
			scn = null
			break #TODO

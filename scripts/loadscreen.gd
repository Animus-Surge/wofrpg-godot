extends Node

var loader
var wait
var maxtime = 100
var currentscene

func _ready():
	var root = get_tree().get_root()
	currentscene = root.get_child(root.get_child_count() -1)

func loadScene(scene):
	loader = ResourceLoader.load_interactive(scene)
	if loader == null:
		return
	
	currentscene.queue_free()
	
	set_process(true)
	set_scene(preload("res://scenes/loadscreen.tscn"))
	
	wait = 1
	
func _process(delta):
	if loader == null:
		set_process(false)
		return
	
	if wait > 0:
		wait -= 1
		return
	
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + maxtime:
		var err = loader.poll()
		
		if err == ERR_FILE_EOF:
			var resource = loader.get_resource()
			loader = null
			set_scene(resource)
			break
		elif err == OK:
			continue
		else:
			print(err)
			loader = null
			break

func set_scene(path):
	currentscene = path.instance()
	get_node("/root").add_child(currentscene)

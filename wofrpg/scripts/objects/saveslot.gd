extends Control

var slotidx

func initialize(cname, index, level = ""):
	if name == "Create":
		level = "New character"
	slotidx = index
	$TextureRect/cname.text = cname
	$TextureRect/clevel.text = level

func _mouse_entered():
	$AnimationPlayer.play("slot")

func _mouse_exited():
	$AnimationPlayer.play_backwards("slot")

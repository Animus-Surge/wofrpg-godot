extends Control

signal clicked(index)
signal add()

var addSlot = false
var slotidx

func initialize(cname, index, level = ""):
	if name == "Create":
		level = "New character"
	slotidx = index
	$TextureRect/cname.text = cname
	$TextureRect/clevel.text = "Level " + String(level)

func initializeAdd():
	$TextureRect/cname.text = "+ Create"
	$TextureRect/clevel.text = "New Character"
	addSlot = true

func _mouse_entered():
	$AnimationPlayer.play("slot")

func _mouse_exited():
	$AnimationPlayer.play_backwards("slot")

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			if not addSlot:
				emit_signal("clicked", slotidx)
			else:
				emit_signal("add")

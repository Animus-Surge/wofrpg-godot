extends Control

signal clicked(index)
signal add()

var addSlot = false
var slotidx

var selected = false

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
	if !selected:
		$AnimationPlayer.play("slot")

func _mouse_exited():
	if !selected:
		$AnimationPlayer.play_backwards("slot")

func unselect(): 
	if selected:
		$AnimationPlayer.play_backwards("slot")
	selected = false

func select(): 
	selected = true

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			if not addSlot:
				emit_signal("clicked", slotidx)
				selected = true
			else:
				emit_signal("add")

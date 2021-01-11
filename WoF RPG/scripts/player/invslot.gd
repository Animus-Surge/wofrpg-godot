extends TextureRect

signal use(slotid)
signal drop(slotid)

var hoverTexture = load("res://images/gui/slotbg-TEMP-hov.png")
var normTexture = load("res://images/gui/slotbg-TEMP.png")

var slotid
var storedItem = {}

func _ready():
	texture = normTexture
	$icon.texture = null

func set_item(item): # item is a dictionary
	storedItem = item
	$icon.texture = load(item.preview)

func clear():
	storedItem = {}
	$icon.texture = null

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and !storedItem.empty():
		if event.button_index == BUTTON_LEFT:
			emit_signal("use", slotid)
		elif event.button_index == BUTTON_RIGHT:
			emit_signal("drop", slotid)

func _mouse_enter():
	texture = hoverTexture

func _mouse_exit():
	texture = normTexture

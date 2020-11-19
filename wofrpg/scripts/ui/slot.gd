extends TextureButton

var item = {}
var slotnum = 0

signal use(item, num)
signal drop(item, num)

func _gui_input(event):
	if !item.empty():
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				emit_signal("use", item, slotnum)
			elif event.button_index == BUTTON_RIGHT and event.pressed:
				emit_signal("drop", item, slotnum)
				clearSlot()

func clearSlot():
	item = {}
	$TextureRect.texture = null

func setSlot(i: Dictionary):
	item = i
	$TextureRect.texture = load(i.texture)

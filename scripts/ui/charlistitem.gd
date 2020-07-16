extends HBoxContainer

signal createCharInSlot(slot)
export (int) var slotNum

func setDetails(charname: String, icon: Texture):
	$VBoxContainer/charname.text = charname
	$TextureRect.texture = icon

func onCreate():
	emit_signal("createCharInSlot", slotNum)

func onPlay():
	pass

func onDelete():
	setDetails("empty", null)

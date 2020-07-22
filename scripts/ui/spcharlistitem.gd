extends HBoxContainer

signal createCharInSlot(slot)
var slotNum

func onReady(slot):
	slotNum = slot - 1

func setDetails(charname: String, icon: Texture):
	$VBoxContainer/charname.text = charname
	$TextureRect.texture = icon

func onCreate():
	emit_signal("createCharInSlot", slotNum)

func onPlay():
	scenes.showGameHandler(cfm.characters[slotNum])

func onDelete():
	setDetails("empty", null)
	cfm.deleteCharacter(slotNum)
	if slotNum >= 1:
		self.queue_free()

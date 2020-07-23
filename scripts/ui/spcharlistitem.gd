extends HBoxContainer

signal createCharInSlot(slot)
var slotNum

var cname

func onReady(slot):
	slotNum = slot - 1

func setDetails(charname: String, icon: Texture):
	$VBoxContainer/charname.text = charname
	cname = charname
	$TextureRect.texture = icon

func onCreate():
	emit_signal("createCharInSlot", slotNum)

func onPlay():
	scenes.showGameHandler(cfm.characters[slotNum])

func onDelete():
	setDetails("empty", null)
	cfm.deleteCharacter(slotNum, cname.to_lower())
	if slotNum >= 1:
		self.queue_free()

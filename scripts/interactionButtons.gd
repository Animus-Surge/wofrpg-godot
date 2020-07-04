extends Button

var goto setget setGoto

func _pressed():
	get_parent().call("buttonPress", goto)

func setGoto(val):
	goto = val

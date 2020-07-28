extends Button

var goto: String

func setGoto(val: String):
	goto = val

func _pressed():
	get_parent().get_parent().call("buttonPress", goto)

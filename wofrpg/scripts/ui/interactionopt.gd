extends Button

var goto

func _pressed():
	get_node("../../../../..").ibtnPress(goto)

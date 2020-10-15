extends Button

signal optClicked(goto)

var goto
var locked

func _pressed():
	if !locked:
		emit_signal("optClicked", goto)

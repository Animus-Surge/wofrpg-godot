extends CheckBox

func _ready():
	self_modulate = Color(1,0.5,0)

func _toggled(button_pressed):
	get_parent().call("updateSelection")
	if button_pressed:
		self_modulate = Color(0.5, 1, 1)
	else:
		self_modulate = Color(1,0.5,0)

func _mouse_entered():
	if !disabled:
		self_modulate = Color(0,1,1)

func _mouse_exited():
	if !pressed:
		self_modulate = Color(1,0.5,0)
	else:
		self_modulate = Color(0.5, 1, 1)

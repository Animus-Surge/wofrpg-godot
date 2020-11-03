extends CheckBox

var tslotid

func _ready():
	self_modulate = Color(1,0.5,0)
# warning-ignore:return_value_discarded
	connect("mouse_entered", self, "_mouse_entered")
# warning-ignore:return_value_discarded
	connect("mouse_exited", self, "_mouse_exited")
	set("custom_icons/checked", load("res://images/ui/buttons/radio-btn.png"))
	set("custom_icons/unchecked", load("res://images/ui/buttons/radio-btn.png"))
	set("custom_fonts/font", load("res://fonts/pixel-s.tres"))
	set("custom_colors/font_color", Color.black)
	set("custom_colors/font_color_hover", Color.black)
	set("custom_colors/font_color_pressed", Color.black)
	focus_mode = Control.FOCUS_NONE

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

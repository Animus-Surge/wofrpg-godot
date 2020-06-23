extends Button

func _pressed():
	if text == "Accept":
		get_parent().confirm()
	elif text == "Decline":
		get_parent().decline()
	elif text == "Close":
		get_parent().visible = false
		get_tree().paused = false

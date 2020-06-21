extends Button

func _pressed():
	var desc = editor_description
	if desc == 'exit':
		get_tree().quit(0)
	elif desc == 'resume':
		get_tree().paused = false
		get_parent().visible = false
	elif desc == 'main':
		loadscreen.loadScene("res://scenes/menus.tscn")

extends Control

func _ready():
	hideAll()

func _show(menu: String):
	if menu == "sp":
# warning-ignore:unsafe_property_access
		get_node("sp").visible = true
	elif menu == "mp":
# warning-ignore:unsafe_property_access
		get_node("mp").visible = true
	elif menu == "set":
# warning-ignore:unsafe_property_access
		get_node("set").visible = true
	elif menu == "cred":
# warning-ignore:unsafe_property_access
		get_node("cred").visible = true
	elif menu == "exit":
		get_tree().quit(0)


func hideAll():
# warning-ignore:unsafe_property_access
	get_node("sp").visible = false
# warning-ignore:unsafe_property_access
	get_node("mp").visible = false
# warning-ignore:unsafe_property_access
	get_node("set").visible = false
# warning-ignore:unsafe_property_access
	get_node("cred").visible = false

extends Control

onready var globalvars = get_tree().get_root().get_node("globalvars")
onready var fb = get_tree().get_root().get_node("fb")

func _ready():
	globalvars.current = "useracct"
	$supanel.hide()
	$lipanel.hide()
	$statusPanel.hide()

func completed(action):
	fb.disconnect("completed", self, "completed")
	fb.disconnect("failed", self, "failed")
	$statusPanel.hide()
	$statusPanel/AnimationPlayer.stop()
	globalvars.load_scene("res://scenes/menus.tscn")

func failed(reason, action):
	fb.disconnect("completed", self, "completed")
	fb.disconnect("failed", self, "failed")
	$statusPanel.hide()
	$statusPanel/AnimationPlayer.stop()
	var temp = JSON.parse(reason).result
	match typeof(temp.error):
		TYPE_DICTIONARY:
			$lipanel/errorMessage.text = temp.error.message
			$supanel/errorMessage.text = temp.error.message
		TYPE_STRING:
			$lipanel/errorMessage.text = temp.error
			$supanel/errorMessage.text = temp.error

var shownAlready = false

func showLogin():
	if !shownAlready:
		shownAlready = true
		$lipanel.show()

func hideLogin():
	shownAlready = false
	$lipanel.hide()
	$lipanel/CheckBox.pressed = false
	$lipanel/lipass.text = ""
	$lipanel/liuname.text = ""
	$lipanel/errorMessage.text = ""
	$supanel/errorMessage.text = ""

func showSignup():
	if !shownAlready:
		shownAlready = true
		$supanel.show()

func hideSignup():
	shownAlready = false
	$supanel.hide()
	$supanel/CheckBox.pressed = false
	$supanel/suemail.text = ""
	$supanel/supass.text = ""
	$supanel/supassconfirm.text = ""
	$supanel/suuname.text = ""
	$lipanel/errorMessage.text = ""
	$supanel/errorMessage.text = ""

func loginUser():
	fb.connect("completed", self, "completed")
	fb.connect("failed", self, "failed")
	var uname = $lipanel/liuname.text
	var password = $lipanel/lipass.text
	$statusPanel.show()
	$statusPanel/Label.text = "Logging you in..."
	$statusPanel/AnimationPlayer.play("lsicon")
	$lipanel/errorMessage.text = ""
	$supanel/errorMessage.text = ""
	fb.userLogin(uname, password)

func signupUser():
	var password = $supanel/supass.text
	var passc = $supanel/supassconfirm.text
	if password == passc:
		fb.connect("completed", self, "completed")
		fb.connect("failed", self, "failed")
		$statusPanel.show()
		$statusPanel/Label.text = "Signing you up..."
		$statusPanel/AnimationPlayer.play("lsicon")
		$lipanel/errorMessage.text = ""
		$supanel/errorMessage.text = ""
		fb.userSignup($supanel/suemail.text, $supanel/suuname.text, password)

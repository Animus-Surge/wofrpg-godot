extends Control

onready var lipanel = get_node("Panel/TabContainer/Log In/Panel")
onready var supanel = get_node("Panel/TabContainer/Sign up/Panel")

onready var lierror = get_node("Panel/TabContainer/Log In/error")
onready var suerror = get_node("Panel/TabContainer/Sign up/Label")

onready var spass = get_node("Panel/TabContainer/Sign up/pass")
onready var spassc = get_node("Panel/TabContainer/Sign up/passc")
onready var semail = get_node("Panel/TabContainer/Sign up/email")
onready var suname = get_node("Panel/TabContainer/Sign up/uname")

onready var lpass = get_node("Panel/TabContainer/Log In/pass")
onready var lemail= get_node("Panel/TabContainer/Log In/email")

func _ready():
	lipanel.visible = false
	var e = get_tree().get_root().get_node("fb").connect("doneLoggingIn",self,"loginFinished")
	var a = get_tree().get_root().get_node("fb").connect("doneRegistering",self,"registerFinished")
	if e:
		print("LOGIN FINISH CONNECTION ERROR")
	if a:
		print("REGISTER FINISH CONNECTION ERROR")
	lierror.text = ""
	suerror.text = ""
	
	globalvars.setCurrentScene("useracct")

func singleplayerpressed():
	scenes.load_scene("res://scenes/menus.tscn")

func loginPressed():
	logcat.stdout("Attempting client login...", logcat.INFO)
	lipanel.visible = true
	fb.login(lemail.get_text(), lpass.get_text())

func registerPressed():
	if spass.get_text() == spassc.get_text():
		logcat.stdout("Attempting register client of user: " + suname.get_text(), logcat.INFO)
		supanel.visible = true
		fb.register(semail.get_text(), spass.get_text(), suname.get_text())

func loginFinished(error):
	if !error:
		checkLogin("login")
		logcat.stdout("Successfully logged in user: " + fb.username, logcat.INFO)
		lipanel.visible = false
		globalvars.loggedIn = true
		scenes.load_scene("res://scenes/menus.tscn")
	else:
		lierror.text = error
		lipanel.visible = false

func registerFinished(error):
	if !error:
		checkLogin("register")
		logcat.stdout("Successfully registered user with username: " + fb.username, logcat.INFO)
		supanel.visible = false
		globalvars.loggedIn = true
		scenes.load_scene("res://scenes/menus.tscn")
	else:
		suerror.text = error
		supanel.visible = false

func checkLogin(side):
	if $"Panel/TabContainer/Log In/CheckBox".pressed or $"Panel/TabContainer/Sign up/CheckBox".pressed:
		var cfgFile = File.new()
		cfgFile.open_encrypted_with_pass("user://login.ids", File.WRITE, OS.get_unique_id())
		var details
		if side == "register":
			details = semail + " " + spass
		elif side == "login":
			details = lemail + " " + lpass
		cfgFile.store_line(details)
		cfgFile.close()

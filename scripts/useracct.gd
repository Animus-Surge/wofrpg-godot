extends Control

func _ready():
	$"Panel/TabContainer/Log In/Panel".visible = false
	var e = get_tree().get_root().get_node("fb").connect("doneLoggingIn",self,"loginFinished")
	var a = get_tree().get_root().get_node("fb").connect("doneRegistering",self,"registerFinished")
	if e:
		print("LOGIN FINISH CONNECTION ERROR")
	if a:
		print("REGISTER FINISH CONNECTION ERROR")
	$"Panel/TabContainer/Log In/error".text = ""
	$"Panel/TabContainer/Sign up/Label".text = ""

func loginPressed():
	logcat.stdout("Attempting client login...", logcat.INFO)
	$"Panel/TabContainer/Log In/Panel".visible = true
	fb.login($"Panel/TabContainer/Log In/email".get_text(), $"Panel/TabContainer/Log In/pass".get_text(), $HTTPRequest)

func registerPressed():
	if $"Panel/TabContainer/Sign up/pass".get_text() == $"Panel/TabContainer/Sign up/passc".get_text():
		logcat.stdout("Attempting register client of user: " + $"Panel/TabContainer/Sign up/uname".get_text(), logcat.INFO)
		$"Panel/TabContainer/Sign up/Panel".visible = true
		fb.register($"Panel/TabContainer/Sign up/email".get_text(), $"Panel/TabContainer/Sign up/pass".get_text(), $HTTPRequest)

func loginFinished(error):
	if !error:
		$"Panel/TabContainer/Log In/Panel".visible = false
	else:
		$"Panel/TabContainer/Log In/error".text = error
		$"Panel/TabContainer/Log In/Panel".visible = false

func registerFinished(error):
	if !error:
		$"Panel/TabContainer/Sign Up/Panel".visible = false
	else:
		$"Panel/TabContainer/Sign up/Label".text = error
		$"Panel/TabContainer/Sign up/Panel".visible = false

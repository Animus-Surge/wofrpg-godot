extends Control

var loggedIn = false

func _ready():
	showSI()
	$main/addonspanel.hide()
	$main/newspanel.hide()

func showMain():
	$main/sidebar/addon.disabled = false
	$main/sidebar/news.disabled = false
	$main/sidebar/home.disabled = true
	
	$main/addonspanel.hide()
	$main/newspanel.hide()

##########################
# Callbacks from buttons #
##########################

func onSidebarShowPressed():
	$AnimationPlayer.play("sidebar-showhide")
func onSidebarHidePressed():
	$AnimationPlayer.play_backwards("sidebar-showhide")

func showSI():
	$signup.hide()
	$signin.show()
func showSU():
	$signup.show()
	$signin.hide()

##################
# SU/LI handlers #
##################

func suVisChanged():
	$signup/email.modulate = Color.white
	$signup/uname.modulate = Color.white
	$signup/password.modulate = Color.white
	$signup/passwordc.modulate = Color.white
	$signup/errorlabel.text = ""

func siVisChanged():
	$signin/uname.modulate = Color.white
	$signin/password.modulate = Color.white
	$signin/errorlabel.text = ""

func signupPressed():
	$signup/email.editable = false
	$signup/uname.editable = false
	$signup/password.editable = false
	$signup/passwordc.editable = false
	suVisChanged()
	if $signup/uname.text == "":
		$signup/uname.modulate = Color.red
		$signup/errorlabel.text = "Username cannot be blank"
		return
	var pw = get_node("signup/password").text
	var pwc = get_node("signup/passwordc").text
	if pw != pwc:
		$signup/errorlabel.text = "Passwords don't match"
		$signup/password.modulate = Color.red
		$signup/passwordc.modulate = Color.red
		return
	if pw == "":
		$signup/password.modulate = Color.red
		$signup/errorlabel.text = "Password cannot be blank"
		return
	if pwc == "":
		$signup/passwordc.modulate = Color.red
		$signup/errorlabel.text = "Password Confirm cannot be blank"
		return
	if !isValidEmail($signup/email.text):
		$signup/email.modulate = Color.red
		return
	$firebase.signUp($signup/uname.text, $signup/email.text, pw)

func loginPressed():
	$signin/password.editable = false
	$signin/uname.editable = false
	siVisChanged()
	var uname = $signin/uname.text
	var pw = $signin/password.text
	
	if uname == "":
		$signin/errorlabel.text = "Username cannot be blank"
		$signin/uname.modulate = Color.red
	if pw == "":
		$signin/errorlabel.text = "Password cannot be blank"
		$signin/password.modulate = Color.red
	
	$firebase.signIn(uname, pw)

func forgotPassword(): #TODO
	pass

func errored(type, id):
	$signin/password.editable = true
	$signin/email.editable = true
	$signup/email.editable = true
	$signup/uname.editable = true
	$signup/password.editable = true
	$signup/passwordc.editable = true
	match id:
		"ERR_EMAIL_INVALID":
			$signup/errorlabel.text = type
			$signup/email.modulate = Color.red
		"ERR_EMAIL_EXISTS":
			$signup/errorlabel.text = type
			$signup/email.modulate = Color.red
		"ERR_HTTP-PUT_FAILURE":
			$signup/errorlabel.text = type
			$signin/errorlabel.text = type
		"ERR_PASSWORD_INVALID":
			$signup/password.modulate = Color.red
			$signup/errorlabel.text = type
		"ERR_UNKNOWN_USERNAME":
			$signin/errorlabel.text = type
			$signin/uname.modulate = Color.red

func success(type, _data):
	match type:
		"TYPE_LOGIN":
			$signin.hide()
			$signup.hide()
			$signin/password.editable = true
			$signin/uname.editable = true
			$main/sidebar/controlpanel/unamelabel.text = $firebase.username
			loggedIn = true
		"TYPE_SIGNUP":
			$signin.hide()
			$signup.hide()
			$signup/email.editable = true
			$signup/uname.editable = true
			$signup/password.editable = true
			$signup/passwordc.editable = true
			$main/sidebar/controlpanel/unamelabel.text = $firebase.username
			loggedIn = true
		"TYPE_DBFETCH":
			pass
		"TYPE_DBSTORE":
			pass

func rememberToggle(_button_pressed):
	$firebase.remember = _button_pressed

##################
# Misc functions #
##################

func isValidEmail(email:String) -> bool:
	if email.find("@") == -1:
		return false
	if email.find(".com") == -1 and email.find(".net") == -1 and email.find(".org") == -1 and email.find(".edu") == -1:
		return false
	return true

#################
# News Handling #
#################

func showNewsPanel():
	$main/sidebar/news.disabled = true
	$main/sidebar/addon.disabled = false
	$main/sidebar/home.disabled = false
	
	$main/newspanel.show()
	$main/addonspanel.hide()

func newsRefresh():
	pass

##################
# Addon Handling #
##################

func showAddonsPanel():
	$main/sidebar/addon.disabled = true
	$main/sidebar/home.disabled = false
	$main/sidebar/news.disabled = false
	
	$main/newspanel.hide()
	$main/addonspanel.show()

func addonRefresh():
	pass

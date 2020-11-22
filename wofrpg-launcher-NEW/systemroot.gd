extends Control

var loggedIn = false
var working = false
var initial = false

var releases := []

func _ready():
	var loginFile = File.new()
	var err = loginFile.open("user://temp/login.pwu", File.READ)
	if err != OK:
		showSI()
	else:
		var loginData = loginFile.get_as_text().split(";")
		match loginData.size():
			2:
				showSI()
			3:
				if loginData[2] == "persistent":
					print("Found login.pwu file, detected persistent login. Logging in...")
					pass #show a fullscreen status dialogue
					$firebase.signIn(loginData[0], loginData[1])
					yield($firebase, "success")
					showMain()

func showMain():
	$dialogues.hide()
	if !initial:
		$firebase.readDatabase("releases.json")
		initial = true
	
	$main/sidebar/addon.disabled = false
	$main/sidebar/news.disabled = false
	$main/sidebar/home.disabled = true
	
	$main/addonspanel.hide()
	$main/newspanel.hide()

func play():
	working = true
	$main/playbtn.disabled = true
	$main/playbtn.text = "Working..."
	$firebase.checkUpdate()

#############
# Dialogues #
#############

func errorDialogue(title, message):
	$dialogues/error/message.text = message
	$dialogues/error/title.text = title
	$dialogues.show()

func dismiss():
	$dialogues.hide()

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

####################
# Firebase Signals #
####################

func errored(type, id):
	$signin/password.editable = true
	$signin/uname.editable = true
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
		"ERR_PASSWORD_INVALID", "ERR_INVALID_PASSWORD":
			$signup/password.modulate = Color.red
			$signup/errorlabel.text = type
			$signin/password.modulate = Color.red
			$signin/errorlabel.text = type
		"ERR_UNKNOWN_USERNAME":
			$signin/errorlabel.text = type
			$signin/uname.modulate = Color.red
		"ERR_UPDATEFETCH":
			working = false
			if Directory.new().exists("user://bin/wofrpg.pck"):
				print("Unable to get new update, launching current version")
				OS.shell(ProjectSettings.globalize_path("user://bin/wofrpg.exe"))
			else:
				pass #dialogue
			#run the game's current version, or show a dialogue if wofrpg.pck does not exist

func success(type, data):
	match type:
		"TYPE_LOGIN":
			print("Successfully logged in.")
			$signin.hide()
			$signup.hide()
			$signin/password.editable = true
			$signin/uname.editable = true
			$main/sidebar/controlpanel/unamelabel.text = $firebase.username
			showMain()
			loggedIn = true
		"TYPE_SIGNUP":
			print("Successfully signed up.")
			$signin.hide()
			$signup.hide()
			$signup/email.editable = true
			$signup/uname.editable = true
			$signup/password.editable = true
			$signup/passwordc.editable = true
			$main/sidebar/controlpanel/unamelabel.text = $firebase.username
			showMain()
			loggedIn = true
		"TYPE_DBFETCH":
			pass
		"TYPE_DBSTORE":
			pass
		"TYPE_UPDATEFETCH":
			if data.hasUpdate:
				print("Has update. Downloading...")
				$HTTPRequest.request(data.url)
				var file = yield($HTTPRequest, "request_completed") as Array
				if file[1] != 200:
					print("Unable to download update. Error code: " + String(file[1]))
					$main/playbtn.disabled = false
					$main/playbtn.text = "Play"
					return
				var pck = File.new()
				pck.open("user://bin/wofrpg.pck", File.WRITE)
				pck.store_buffer(file[3])
				pck.close()
				print("Saved new pck file. Launching...")
				Directory.new().remove("user://version.json")
				pck.open("user://version.json", File.WRITE)
				pck.store_line(to_json({"version":data.version}))
				var err = OS.shell_open(ProjectSettings.globalize_path("user://bin/wofrpg.exe"))
				if err != OK:
					print(err)
				$main/playbtn.disabled = false
				$main/playbtn.text = "Play"
			else:
				print("No update required. Launching...")
				print(ProjectSettings.globalize_path("user://bin/wofrpg.exe"))
				var err = OS.shell_open(ProjectSettings.globalize_path("user://bin/wofrpg.exe"))
				if err != OK:
					print(err)
				$main/playbtn.disabled = false
				$main/playbtn.text = "Play"

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

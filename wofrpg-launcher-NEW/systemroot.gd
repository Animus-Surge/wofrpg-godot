extends Control

onready var addonSlot = preload("res://addon.tscn")

var loggedIn = false
var working = false
var initial = false

func _ready():
	var loginFile = File.new()
	var dir = Directory.new()
	if not dir.dir_exists("user://temp"):
		dir.make_dir("user://temp")
	if not dir.dir_exists("user://bin"):
		dir.make_dir("user://bin")
	var err = loginFile.open("user://temp/login.pwu", File.READ)
	if err != OK:
		print(String(err))
		showSI()
	else:
		var loginData = loginFile.get_as_text().split(";")
		match loginData.size():
			2:
				showSI()
			3:
				if loginData[2].strip_edges() == "persistent":
					print("Found login.pwu file, detected persistent login. Logging in...")
					$firebase.signIn(loginData[0], loginData[1])
					yield($firebase, "success")
					showMain()
				else:
					showSI()

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
	
	addonRefresh()
	newsRefresh()

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
	$firebase.signUp($signup/uname.text, $signup/email.text, pw, $signup/CheckBox.pressed)

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
	
	$firebase.signIn(uname, pw, $signin/CheckBox.pressed)

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

func checkRemember():
	if $signin/CheckBox.pressed or $signup/CheckBox.pressed:
		pass

var fetching: String

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
			if fetching == "addons":
				fetching = ""
				if data == null: return
				for addon in data:
					var slot = addonSlot.instance()
					slot.initAddon(addon.name, addon.web, addon.download)
					$main/addonspanel/ScrollContainer/VBoxContainer.add_child(slot)
		"TYPE_DBSTORE":
			pass
		"TYPE_UPDATEFETCH":
			var dir = Directory.new()
			var exepath = ""
			match OS.get_name():
				"Windows":
					if not dir.file_exists("user://bin/wofrpg.exe"):
						print("Could not find executable. Downloading for Windows...")
						$HTTPRequest.request("https://www.dropbox.com/s/pox86jrzm3s9ooj/wofrpg.exe?dl=1")
						var result = yield($HTTPRequest, "request_completed") as Array
						if result[1] != 200:
							print("Failed to download executable.")
							errorDialogue("Failed to fetch executable", "We could not fetch the executable to run the game. Please try again later.")
							$main/playbtn.disabled = false
							$main/playbtn.text = "Play"
							return
						var exefile = File.new()
						var _err = exefile.open("user://bin/wofrpg.exe", File.WRITE)
						exefile.store_buffer(result[3])
						exefile.close()
					exepath = "user://bin/wofrpg.exe"
				"OSX":
					if not dir.file_exists("user://bin/wofrpg.app"):
						print("Could not find executable. Downloading for Mac OS...")
						$HTTPRequest.request("https://www.dropbox.com/sh/np58n20l4gvif3w/AAAAV3OJcUHmqeX9RFwDNDEOa?dl=1")
						var result = yield($HTTPRequest, "request_completed") as Array
						if result[1] != 200:
							print("Failed to download executable.")
							errorDialogue("Failed to fetch executable", "We could not fetch the executable to run the game. Please try again later.")
							$main/playbtn.disabled = false
							$main/playbtn.text = "Play"
							return
						var exefile = File.new()
						var _err = exefile.open("user://bin/wofrpg.app", File.WRITE)
						exefile.store_buffer(result[3])
						exefile.close()
					exepath = "user://bin/wofrpg.app"
				"X11":
					if not dir.file_exists("user://bin/wofrpg.x86_64"):
						print("Could not find executable. Downloading for Linux...")
						$HTTPRequest.request("https://www.dropbox.com/s/ynvabz99l1gs08y/wofrpg.x86_64?dl=1")
						var result = yield($HTTPRequest, "request_completed") as Array
						if result[1] != 200:
							print("Failed to download executable.")
							errorDialogue("Failed to fetch executable", "We could not fetch the executable to run the game. Please try again later.")
							$main/playbtn.disabled = false
							$main/playbtn.text = "Play"
							return
						var exefile = File.new()
						var _err = exefile.open("user://bin/wofrpg.x86_64", File.WRITE)
						exefile.store_buffer(result[3])
						exefile.close()
# warning-ignore:return_value_discarded
						OS.shell_open("chmod +x " + ProjectSettings.globalize_path("user://bin/wofrpg.x86_64"))
					exepath = "user://bin/wofrpg.x86_64"
			if data.hasUpdate or not dir.file_exists("user://bin/wofrpg.pck"):
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
# warning-ignore:return_value_discarded
				Directory.new().remove("user://version.json")
				pck.open("user://version.json", File.WRITE)
				pck.store_line(to_json({"version":data.version}))
				print(ProjectSettings.globalize_path(exepath))
				var err = OS.shell_open(ProjectSettings.globalize_path(exepath))
				if err != OK:
					print(err)
				$main/playbtn.disabled = false
				$main/playbtn.text = "Play"
			else:
				print("No update required. Launching...")
				print(ProjectSettings.globalize_path(exepath))
				var err = OS.shell_open(ProjectSettings.globalize_path(exepath))
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
	for slot in $main/addonspanel/ScrollContainer/VBoxContainer.get_children():
		$main/addonspanel/ScrollContainer/VBoxContainer.remove_child(slot)
	fetching = "addons"
	$firebase.readDatabase("addons.json") #Array of dictionaries

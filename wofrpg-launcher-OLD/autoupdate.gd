extends Node

func _ready():
	$AnimationPlayer.play("lsanim")
	print("AUTOUPDATE: Checking for updates...")
	var http = $HTTPRequest
	http.request("https://wofrpg-main.firebaseio.com/release-latest.json")
	var result = yield(http, "request_completed") as Array
	if result[1] != 200:
		print("AUTOUPDATE: HTTP request error - " + String(result[1]))
		fail()
	else:
		if result[3].get_string_from_ascii() != "null":
			var jres = JSON.parse(result[3].get_string_from_ascii()).result
			var verfile = File.new()
			var err = verfile.open("user://version.json", File.READ)
			if err == ERR_FILE_NOT_FOUND:
				$status.text = "Downloading assets..."
				print("AUTOUPDATE: Version file not found, assuming fresh install")
				http.request(jres.url)
				result = yield(http, "request_completed") as Array
				if result[1] == 200:
					$status.text = "Writing new data..."
					var gamepckfile = File.new()
					print("AUTOUPDATE: Request complete. Writing data to pck file...")
					var dir = Directory.new()
					if not dir.dir_exists("user://bin"): dir.make_dir("user://bin")
					gamepckfile.open("user://bin/wofrpg.pck", File.WRITE)
					gamepckfile.store_buffer(result[3])
					gamepckfile.close()
					verfile.open("user://version.json", File.WRITE)
					verfile.store_line(to_json({"version":jres.version}))
					verfile.close()
					if ProjectSettings.load_resource_pack("user://bin/wofrpg.pck", false):
						$status.text = "Loading..."
						var lcat = Node.new()
						lcat.set_script(load("res://scripts/global/logger.gd"))
						lcat.name = "logcat"
						get_tree().get_root().add_child(lcat)
						
						var glhttp = HTTPRequest.new()
						glhttp.name = "http"
						get_tree().get_root().add_child(glhttp)
						
						var gltimer = Timer.new()
						gltimer.name = "timer"
						get_tree().get_root().add_child(gltimer)
						
						var gl = Node.new()
						gl.set_script(load("res://scripts/global/globalLoader.gd"))
						gl.name = "gloader"
						get_tree().get_root().add_child(gl)
						
						var charfile = Node.new()
						charfile.set_script(load("res://scripts/filemanager/characterFileHandler.gd"))
						charfile.name = "cfm"
						get_tree().get_root().add_child(charfile)
						
						var gvars = Node.new()
						gvars.set_script(load("res://scripts/global/gvars.gd"))
						gvars.name = "globalvars"
						get_tree().get_root().add_child(gvars)
						
						var timer = Timer.new()
						timer.name = "timer"
						
						var loadingscreen = load("res://scenes/loadscreen.tscn")
						get_tree().get_root().add_child(loadingscreen.instance())
						gvars.load_scene("res://scenes/useracct.tscn")
						
						var firebase = Node.new()
						firebase.set_script(load("res://scripts/global/firebase.gd"))
						firebase.name = "fb"
						get_tree().get_root().add_child(firebase)
						print("AUTOUPDATE: Loaded singletons")
						queue_free()
					else:
						print("AUTOUPDATE: Failed to load resource pack")
						$status.text = "PCK loading failed. Aborting..."
						get_tree().quit()
			elif err == OK:
				if JSON.parse(verfile.get_as_text()).result.version == jres.version:
					print("AUTOUPDATE: No update needed. Loading resource pack")
					if ProjectSettings.load_resource_pack("user://bin/wofrpg.pck", false):
						$status.text = "Loading..."
						var lcat = Node.new()
						lcat.set_script(load("res://scripts/global/logger.gd"))
						lcat.name = "logcat"
						get_tree().get_root().add_child(lcat)
						
						var glhttp = HTTPRequest.new()
						glhttp.name = "http"
						get_tree().get_root().add_child(glhttp)
						
						var gltimer = Timer.new()
						gltimer.name = "timer"
						get_tree().get_root().add_child(gltimer)
						
						var gl = Node.new()
						gl.set_script(load("res://scripts/global/globalLoader.gd"))
						gl.name = "gloader"
						get_tree().get_root().add_child(gl)
						
						var charfile = Node.new()
						charfile.set_script(load("res://scripts/filemanager/characterFileHandler.gd"))
						charfile.name = "cfm"
						get_tree().get_root().add_child(charfile)
						
						var gvars = Node.new()
						gvars.set_script(load("res://scripts/global/gvars.gd"))
						gvars.name = "globalvars"
						get_tree().get_root().add_child(gvars)
						
						var timer = Timer.new()
						timer.name = "timer"
						
						var loadingscreen = load("res://scenes/loadscreen.tscn")
						get_tree().get_root().add_child(loadingscreen.instance())
						
						var firebase = Node.new()
						firebase.set_script(load("res://scripts/global/firebase.gd"))
						firebase.name = "fb"
						get_tree().get_root().add_child(firebase)
						
						print("AUTOUPDATE: Loaded singletons")
						queue_free()
					else:
						print("AUTOUPDATE: Failed to load resource pack")
						$status.text = "PCK loading failed. Aborting..."
						get_tree().quit()
				else:
					print("AUTOUPDATE: Update needed")
					$status.text = "Update found. Downloading new assets..."
					var gamepckfile = File.new()
					http.request(jres.url)
					result = yield(http, "request_completed") as Array
					if result[1] == 200:
						print("AUTOUPDATE: Request completed. Writing data to pck file...")
						$status.text = "Writing new data..."
						var dir = Directory.new()
						if not dir.dir_exists("user://bin"): dir.make_dir("user://bin")
						gamepckfile.open("user://bin/wofrpg.pck", File.WRITE)
						gamepckfile.store_buffer(result[3])
						gamepckfile.close()
						verfile.open("user://version.json", File.WRITE)
						verfile.store_line(to_json({"version":jres.version}))
						verfile.close()
						if ProjectSettings.load_resource_pack("user://bin/wofrpg.pck", false):
							$status.text = "Loading..."
							var lcat = Node.new()
							lcat.set_script(load("res://scripts/global/logger.gd"))
							lcat.name = "logcat"
							get_tree().get_root().add_child(lcat)
							
							var glhttp = HTTPRequest.new()
							glhttp.name = "http"
							get_tree().get_root().add_child(glhttp)
							
							var gltimer = Timer.new()
							gltimer.name = "timer"
							get_tree().get_root().add_child(gltimer)
							
							var gl = Node.new()
							gl.set_script(load("res://scripts/global/globalLoader.gd"))
							gl.name = "gloader"
							get_tree().get_root().add_child(gl)
							
							var charfile = Node.new()
							charfile.set_script(load("res://scripts/filemanager/characterFileHandler.gd"))
							charfile.name = "cfm"
							get_tree().get_root().add_child(charfile)
							
							var gvars = Node.new()
							gvars.set_script(load("res://scripts/global/gvars.gd"))
							gvars.name = "globalvars"
							get_tree().get_root().add_child(gvars)
							
							var timer = Timer.new()
							timer.name = "timer"
							
							var firebase = Node.new()
							firebase.set_script(load("res://scripts/global/firebase.gd"))
							firebase.name = "fb"
							get_tree().get_root().add_child(firebase)
							
							var loadingscreen = load("res://scenes/loadscreen.tscn")
							get_tree().get_root().add_child(loadingscreen.instance())
							
							print("AUTOUPDATE: Loaded singletons")
							queue_free()
						else:
							print("AUTOUPDATE: Failed to load resource pack")
						fail()
					else:
						print("AUTOUPDATE: request failed. " + String(result[1]))
						fail()

func fail():
	$Timer.wait_time = 1.5
	$Timer.start()
	yield($Timer, "timeout")
	get_tree().quit()

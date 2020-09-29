extends Node

const debug = true

onready var globalvars = load("res://scripts/global/gvars.gd")
onready var fb = load("res://scripts/global/firebase.gd")
onready var gloader = load("res://scripts/global/globalLoader.gd")
onready var cfm = load("res://scripts/filemanager/characterFileHandler.gd")
onready var logcat = load("res://scripts/global/logger.gd")

onready var root = get_tree().get_root()

signal complete()

func _ready():
	if debug:
		var lcat = Node.new()
		lcat.set_script(load("res://scripts/global/logger.gd"))
		lcat.name = "logcat"
		
		var glhttp = HTTPRequest.new()
		glhttp.name = "http"
		
		var gltimer = Timer.new()
		gltimer.name = "timer"
		
		var gl = Node.new()
		gl.set_script(load("res://scripts/global/globalLoader.gd"))
		gl.name = "gloader"
		
		var charfile = Node.new()
		charfile.set_script(load("res://scripts/filemanager/characterFileHandler.gd"))
		charfile.name = "cfm"
		
		var gvars = Node.new()
		gvars.set_script(load("res://scripts/global/gvars.gd"))
		gvars.name = "globalvars"
		
		var firebase = Node.new()
		firebase.set_script(load("res://scripts/global/firebase.gd"))
		firebase.name = "fb"
		
		get_tree().get_root().call_deferred("add_child", lcat)
		get_tree().get_root().call_deferred("add_child", glhttp)
		get_tree().get_root().call_deferred("add_child", gltimer)
		get_tree().get_root().call_deferred("add_child", gl)
		get_tree().get_root().call_deferred("add_child", charfile)
		get_tree().get_root().call_deferred("add_child", gvars)
		get_tree().get_root().call_deferred("add_child", firebase)
		
		emit_signal("complete")

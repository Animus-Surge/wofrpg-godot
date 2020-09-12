extends Control

onready var spine = get_node("spikes")
onready var body = get_node("body")
onready var legs = get_node("legs")
onready var tail = get_node("tail")
onready var head = get_node("head")
onready var wings = get_node("wings")
onready var eyedrop = get_node("eyedrop")

#TODO: have it load from previously used slot (FileManager TODO) and have the four character slots

func _ready():
	pass

func scalesChangedC(color):
	pass

func eyesChangedC(color):
	pass

func hornsChangedC(color):
	pass

func wingsChangedC(color):
	pass

func spineChangedC(color):
	pass

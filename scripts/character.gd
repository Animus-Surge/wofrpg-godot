extends Control

onready var spine = get_node("spikes")
onready var body = get_node("body")
onready var legs = get_node("legs")
onready var tail = get_node("tail")
onready var head = get_node("head")
onready var wings = get_node("wings")
onready var eyedrop = get_node("eyedrop")

onready var headpalette = load("res://images/character/palettes/head-palette.png")
onready var scalepalette = load("res://images/character/palettes/body_leg_tail-palette.png")
onready var wingpalette = load("res://images/character/palettes/wing-palette.png")

#TODO: have it load from previously used slot (FileManager TODO) and have the four character slots

func _ready():
	pass

func scalesChangeC(color):
	pass

func eyesChangeC(color):
	pass

func hornsChangeC(color):
	pass

func wingsChangeC(color):
	pass

func spineChangeC(color):
	pass

func partChange(part, tribe):
	pass

extends Control

onready var spine = get_node("spine")
onready var body = get_node("body")
onready var legs = get_node("legs")
onready var tail = get_node("tail")
onready var head = get_node("head")
onready var wings = get_node("wings")
onready var eyedrop = get_node("eyedrop")

var hc
var wc
var sc
#TODO: have it load from previously used slot (FileManager TODO) and have the four character slots

func _ready():
	var headpalette = ImageTexture.new()
	headpalette.load("res://images/character/palettes/head-palette.png")
	var scalepalette = ImageTexture.new()
	scalepalette.load("res://images/character/palettes/body_leg_tail-palette.png")
	var wingpalette = ImageTexture.new()
	wingpalette.load("res://images/character/palettes/wing-palette.png")
	
	hc = ImageTexture.new()
	hc.create_from_image(headpalette.get_data())
	
	wc = ImageTexture.new()
	wc.create_from_image(wingpalette.get_data())
	
	sc = ImageTexture.new()
	sc.create_from_image(scalepalette.get_data())

func loadDataFromFiles(cslot):
	pass

func scalesChangeC(color):
	var tempa = sc.get_data()
	var tempb = hc.get_data()
	
	var darker = Color(color.r-0.08, color.g-0.08, color.b-0.08)
	
	tempa.lock()
	tempa.set_pixel(0,0,darker)
	tempa.set_pixel(1,0,color)
	tempa.unlock()
	
	tempb.lock()
	tempb.set_pixel(1,0,color)
	tempb.unlock()
	
	var scaletemp = ImageTexture.new()
	var headtemp = ImageTexture.new()
	
	scaletemp.create_from_image(tempa, 0)
	scaletemp.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
	
	headtemp.create_from_image(tempb, 0)
	headtemp.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
	
	$body.get_material().set_shader_param("palette", scaletemp)
	$tail.get_material().set_shader_param("palette", scaletemp)
	$legs.get_material().set_shader_param("palette", scaletemp)
	
	$head.get_material().set_shader_param("palette", headtemp)
	
	hc = headtemp
	sc = scaletemp

func eyesChangeC(color):
	var temp = hc.get_data()
	
	temp.lock()
	temp.set_pixel(2,0, color)
	temp.unlock()
	
	var headtemp = ImageTexture.new()
	headtemp.create_from_image(temp, 0)
	headtemp.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
	
	$head.get_material().set_shader_param("palette", headtemp)
	
	hc = headtemp

func hornsChangeC(color):
	var temp = hc.get_data()
	
	temp.lock()
	temp.set_pixel(0,0, color)
	temp.unlock()
	
	var headtemp = ImageTexture.new()
	headtemp.create_from_image(temp, 0)
	headtemp.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
	
	$head.get_material().set_shader_param("palette", headtemp)
	
	hc = headtemp

func wingsChangeC(color):
	var temp = wc.get_data()
	var darker = Color(color.r-0.08, color.g-0.08, color.b-0.08)
	
	temp.lock()
	temp.set_pixel(1,0, color)
	temp.set_pixel(0,0, darker)
	temp.unlock()
	
	var wingtemp = ImageTexture.new()
	wingtemp.create_from_image(temp, 0)
	wingtemp.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
	
	$wings.get_material().set_shader_param("palette", wingtemp)
	
	wc = wingtemp

func spineChangeC(color):
	$spine.self_modulate = color

#tribes
#iw - 0
#mw - 1
#nw - 2
#rw - 3
#saw - 4
#sew - 5
#skw - 6
#...

func partChange(part, tribe):
	pass #TODO

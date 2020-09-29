extends Control

onready var spine = get_node("spine")
onready var body = get_node("body")
onready var legs = get_node("legs")
onready var tail = get_node("tail")
onready var head = get_node("head")
onready var wings = get_node("wings")
onready var eyedrop = get_node("eyedrop")

onready var gloader = get_tree().get_root().get_node("gloader")

var hc
var wc
var sc
#TODO: have it load from previously used slot (FileManager TODO) and have the four character slots

func _ready():
	var palh = load("res://images/character/palettes/head-palette.png")
	var pals = load("res://images/character/palettes/body_leg_tail-palette.png")
	var palw = load("res://images/character/palettes/wing-palette.png")
	
	hc = ImageTexture.new()
	hc.create_from_image(palh, 0)
	
	wc = ImageTexture.new()
	wc.create_from_image(palw, 0)
	
	sc = ImageTexture.new()
	sc.create_from_image(pals, 0)
	
	$body.texture = null
	$body.get_material().set_shader_param("mask", null)
	$wings.texture = null
	$wings.get_material().set_shader_param("mask", null)
	$legs.texture = null
	$legs.get_material().set_shader_param("mask", null)
	$tail.texture = null
	$tail.get_material().set_shader_param("mask", null)
	$head.texture = null
	$head.get_material().set_shader_param("mask", null)
	$spine.texture = null
	$eyedrop.visible = false
	$spine.visible = false

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

func bodyChanged(index): #index is the tribe index
	if index == 0:
		$body.texture = null
		return
	
	var tdataind = gloader.loadedtribes[index-1]
	for part in tdataind.appearancesidle:
		if "body" in part:
			$body.texture = load(part)
			break
	for partmask in tdataind.appearancesidlemask:
		if "body" in partmask:
			$body.get_material().set_shader_param("mask", load(partmask))
			break

func wingsChanged(index):
	if index == 0:
		$wings.texture = null
		return
	
	var tdataind = gloader.loadedtribes[index-1]
	for part in tdataind.appearancesidle:
		if "wings" in part:
			$wings.texture = load(part)
			break
	for partmask in tdataind.appearancesidlemask:
		if "wings" in partmask:
			$wings.get_material().set_shader_param("mask", load(partmask))
			break

func tailChanged(index):
	if index == 0:
		$wings.texture = null
		return
	
	var tdataind = gloader.loadedtribes[index-1]
	for part in tdataind.appearancesidle:
		if "tail" in part:
			$tail.texture = load(part)
			break
	for partmask in tdataind.appearancesidlemask:
		if "tail" in partmask:
			$tail.get_material().set_shader_param("mask", load(partmask))
			break

func headChanged(index):
	if index == 0:
		$head.texture = null
		return
	
	var tdataind = gloader.loadedtribes[index-1]
	for part in tdataind.appearancesidle:
		if "head" in part:
			$head.texture = load(part)
			break
	for partmask in tdataind.appearancesidlemask:
		if "head" in partmask:
			$head.get_material().set_shader_param("mask", load(partmask))
			break

func legsChanged(index):
	if index == 0:
		$legs.texture = null
		return
	
	var tdataind = gloader.loadedtribes[index-1]
	for part in tdataind.appearancesidle:
		if "legs" in part:
			$legs.texture = load(part)
			break
	for partmask in tdataind.appearancesidlemask:
		if "legs" in partmask:
			$legs.get_material().set_shader_param("mask", load(partmask))
			break

func spineChanged(index):
	if index == 0:
		$spine.texture = null
		return
	
	var tdataind = gloader.loadedtribes[index - 1]
	for part in tdataind.appearancesidle:
		if "spine" in part:
			$spine.texture = load(part)

func spineToggle(button_pressed):
	$spine.visible = button_pressed

func edropToggle(button_pressed):
	$eyedrop.visible = button_pressed

extends Control

onready var spine = get_node("spine")
onready var body = get_node("body")
onready var legs = get_node("legs")
onready var tail = get_node("tail")
onready var head = get_node("head")
onready var wings = get_node("wings")
onready var eyedrop = get_node("eyedrop")

onready var ddhead = get_parent().get_node("customization/TabContainer/Appearance/Parent/partScroll/GridContainer/head")
onready var ddbody = get_parent().get_node("customization/TabContainer/Appearance/Parent/partScroll/GridContainer/body")
onready var ddwings = get_parent().get_node("customization/TabContainer/Appearance/Parent/partScroll/GridContainer/wings")
onready var ddtail = get_parent().get_node("customization/TabContainer/Appearance/Parent/partScroll/GridContainer/tail")
onready var ddlegs = get_parent().get_node("customization/TabContainer/Appearance/Parent/partScroll/GridContainer/legs")
onready var ddspine = get_parent().get_node("customization/TabContainer/Appearance/Parent/partScroll/GridContainer/spine")
onready var ddtdec = get_parent().get_node("customization/TabContainer/Appearance/Parent/partScroll/GridContainer/td")

var mainPalette
var mp

func _ready():
	mainPalette = load("res://images/character/palettes/palette-main.tex")
	mp = mainPalette
	
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
	$spine.get_material().set_shader_param("mask", null)
	$tdec.texture = null
	$tdec.get_material().set_shader_param("mask", null)
	$eyedrop.visible = false
	$spine.visible = false
	$tdec.visible = false

func reset():
	mp = mainPalette
	
	scalesChangeC(Color.white)
	wingsChangeC(Color.white)
	eyesChangeC(Color.white)
	hornsChangeC(Color.white)
	spineChangeC(Color.white)
	tdecChangeC(Color.white)
	
	$head.texture = null
	$body.texture = null
	$wings.texture = null
	$legs.texture = null
	$tail.texture = null
	$spine.texture = null
	$tdec.visible = false
	
	spineToggle(false)
	edropToggle(false)

func loadDataFromFiles(dataarr):
	#print(dataarr[1])
	$body.get_material().set_shader_param("palette", dataarr[1])
	$legs.get_material().set_shader_param("palette", dataarr[1])
	$tail.get_material().set_shader_param("palette", dataarr[1])
	$head.get_material().set_shader_param("palette", dataarr[1])
	$wings.get_material().set_shader_param("palette", dataarr[1])
	$spine.get_material().set_shader_param("palette", dataarr[1])
	$tdec.get_material().set_shader_param("palette", dataarr[1])
	
# warning-ignore:unused_variable
	var index = 0
	for tribe in gloader.loadedtribes:
		if tribe.tribename == dataarr[0].appearances.body:
			$body.texture = load(tribe.appearancesidle[2])
			$body.get_material().set_shader_param("mask", load(tribe.appearancesidlemask[2]))
			break
		index += 1
	index = 0
	for tribe in gloader.loadedtribes:
		if tribe.tribename == dataarr[0].appearances.wings:
			$wings.texture = load(tribe.appearancesidle[4])
			$wings.get_material().set_shader_param("mask", load(tribe.appearancesidlemask[4]))
			break
		index += 1
	index = 0
	for tribe in gloader.loadedtribes:
		if tribe.tribename == dataarr[0].appearances.tail:
			$tail.texture = load(tribe.appearancesidle[3])
			$tail.get_material().set_shader_param("mask", load(tribe.appearancesidlemask[3]))
			break
		index += 1
	index = 0
	for tribe in gloader.loadedtribes:
		if tribe.tribename == dataarr[0].appearances.head:
			$head.texture = load(tribe.appearancesidle[0])
			$head.get_material().set_shader_param("mask", load(tribe.appearancesidlemask[0]))
			break
		index += 1
	index = 0
	for tribe in gloader.loadedtribes:
		if tribe.tribename == dataarr[0].appearances.legs:
			$legs.texture = load(tribe.appearancesidle[1])
			$legs.get_material().set_shader_param("mask", load(tribe.appearancesidlemask[1]))
			break
		index += 1
	index = 0
	for tribe in gloader.loadedtribes:
		if tribe.tribename == dataarr[0].appearances.spine:
			$spine.texture = load(tribe.appearancesidle[5])
			$spine.get_material().set_shader_param("mask", load(tribe.appearancesidlemask[5]))
			break
		index += 1
	index = 0
	for tribe in gloader.loadedtribes:
		if tribe.tribename == dataarr[0].appearances.tdec:
			$tdec.texture = load(tribe.appearancesidle[7])
			$tdec.get_material().set_shader_param("mask", load(tribe.appearancesidlemask[6]))
			break
		index += 1
	
	$spine.visible = dataarr[0].appearances.sshow
	$eyedrop.visible = dataarr[0].appearances.eshow
	$tdec.visible = dataarr[0].appearances.tshow

func scalesChangeC(color): #0 and 1
	var temp = mp.get_data()
	var darker = Color(color.r - 0.08, color.g - 0.08, color.b - 0.08)
	
	temp.lock()
	temp.set_pixel(0,0,color)
	temp.set_pixel(1,0,darker)
	temp.unlock()
	
	var temp2 = ImageTexture.new()
	temp2.create_from_image(temp,0)
	temp2.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
	
	mp = temp2
	$body.get_material().set_shader_param("palette", temp2)
	$head.get_material().set_shader_param("palette", temp2)
	$legs.get_material().set_shader_param("palette", temp2)
	$tail.get_material().set_shader_param("palette", temp2)
	$spine.get_material().set_shader_param("palette", temp2)
	$wings.get_material().set_shader_param("palette", temp2)
	$tdec.get_material().set_shader_param("palette", temp2)

func eyesChangeC(color): #3
	var temp = mp.get_data()
	
	temp.lock()
	temp.set_pixel(3,0,color)
	temp.unlock()
	
	var temp2 = ImageTexture.new()
	temp2.create_from_image(temp,0)
	temp2.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
	
	mp = temp2
	$body.get_material().set_shader_param("palette", temp2)
	$head.get_material().set_shader_param("palette", temp2)
	$legs.get_material().set_shader_param("palette", temp2)
	$tail.get_material().set_shader_param("palette", temp2)
	$spine.get_material().set_shader_param("palette", temp2)
	$wings.get_material().set_shader_param("palette", temp2)
	$tdec.get_material().set_shader_param("palette", temp2)

func hornsChangeC(color): #2
	var temp = mp.get_data()
	
	temp.lock()
	temp.set_pixel(2,0,color)
	temp.unlock()
	
	var temp2 = ImageTexture.new()
	temp2.create_from_image(temp,0)
	temp2.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
	
	mp = temp2
	$body.get_material().set_shader_param("palette", temp2)
	$head.get_material().set_shader_param("palette", temp2)
	$legs.get_material().set_shader_param("palette", temp2)
	$tail.get_material().set_shader_param("palette", temp2)
	$spine.get_material().set_shader_param("palette", temp2)
	$wings.get_material().set_shader_param("palette", temp2)
	$tdec.get_material().set_shader_param("palette", temp2)
	

func wingsChangeC(color): #6 and 7
	var temp = mp.get_data()
	var darker = Color(color.r - 0.08, color.g - 0.08, color.b - 0.08)
	
	temp.lock()
	temp.set_pixel(6,0,color)
	temp.set_pixel(7,0,darker)
	temp.unlock()
	
	var temp2 = ImageTexture.new()
	temp2.create_from_image(temp,0)
	temp2.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
	
	mp = temp2
	$body.get_material().set_shader_param("palette", temp2)
	$head.get_material().set_shader_param("palette", temp2)
	$legs.get_material().set_shader_param("palette", temp2)
	$tail.get_material().set_shader_param("palette", temp2)
	$spine.get_material().set_shader_param("palette", temp2)
	$wings.get_material().set_shader_param("palette", temp2)
	$tdec.get_material().set_shader_param("palette", temp2)

func spineChangeC(color): #4 and 5
	var temp = mp.get_data()
	var darker = Color(color.r - 0.08, color.g - 0.08, color.b - 0.08)
	
	temp.lock()
	temp.set_pixel(4,0,color)
	temp.set_pixel(5,0,darker)
	temp.unlock()
	
	var temp2 = ImageTexture.new()
	temp2.create_from_image(temp,0)
	temp2.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
	
	mp = temp2
	$body.get_material().set_shader_param("palette", temp2)
	$head.get_material().set_shader_param("palette", temp2)
	$legs.get_material().set_shader_param("palette", temp2)
	$tail.get_material().set_shader_param("palette", temp2)
	$tdec.get_material().set_shader_param("palette", temp2)
	$spine.get_material().set_shader_param("palette", temp2)
	$wings.get_material().set_shader_param("palette", temp2)

func tdecChangeC(color): #8 and 9
	var temp = mp.get_data()
	var darker = Color(color.r - 0.8, color.g - 0.8, color.b - 0.8)
	
	temp.lock()
	temp.set_pixel(8,0,color)
	temp.set_pixel(9,0,darker)
	temp.unlock()
	
	var temp2 = ImageTexture.new()
	temp2.create_from_image(temp, 0)
	temp2.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
	
	mp = temp2
	$body.get_material().set_shader_param("palette", temp2)
	$head.get_material().set_shader_param("palette", temp2)
	$legs.get_material().set_shader_param("palette", temp2)
	$tail.get_material().set_shader_param("palette", temp2)
	$tdec.get_material().set_shader_param("palette", temp2)
	$spine.get_material().set_shader_param("palette", temp2)
	$wings.get_material().set_shader_param("palette", temp2)

func bodyChanged(_index):
	if ddbody.get_selected_id() >= 255:
		$body.texture = null
		return
	
	var tdataind = gloader.loadedtribes[ddbody.get_selected_id()]
	for part in tdataind.appearancesidle:
		if "body" in part:
			$body.texture = load(part)
			break
	for partmask in tdataind.appearancesidlemask:
		if "body" in partmask:
			$body.get_material().set_shader_param("mask", load(partmask))
			break

func wingsChanged(_index):
	if ddwings.get_selected_id() >= 255:
		$wings.texture = null
		return
	
	var tdataind = gloader.loadedtribes[ddwings.get_selected_id()]
	for part in tdataind.appearancesidle:
		if "wings" in part:
			$wings.texture = load(part)
			break
	for partmask in tdataind.appearancesidlemask:
		if "wings" in partmask:
			$wings.get_material().set_shader_param("mask", load(partmask))
			break

func tailChanged(_index):
	if ddtail.get_selected_id() >= 255:
		$tail.texture = null
		return
	var tdataind = gloader.loadedtribes[ddtail.get_selected_id()]
	for part in tdataind.appearancesidle:
		if "tail" in part:
			$tail.texture = load(part)
			break
	for partmask in tdataind.appearancesidlemask:
		if "tail" in partmask:
			$tail.get_material().set_shader_param("mask", load(partmask))
			break

func headChanged(_index):
	if ddhead.get_selected_id() >= 255:
		$head.texture = null
		return
	
	var tdataind = gloader.loadedtribes[ddhead.get_selected_id()]
	for part in tdataind.appearancesidle:
		if "head" in part:
			$head.texture = load(part)
			break
	for partmask in tdataind.appearancesidlemask:
		if "head" in partmask:
			$head.get_material().set_shader_param("mask", load(partmask))
			break

func legsChanged(_index):
	if ddlegs.get_selected_id() >= 255:
		$legs.texture = null
		return
	
	var tdataind = gloader.loadedtribes[ddlegs.get_selected_id()]
	for part in tdataind.appearancesidle:
		if "legs" in part:
			$legs.texture = load(part)
			break
	for partmask in tdataind.appearancesidlemask:
		if "legs" in partmask:
			$legs.get_material().set_shader_param("mask", load(partmask))
			break

func spineChanged(_index):
	if ddspine.get_selected_id() >= 255:
		$spine.texture = null
		return
	
	var tdataind = gloader.loadedtribes[ddspine.get_selected_id()]
	for part in tdataind.appearancesidle:
		if "spine" in part:
			$spine.texture = load(part)
	for part in tdataind.appearancesidlemask:
		if "spine" in part:
			$spine.get_material().set_shader_param("mask", load(part))

func tdecChanged(_index):
	if ddtdec.get_selected_id() >= 255:
		$tdec.texture = null
		return
	
	var tdataind = gloader.loadedtribes[ddtdec.get_selected_id()]
	for part in tdataind.appearancesidle:
		if "tdec" in part:
			$tdec.texture = load(part)
	for part in tdataind.appearancesidlemask:
		if "tdec" in part:
			$tdec.material.set_shader_param("mask", load(part))

func spineToggle(button_pressed):
	$spine.visible = button_pressed

func tdecToggle(button_pressed):
	$tdec.visible = button_pressed

func edropToggle(button_pressed):
	$eyedrop.visible = button_pressed

func getPalettes() -> ImageTexture:
	return mp

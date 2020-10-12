extends Control

onready var spine = get_node("spine")
onready var body = get_node("body")
onready var legs = get_node("legs")
onready var tail = get_node("tail")
onready var head = get_node("head")
onready var wings = get_node("wings")
onready var eyedrop = get_node("eyedrop")

onready var ddhead = get_parent().get_node("customization/TabContainer/Appearance/TabContainer/Looks/ScrollContainer/GridContainer/head")
onready var ddbody = get_parent().get_node("customization/TabContainer/Appearance/TabContainer/Looks/ScrollContainer/GridContainer/body")
onready var ddwings = get_parent().get_node("customization/TabContainer/Appearance/TabContainer/Looks/ScrollContainer/GridContainer/wings")
onready var ddtail = get_parent().get_node("customization/TabContainer/Appearance/TabContainer/Looks/ScrollContainer/GridContainer/tail")
onready var ddlegs = get_parent().get_node("customization/TabContainer/Appearance/TabContainer/Looks/ScrollContainer/GridContainer/legs")
onready var ddspine = get_parent().get_node("customization/TabContainer/Appearance/TabContainer/Looks/ScrollContainer/GridContainer/spine")
onready var ddtdec = get_parent().get_node("customization/TabContainer/Appearance/TabContainer/Looks/ScrollContainer/GridContainer/td")

onready var gloader = get_tree().get_root().get_node("gloader")

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
	$eyedrop.visible = false
	$spine.visible = false

func reset():
	mp = mainPalette
	
	scalesChangeC(Color.white)
	wingsChangeC(Color.white)
	eyesChangeC(Color.white)
	hornsChangeC(Color.white)
	spineChangeC(Color.white)
	
	$head.texture = null
	$body.texture = null
	$wings.texture = null
	$legs.texture = null
	$tail.texture = null
	$spine.texture = null
	
	spineToggle(false)
	edropToggle(false)

func loadDataFromFiles(dataarr):
	$body.get_material().set_shader_param("palette", dataarr[2])
	$legs.get_material().set_shader_param("palette", dataarr[2])
	$tail.get_material().set_shader_param("palette", dataarr[2])
	$head.get_material().set_shader_param("palette", dataarr[1])
	$wings.get_material().set_shader_param("palette", dataarr[3])
	
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
			break
		index += 1
	index = 0
	#for tribe in gloader.loadedtribes:
	#	if tribe.tribename == dataarr[0].appearances.body:
	#		bodyChanged(index)  #TODO: implement tail decoration (Fantribes, SandWing, IceWing, LeafWing, HiveWing)
	#		break
	#	index += 1
	
	$spine.visible = dataarr[0].appearances.sshow
	$eyedrop.visible = dataarr[0].appearances.eshow
	
	spineChangeC(Color(dataarr[0].colors.spineRaw[0], dataarr[0].colors.spineRaw[1], dataarr[0].colors.spineRaw[2]))
	

func scalesChangeC(color): #0 and 1
	var temp = mp.get_data()
	var darker = Color(color.r - 0.03, color.g - 0.03, color.b - 0.03)
	
	temp.lock()
	temp.set_pixel(0,0,color)
	temp.set_pixel(1,0,darker)
	temp.unlock()
	
	var temp2 = ImageTexture.new()
	temp2.create_from_image(temp,0)
	temp2.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
	
	mp = temp2
	$body.get_material().set_shader_param("palette", temp2)

func eyesChangeC(color): #3
	pass

func hornsChangeC(color): #2
	pass

func wingsChangeC(color): #6 and 7
	pass

func spineChangeC(color): #4 and 5
	pass

func tdecChangeC(color): #8
	pass

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

func wingsChanged(index):
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

func tailChanged(index):
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

func headChanged(index):
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

func legsChanged(index):
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

func spineChanged(index):
	if ddspine.get_selected_id() >= 255:
		$spine.texture = null
		return
	
	var tdataind = gloader.loadedtribes[ddspine.get_selected_id()]
	for part in tdataind.appearancesidle:
		if "spine" in part:
			$spine.texture = load(part)

func tdecChanged(index):
	if ddtdec.get_selected_id() >= 255:
		$tdec.texture = null
		return
	
	var tdataind = gloader.loadedtribes[ddtdec.get_selected_id()]
	#TODO

func spineToggle(button_pressed):
	$spine.visible = button_pressed

func edropToggle(button_pressed):
	$eyedrop.visible = button_pressed

func getPalettes() -> Array:
	return []

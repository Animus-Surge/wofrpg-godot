extends Panel

onready var tribes = get_node("TabContainer/Basic Details/tribes")
onready var cname = get_node("TabContainer/Basic Details/name")
onready var crole = get_node("TabContainer/Basic Details/Role")
onready var cgender = get_node("TabContainer/Basic Details/Gender")

onready var gloader = get_node("/root/gloader")
onready var cfm = get_node("/root/cfm")

func _ready():
	for tribe in gloader.baseTribes:
		tribes.add_item(tribe.name)

func createChar():
	if !validate():
		return
	var cdir = cfm.makeCharacterDirectory(cname.get_text())
	var scalepalette = $preview/body.get_material().get_shader_param("palette").get_data()
	scalepalette.save_png(cdir + "/scales.png")
	var headpalette = $preview/head.get_material().get_shader_param("palette").get_data()
	headpalette.save_png(cdir + "/head.png")
	var wingpalette = $preview/wings.get_material().get_shader_param("palette").get_data()
	wingpalette.save_png(cdir + "/wings.png")
	
func validate() -> bool:
	if cname == "":
		return false
	#elif tribes.get_selected_items().length < 1:
	#	return false
	return true

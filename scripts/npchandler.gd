extends StaticBody2D

#appearance modifiers
export (bool) var flipped = false

#npc details
export (String) var npcName
export (String) var npcID

func _ready():
	if flipped:
		$Sprite.visible = false
		$Sprite2.visible = true
	else:
		$Sprite.visible = true
		$Sprite2.visible = false
	
	$Sprite.playing = true
	$Sprite2.playing = true
	
	set_process(true)



func _process(delta):
	if globalvars.sppaused:
		$Sprite.playing = false
		$Sprite2.playing = false
	else:
		$Sprite.playing = true
		$Sprite2.playing = true


func interacted(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("NPC was interacted with")

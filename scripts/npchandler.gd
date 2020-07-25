extends StaticBody2D

export (bool) var flipped = false

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

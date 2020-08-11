extends StaticBody2D

export (int) var hp = -1
export (bool) var attacks
export (int) var damage
export (int) var speed #currently unused

func _ready():
	if hp == -1:
		get_node("Label").text = ""
	else:
		get_node("Label").text = String(hp)

func attacked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		if globalvars.inrange(global_position, get_parent().get_node("playerRoot").global_position, 600):
			if hp == -1:
				get_node("Label").text = "-" + String(spgs.atkdmg)
			else:
				hp -= spgs.atkdmg
			
				get_node("Label").text = String(hp)
			
				if hp <= 0:
					self.queue_free()

func _area_entered(body):
	if "fireball" in body.name:
		body.get_parent().call("destroy")
		if hp == -1:
			get_node("Label").text = "-" + String(spgs.rngdmg)
		else:
			hp -= spgs.rngdmg
			get_node("Label").text = String(hp)
			
			if hp <= 0:
				self.queue_free()

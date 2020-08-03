extends StaticBody2D

export (int) var hp = 100
export (bool) var attacks
export (int) var damage
export (int) var speed #currently unused

func attacked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		if globalvars.inrange(global_position, get_parent().get_node("playerRoot").global_position, 600):
			if hp == -1:
				pass
			else:
				hp -= spgs.atkdmg
				print("CURRENT ENTITY ("+ name +") HP: " + String(hp))
			
			if hp <= 0:
				self.queue_free()
				print("DESTROYED ENTITY: " + name)

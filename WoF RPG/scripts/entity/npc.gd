extends "res://scripts/entity/interactable.gd"

export(String, "generic", "story") var npctype = "generic"
export(String) var npcid
export(int, 0, 100000) var maxHP = 0
var hp := 0.0

func _ready():
	TYPE = "npc"
	hp = float(maxHP)

func _interacted():
	print("NPC was interacted with... yay")

func recieve_damage(amount: float):
	hp -= amount

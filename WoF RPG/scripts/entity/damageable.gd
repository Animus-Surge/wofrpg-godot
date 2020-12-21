extends KinematicBody

const TYPE = "damageable"

onready var hurt_material = preload("res://hurt_material.tres")
onready var regular_material = preload("res://regular_material.material")

var hp = 100

func recieve_damage(damage: float):
	hp -= damage
	$model2.mesh.material = hurt_material
	$Timer.start()

func timeout():
	$model2.mesh.material = regular_material

func _process(_delta):
	if hp <= 0:
		queue_free() #TODO: death animation

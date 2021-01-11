extends KinematicBody

const TYPE = "damageable"

#TODO: replace these with variable information structure
onready var hurt_material = preload("res://hurt_material.tres")
onready var regular_material = preload("res://regular_material.material")

var hp
var maxhp = 300
var ename = "Pill" #TEMPORARY

#TODO: buffs and debuffs

func _ready(): #TODO: utilize file stuff to work with variable hitpoint modifiers
	hp = maxhp

func recieve_damage(damage: float):
	hp -= damage
	$model2.mesh.material = hurt_material
	$Timer.start()

func timeout():
	$model2.mesh.material = regular_material

func _process(_delta):
	if hp <= 0:
		queue_free() #TODO: death animation

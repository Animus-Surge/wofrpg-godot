extends Node2D

var speed = 750
var velocity = Vector2()

puppet var pos = Vector2()
puppet var vel = Vector2()

func _ready():
	pass

func _physics_process(_delta):
	position = pos
	velocity = vel
	
	position += vel * _delta
	
	pos = position

extends KinematicBody2D

var speed = 750
var velocity = Vector2()

puppet var pos
puppet var vel

func _ready():
	pass

func _physics_process(delta):
	position = pos;
	velocity = vel;
	
	velocity = move_and_slide(velocity)
	
	pos = position

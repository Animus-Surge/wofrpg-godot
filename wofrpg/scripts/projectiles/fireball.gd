extends RigidBody2D

var velocity

export (int) var speed = 1000

func _ready():
	get_node("Timer").stop()

func spawn(location, mousepos):
	set_global_position(location)
	var direction = (mousepos - location).normalized()
	self.linear_velocity = direction * speed
	get_node("Timer").wait_time = 3
	get_node("Timer").start()

func timerDone():
	set_process(false)
	get_node("Timer").stop()
	queue_free()

func destroy():
	timerDone()

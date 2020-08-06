extends Area2D

var velocity

func _ready():
	get_node("Timer").stop()

func set(vel, location):
	set_global_position(location)
	velocity = vel
	set_process(true)
	get_node("Timer").wait_time = 3
	get_node("Timer").start()

func _process(delta):
	if !globalvars.sppaused:
		set_global_position(get_global_position() + velocity)

func timerDone():
	set_process(false)
	get_node("Timer").stop()
	queue_free()


func fireballHitSomething(area):
	if area.name.begins_with("atk"):
		area.get_parent().call("rattacked")
		queue_free()

extends Area

const SPEED = 10.0
const TYPE = "projectile"

var velocity = Vector3()

func _ready():
	$Timer.start()

func _physics_process(delta):
	look_at(transform.origin + velocity.normalized(), Vector3.UP)
	transform.origin += velocity * delta
	

func despawn():
	queue_free()

func _body_entered(body):
	if body.TYPE == "damageable":
		body.recieve_damage(25.0)
	despawn()

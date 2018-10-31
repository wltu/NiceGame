extends RigidBody2D

func _physics_process(delta):
	if abs(linear_velocity.x) < 5:
		linear_velocity.x = 0
	else:
		linear_velocity.x = linear_velocity.x * 0.975
		
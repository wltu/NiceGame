extends RigidBody2D

var bodies

func _physics_process(delta):
	if abs(linear_velocity.x) < 5:
		linear_velocity.x = 0
	else:
		linear_velocity.x = linear_velocity.x * 0.99
	
	bodies = self.get_colliding_bodies()
	
	for body in bodies:
		if body.name.begins_with("Skeleton"):
			body.fly_away()
			
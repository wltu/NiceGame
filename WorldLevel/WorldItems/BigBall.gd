extends RigidBody2D

var bodies
var temp_velocity

func _physics_process(delta):
	if abs(linear_velocity.x) < 5:
		linear_velocity.x = 0
	else:
		linear_velocity.x = linear_velocity.x * 0.99
		
	bodies = $Area2D.get_overlapping_bodies()
	
	for body in bodies:
		for monster_name in GameVariables.MONSTERS:
			if body.name.begins_with(monster_name):
				if (linear_velocity.x >= 200):
					body.fly_away()
				
	print(linear_velocity.x)
	
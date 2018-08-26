extends Area2D

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			GameVariables.key += 1
			print("Got Key")
			
			queue_free()

extends Sprite

func _physics_process(delta):
	var bodies = $Area2D.get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			body.blocks += 2
			
			print("got blocks")
			
			queue_free()

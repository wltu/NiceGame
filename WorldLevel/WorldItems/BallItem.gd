extends Sprite

func _physics_process(delta):
	var bodies = $Area2D.get_overlapping_bodies()

	for body in bodies:
		if body.name == "Player":
			GameVariables.items[1] += 2
			queue_free()

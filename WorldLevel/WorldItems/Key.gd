extends Area2D

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			if $Sprite.visible:
				$Sprite.visible = false
				$CollisionShape2D.disabled = true
				
				print(GameVariables.key)
				GameVariables.key += 1
				
				print(GameVariables.key)
				
				print("Got Key")

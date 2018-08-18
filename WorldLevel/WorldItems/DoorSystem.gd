# World DoorSystem.gd
extends Area2D


func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			print(GameVariables.key )
			
			if GameVariables.key > 0:
				GameVariables.key -= 1
				$DoorArea.disabled = true
				$ClosedDoor.visible = false
				$OpenDoor.visible = true
				$DoorStop.get_child(0).disabled = true

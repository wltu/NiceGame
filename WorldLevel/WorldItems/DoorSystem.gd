 # World DoorSystem.gd
extends Area2D

var open = false

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			if GameVariables.key > 0:
				GameVariables.key -= 1
				open = true
				
	open_door()
	
func open_door():
	if open:
		$DoorArea.disabled = true
		$ClosedDoor.visible = false
		$OpenDoor.visible = true
		$DoorStop.get_child(0).disabled = true
	else:
		$DoorArea.disabled = false
		$ClosedDoor.visible = true
		$OpenDoor.visible = false
		$DoorStop.get_child(0).disabled = false

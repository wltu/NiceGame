 # World DoorSystem.gd
extends Area2D

export (bool) var special_door = false
export (Color) var color_frame = Color(1,1,1)
var open = false

func _ready():
	if special_door:
		$ClosedDoor/ColorFrame.modulate = color_frame
		$OpenDoor/ColorFrame.modulate = color_frame
	else:
		$ClosedDoor/ColorFrame.visible = false
		$OpenDoor/ColorFrame.visible = false

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

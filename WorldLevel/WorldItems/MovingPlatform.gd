extends StaticBody2D

var motion

export(int) var SPEED

var walls
var bodies

func _ready():
	motion = SPEED

func _physics_process(delta):
	walls = $Side.get_overlapping_bodies()
	
	if len(walls) > 1:
		for wall in walls:
			if wall.name == "Dirt" or wall.name == "AutoTile" or wall.name == "Metal":
				motion = -motion
	
	self.position.x += motion

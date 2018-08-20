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
			if wall.name == "TileMap" or wall.name == "AutoTile" :
				motion = -motion
	
	self.position.x += motion

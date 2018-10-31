extends Node2D

var select_position = [32, 96]
var selection = 0

func _ready():
	$BlockItem/Area2D/CollisionShape2D.disabled = true
	$BallItem/Area2D/CollisionShape2D.disabled = true

func _process(delta):
	$NumBalls.text = str(GameVariables.items[1])
	$NumBlocks.text = str(GameVariables.items[0])
	
	
func update_select():
	selection += 1
	selection %= 2
	$Select.position.x = select_position[selection]
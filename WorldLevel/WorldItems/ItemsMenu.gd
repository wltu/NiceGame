extends Node2D

var select_position = [96, 160]
var selection = 0

func update_select():
	selection += 1
	selection %= 2
	$Select.position.x = select_position[selection]
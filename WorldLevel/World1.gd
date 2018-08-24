extends Node

const CHECKPOINTS = []

var check_point = 0

func _ready():
	var areas = get_child(2).get_children()

	for area in areas:
		CHECKPOINTS.append(Vector2(area.position.x, area.position.y))
		print(area.name)


func _on_CheckPoints_body_entered(body):
	get_child(2).get_child(0).queue_free()
	check_point += 1

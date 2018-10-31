extends Node

const CHECKPOINTS = []

func _ready():
	GameVariables.key = 0
	var areas = get_child(2).get_children()

	for area in areas:
		CHECKPOINTS.append(Vector2(area.position.x, area.position.y))
	
	for i in range(GameVariables.check_point):
		get_child(2).get_child(i).queue_free()
		 
		if get_child(7).get_child(i) != null:
			get_child(7).get_child(i).queue_free() 
			
		if get_child(8).get_child(i) != null:
			get_child(8).get_child(i).open = true
		


func _on_CheckPoints_body_entered(body):
	get_child(2).get_child(0).queue_free()
	GameVariables.save_state()
	GameVariables.check_point += 1

# World Complete.gd
extends Area2D

export(String, FILE, "*.tscn") var next_world

var bodies 

func _physics_process(delta):
	bodies = get_overlapping_bodies()

	for body in bodies:
		if body.name == "Player":
			get_tree().change_scene(next_world)
			GameVariables.check_point = 0
			GameVariables.key = 0
			GameVariables.items = [0,0]
			GameVariables.save_state()


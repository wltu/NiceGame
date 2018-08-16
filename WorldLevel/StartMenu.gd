# StartMenu.gd
extends Control

export(String, FILE, "*.tscn") var first_world

func _on_Play_pressed():
	print("HI")
	get_tree().change_scene(first_world)


func _on_Quit_pressed():
	get_tree().quit()

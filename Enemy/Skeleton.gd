extends KinematicBody2D

const GRAVITY = 20
const H_SPEED = 100
const UP = Vector2(0, -1)
var motion = Vector2()
var dir = 1

func _ready():
	motion.x = H_SPEED
	$Sprite.play("Walk")
	pass

func _physics_process(delta):
	
	motion.y += GRAVITY
	
	if is_on_wall() or detect_area():
		dir = dir * -1
		$Sprite.flip_h = !$Sprite.flip_h
	if is_on_floor():
		motion.y = 0
	
	motion.x = dir*H_SPEED
	
	move_and_slide(motion, UP)
	pass
	
func detect_area():
	var areas = $Area2D.get_overlapping_areas()
	
	for area in areas:
		if(area.name.begins_with("Stop")):
			return true
			
	return false
	
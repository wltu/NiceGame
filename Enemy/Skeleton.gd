extends KinematicBody2D

const GRAVITY = 20
const H_SPEED = 100
const UP = Vector2(0, -1)
var motion = Vector2()
var dir = 1
var areas 
var bodies
var fly = false

var x

func _ready():
	motion.x = H_SPEED
	$Sprite.play("Walk")
	pass

func _physics_process(delta):
	if (fly):
		motion.y = -100
		motion.x = 0
		if position.y < 0:
			self.queue_free()
	else:
		motion.y += GRAVITY
		
		if is_on_wall() or detect_area():
			dir = dir * -1
			$Sprite.flip_h = !$Sprite.flip_h
		if is_on_floor():
			motion.y = 0
		
		x = randi()%151+1
		
		if x == 13:
			dir = dir * -1
			$Sprite.flip_h = !$Sprite.flip_h
		
		
		motion.x = dir*H_SPEED
		
	move_and_slide(motion, UP)
	
func detect_area():
	areas = $Area2D.get_overlapping_areas()
	
	for area in areas:
		if(area.name.begins_with("Stop")):
			return true

	return false

func fly_away():
	$CollisionShape2D.disabled = true
	fly = true
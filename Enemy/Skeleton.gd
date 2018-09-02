extends KinematicBody2D

const GRAVITY = 20
const SPEED = 100
const UP = Vector2(0, -1)
var motion = Vector2()

func _ready():
	motion.x = SPEED
	$Sprite.play("Walk")
	pass

func _physics_process(delta):
	motion.y += GRAVITY
	
	if is_on_wall():
		motion.x = -motion.x
		$Sprite.flip_h = !$Sprite.flip_h
	if is_on_floor():
		motion.y = 0
	
	move_and_slide(motion, UP)
	pass

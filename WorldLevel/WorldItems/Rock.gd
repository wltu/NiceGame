extends KinematicBody2D
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var SLIDE_SPEED = 0
var motion = Vector2()
var player_push = false
var direction = 0
const UP = Vector2(0, -1)

func _physics_process(delta):
	player_push = false
	
	if is_on_floor():
		motion.y = 0
	else:
		motion.y += 20

	var bodies = $Area2D.get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			direction = body.direction
			
			if (direction == 1 and body.position.x < self.position.x) or (direction == -1 and body.position.x > self.position.x):
				player_push = true
				SLIDE_SPEED = body.WALK_SPEED
				body.run = false
			
	if player_push:
		if direction == 1:
			motion.x = SLIDE_SPEED
		elif direction == -1:
			motion.x = -SLIDE_SPEED
	else:
		if motion.x > 0:
			motion.x -= SLIDE_SPEED / 4
		if motion.x < 0:
			motion.x += SLIDE_SPEED / 4
		
	
	self.move_and_slide(motion, UP)
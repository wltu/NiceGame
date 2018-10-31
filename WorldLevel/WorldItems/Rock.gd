extends RigidBody2D
#var SLIDE_SPEED = 0
#var motion = Vector2()
#var player_push = false
#var direction = 0
#var ramp
#var ramp_dir
#
#const UP = Vector2(0, -1)


func start(pos):
	position = pos

func _physics_process(delta):
	if abs(linear_velocity.x) < 5:
		linear_velocity.x = 0
	else:
		linear_velocity.x = linear_velocity.x * 0.85

#func _physics_process(delta):
#	player_push = false
#	ramp = false
#
#	if is_on_wall():
#		motion.x = 0
#
#	if is_on_floor():
#		motion.y = 0
#	else:
#		motion.y += GameVariables.GRAVITY
#
#	var bodies = $Area2D.get_overlapping_bodies()
#
#	for body in bodies:
#		if body.name == "Player":
#			direction = body.direction
#			if body.is_on_floor():
#
#				if (direction == 1 and body.position.x < self.position.x) or (direction == -1 and body.position.x > self.position.x):
#					player_push = true
#					SLIDE_SPEED = body.WALK_SPEED
#					body.run = false
#		elif body.name.begins_with("Ramp"):
#			ramp = true
#			ramp_dir = body.dir
#
#	if player_push:
#		if direction == 1:
#			motion.x = SLIDE_SPEED
#		elif direction == -1:
#			motion.x = -SLIDE_SPEED
#	else:
#		if !ramp and motion.x !=  0 or ramp and motion.x * ramp_dir < 0:
#			motion.x = 7*motion.x / 8
#
#		if abs(motion.x) < 5:
#			motion.x = 0
#
#
#	self.move_and_slide(motion, UP)
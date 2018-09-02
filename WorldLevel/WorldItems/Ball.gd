extends KinematicBody2D

const UP = Vector2(0, -1)
var motion = Vector2()
var bounce  = true
var roll = true
var hit_floor = false
var max_speed
var x = 1

func _ready():
	pass

func start(pos, motion):
	self.position = pos
	self.motion = motion

func _physics_process(delta):
	$Sprite.rotate(motion.x*delta / 37.7)
	
	if !roll and !bounce:
		$CollisionShape2D.disabled = true
	else:
		if bounce:
			if is_on_ceiling():
				motion.y = -motion.y
			
			if is_on_floor():
				if !hit_floor:
					hit_floor = true
					max_speed = -motion.y
	
				motion.y = pow(0.75, x)*max_speed
				x += 1
				
				if abs(motion.y) < 20:
					motion.y = 0
					bounce = false
			else:
				motion.y += GameVariables.GRAVITY
		
		if roll:
			if abs(motion.x) == 0:
				roll = false
			
			if is_on_wall():
				motion.x = -0.75*motion.x
	
			if !bounce:
				motion.x -= 0.1*motion.x
	
				if abs(motion.x) < 10:
					roll = false
					motion.x = 0
			
		self.move_and_slide(motion, UP)
	

# Rotating in air and ground.
# Bounce.
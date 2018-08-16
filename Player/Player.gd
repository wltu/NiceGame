extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCERLERATION = 50
const WALK_SPEED = 200
const RUN_SPEED = 300
const JUMP_SPEED = -540
const SLIDE_SPEED = 500
const MAX_X = 640
const MAX_Y = 360
const TIME_GAP = 100

var motion = Vector2()
var sliding_check = Transform2D()

var low = false
var friction = false
var slide = false

var counter = 0
var right = false
var left = false
var run = false
var walk = false

export(String, FILE, "*.tscn") var world_scene


#Initial function when sence loads.
func _ready():
	pass

func _physics_process(delta):
	if right:
		counter += 1
		
		if counter > TIME_GAP:
			counter = 0
			right = false
	elif left:
		counter += 1
		
		if counter > TIME_GAP:
			counter = 0
			left = false
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("ui_reset"):
		get_tree().change_scene(world_scene)
	
	friction = false
	
	motion.y += GRAVITY
	
	sliding_check = Transform2D(Vector2(0, 0), Vector2(0, 0), position)
	
	if Input.is_action_pressed("ui_right"):
		if slide:
			motion.x = lerp(motion.x, 0, 0.05)
		
		if right and counter <= TIME_GAP:
			run = true
		
		$Sprite.flip_h = false
		
		if !low:
			if run:
				motion.x = min(ACCERLERATION + motion.x, RUN_SPEED)
				$Sprite.play("Run") 
			else:
				motion.x = min(ACCERLERATION + motion.x, WALK_SPEED)
				$Sprite.play("Walk") 
				run = false
			
			right = false
			counter = 0
		
	elif Input.is_action_pressed("ui_left"):
		if slide:
			motion.x = lerp(motion.x, 0, 0.05)
		
		if left and counter <= TIME_GAP:
			run = true
		
		$Sprite.flip_h = true
		
		if !low:
			if run:
				motion.x = max(motion.x - ACCERLERATION , -RUN_SPEED)
				$Sprite.play("Run") 
			else:
				motion.x = max(motion.x - ACCERLERATION , -WALK_SPEED)
				$Sprite.play("Walk") 
				run = false
				
			left = false
			counter = 0
	else:
		if slide:
			motion.x = lerp(motion.x, 0, 0.05)
		
		if !low:
			motion.x = lerp(motion.x, 0, 0.2)
			$Sprite.play("Idle")
		
		friction = true
		
	if Input.is_action_just_released("ui_right"):
		right = true
		run = false
		
	if Input.is_action_just_released("ui_left"):
		left = true
		run = false
	
	on_floor_action()
	
	motion = move_and_slide(motion, UP)


func change_collsion_shape():
	if low:
		$UpRight.disabled = true
		$Sliding.disabled = false
	else:
		$UpRight.disabled = false
		$Sliding.disabled = true

func on_floor_action():
	if is_on_floor():
		if Input.is_action_pressed("ui_down"):
			if !slide:
				motion.x = 0
			
			low = true
			
			if motion.x == 0 and !slide:
				$Sprite.play("Duck")
				change_collsion_shape()
			
		else:
			if !test_move(sliding_check, Vector2(0,-20)):
				low = false
				slide = false
				change_collsion_shape()
				
				if Input.is_action_just_pressed("ui_up") or Input.is_action_pressed("ui_select"):
					motion.y = JUMP_SPEED
		
		
		if Input.is_action_just_pressed("ui_select"):
			if $Sprite.flip_h == false:
				motion.x = SLIDE_SPEED
			else:
				motion.x = -SLIDE_SPEED
			
			$Sprite.play("Slide") 
			slide = true
			change_collsion_shape()
		if friction and !slide:
			motion.x = lerp(motion.x, 0, 0.2)
	else:
		slide = false
		low = false
		if motion.y < 0:
			$Sprite.play("Jump") 
		else:
			$Sprite.play("Fall") 
		
		if friction:
			motion.x = lerp(motion.x, 0, 0.05)
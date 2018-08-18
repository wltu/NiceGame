extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCERLERATION = 50
const WALK_SPEED = 200
const RUN_SPEED = 300
const JUMP_SPEED = -540
const SLIDE_SPEED = 500
const WALL_JUMP_SPEED_H = 500
const WALL_JUMP_SPEED_V = -400
const WALL_SLIDE_SLEED = 75
const MAX_X = 640
const MAX_Y = 360
const TIME_GAP = 10

var motion = Vector2()
var body_check = Transform2D()

var low = false
var friction = false
var slide = false
var in_air = false;

var counter = 0
var right = false
var left = false
var run = false
var walk = false

export(String, FILE, "*.tscn") var world_scene

func _physics_process(delta):
	friction = false
	
	motion.y += GRAVITY
	
	body_check = Transform2D(Vector2(0, 0), Vector2(0, 0), position)
	
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("ui_reset"):
		get_tree().change_scene(world_scene)
	
	directional_action()
	
	on_floor_action()
	
	on_wall_action()
	
	motion = move_and_slide(motion, UP)
	
func change_collsion_shape():
	if low:
		$UpRight.disabled = true
		$Sliding.disabled = false
	else:
		$UpRight.disabled = false
		$Sliding.disabled = true
	
func directional_action():
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
		run = false
		
		if slide:
			motion.x = lerp(motion.x, 0, 0.05)
		
		if !low:
			motion.x = lerp(motion.x, 0, 0.2)
			$Sprite.play("Idle")
		
		friction = true
		
	if Input.is_action_just_released("ui_right"):
		right = true
	if Input.is_action_just_released("ui_left"):
		left = true
	
func on_wall_action():
	if is_on_wall() and in_air and !test_move(body_check, Vector2(0,75)):
		$Sprite.flip_h = !$Sprite.flip_h
		
		if !$Sprite.flip_h:
			$Sprite.offset.x = 18
		else:
			$Sprite.offset.x = -18
			
		$Sprite.play("Wall")
		
		motion.y = WALL_SLIDE_SLEED
		
		if Input.is_action_just_pressed("ui_select") or Input.is_action_just_pressed("ui_up"):
			motion.y = WALL_JUMP_SPEED_V
			if !$Sprite.flip_h:
				motion.x = WALL_JUMP_SPEED_H
			else:
				motion.x = -WALL_JUMP_SPEED_H
	else:
		$Sprite.offset.x = 0

func on_floor_action():
	if is_on_floor():
		in_air = false
		if Input.is_action_pressed("ui_down"):
			if !slide:
				motion.x = 0
			
			low = true
			
			if motion.x == 0 and !slide:
				$Sprite.play("Duck")
				change_collsion_shape()
			
		else:
			if !test_move(body_check, Vector2(0,-20)):
				low = false
				slide = false
				change_collsion_shape()
				
				if Input.is_action_just_pressed("ui_up") or Input.is_action_pressed("ui_select"):
					motion.y = JUMP_SPEED
		
		if low and (Input.is_action_just_pressed("ui_select") or run and !slide):
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
		in_air = true
		
		slide = false
		low = false
		if motion.y < 0:
			$Sprite.play("Jump") 
		else:
			$Sprite.play("Fall") 
		
		if friction:
			motion.x = lerp(motion.x, 0, 0.05)
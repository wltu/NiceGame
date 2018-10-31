extends KinematicBody2D

const UP = Vector2(0, -1)
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
const MONSTERS = ["Skeleton"]
const BALL_MOTION = Vector2(400, -600)

var motion = Vector2()
var body_check = Transform2D()

var low = false
var friction = false
var slide = false
var in_air = false;
var wall_jump = true
var direction = 0  #-1 for left, 1 for right, 0 for idle

var item_index = 0


var counter = 0
var right = false
var left = false
var run = false
var walk = false

var testing = false

export (Vector2) var start_pos
export(String, FILE, "*.tscn") var world_scene
export (PackedScene) var Blocks
export (PackedScene) var Balls

func _enter_tree():
	if self.get_parent().name == "WorldWin":
		$Camera2D.current = false
		$VictoryCamera.current = true
	else:
		if !testing:
			if GameVariables.check_point > 0:
				start_pos = get_parent().CHECKPOINTS[GameVariables.check_point - 1]
		
			self.position.x = start_pos.x
			self.position.y = start_pos.y

func _physics_process(delta):
	friction = false
	motion.y += GameVariables.GRAVITY
	
	body_check = Transform2D(Vector2(0, 0), Vector2(0, 0), position)
	
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("ui_reset"):
		GameVariables.reset()
		get_tree().change_scene(world_scene)
	
	
	detect_area()
	directional_action()
	on_floor_action()
	on_wall_action()
	items_action()
	
	motion = move_and_slide(motion, UP)
	
	
func change_collsion_shape():
	if low:
		$UpRight.disabled = true
		$Sliding.disabled = false
	else:
		$UpRight.disabled = false
		$Sliding.disabled = true
	
func detect_area():
	var bodies = $HBox.get_overlapping_bodies()
	var areas = $HBox.get_overlapping_areas()
	
	var has_metal = false
	
	for body in bodies:
		if body.name in MONSTERS:
			print("You Died!!")
			GameVariables.reset()
			get_tree().change_scene(world_scene)
		elif body.name == "Metal":
			has_metal = true
		elif body.name.begins_with("MovingPlatform"):
			position.x += body.motion
	
	for area in areas:
		if area.name == "SpikeArea":
			print("You Died!!")
			GameVariables.reset()
			get_tree().change_scene(world_scene)
		
	if has_metal:
		wall_jump = false
	else:
		wall_jump = true
	
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
		direction = 1
		
		if is_on_floor():
			in_air = false
		
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
		direction = -1
		
		if is_on_floor():
			in_air = false
		
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
		direction = 0
		run = false
		#wall_jump = true
		
		if slide:
			motion.x = lerp(motion.x, 0, 0.05)
		
		if !low:
			motion.x = lerp(motion.x, 0, 0.2)
		
			$Sprite.play("Idle")
			in_air = false
			
		
		friction = true
		
	if Input.is_action_just_released("ui_right"):
		right = true
	if Input.is_action_just_released("ui_left"):
		left = true
	
func on_wall_action():
	if is_on_wall() and in_air and wall_jump and !test_move(body_check, Vector2(0,75)):
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
		
		if is_on_wall():
			var bodies = $HBox.get_overlapping_bodies()
			
			for body in bodies:
				if (body.get_class() == "RigidBody2D"):
#					motion.x = direction*WALK_SPEED
#
#					if($Sprite.animation != "Walk"):
#						run = false
#						$Sprite.play("Walk") 
#
					if(direction != 0):
						if run:
							motion.x = direction*RUN_SPEED
							body.linear_velocity = Vector2(direction*RUN_SPEED, 0)
						else:
							motion.x = direction*WALK_SPEED
							body.linear_velocity = Vector2(direction*WALK_SPEED, 0)
						
			
		

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
		change_collsion_shape()
		
		if motion.y < 0:
			$Sprite.play("Jump") 
		else:
			$Sprite.play("Fall")
		
		if friction:
			motion.x = lerp(motion.x, 0, 0.05)
			
func items_action():
	#add select item feature...
	if Input.is_action_just_pressed("ui_switch"):
		item_index += 1
		item_index %= GameVariables.total_items
		
		$Camera2D.get_child(0).update_select()
		
	
	
	if Input.is_action_just_pressed("ui_item"):
		if item_index == 0 and GameVariables.items[0] > 0:
			print("Use rock")
			GameVariables.items[0] -= 1
			
			var block = Blocks.instance()
			
			var pos = self.global_position
			
			if $Sprite.flip_h:
				pos.x -= 32
			else:
				pos.x += 32
				
			block.start(pos)
			#block.name = "Rock" + string(self.get_node("../Rocks").get_child_count())
			print(block.name)
			self.get_node("../Rocks").add_child(block)
			print(self.get_node("../Rocks").get_child(self.get_node("../Rocks").get_child_count() - 1).name)
			
		elif item_index == 1 and GameVariables.items[1] > 0:
			if Input.is_action_just_pressed("ui_item"):
				print("Throw Ball")
				GameVariables.items[1] -= 1
				
				var ball = Balls.instance()
				var pos = self.global_position
				if $Sprite.flip_h:
					pos.x -= 20
					BALL_MOTION.x = -abs(BALL_MOTION.x)
				else:
					pos.x += 20
					BALL_MOTION.x = abs(BALL_MOTION.x)
		
				ball.start(pos, BALL_MOTION)
		
				self.get_node("../Balls").add_child(ball)

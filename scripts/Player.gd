extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 40
const MAX_FALL_SPEED = 500
const JUMP_HEIGHT = 700
const ACCELERATION = 50
const MAX_SPEED = 300
const MAX_DASH_SPEED = 1500
const AIR_FRICTION = 0.05
const GROUND_FRICTION = .3
const JUMP_FALLOFF_SPEED = .5

var motion = Vector2()
var friction = false


func _physics_process(delta):
#	if Input.is_action_pressed("ui_right"):
#		motion.x = SPEED
#	elif Input.is_action_pressed("ui_left"):
#		motion.x = -SPEED
#	else:
#		motion.x = 0
#
#	if is_on_floor():
#		if Input.is_action_just_pressed("ui_up"):
#			motion.y = JUMP_VEL
#
#	motion.y += GRAVITY
#
#	motion = move_and_slide(motion, UP)

	
	if motion.y < MAX_FALL_SPEED:
		motion.y += GRAVITY

	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMP_HEIGHT
	if Input.is_action_just_released("jump") and motion.y < 0:
		motion.y = lerp(motion.y, 0, JUMP_FALLOFF_SPEED)
			
	friction = false

	if Input.is_action_pressed("move_right"):
		motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
	elif Input.is_action_pressed("move_left"):
		motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
	else:
		friction = true

	if is_on_floor():
		if friction:
			motion.x = lerp(motion.x, 0, GROUND_FRICTION)
	else:
		if friction:
			motion.x = lerp(motion.x, 0, AIR_FRICTION)
		
	motion = move_and_slide(motion, UP)
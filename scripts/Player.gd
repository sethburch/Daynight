extends KinematicBody2D
class_name Player

const DUST_PARTICLE = preload("../scenes/DustParticle.tscn")
const SPELL = preload("../scenes/Spell.tscn")

const UP = Vector2(0, -1)
const GRAVITY = Vector2(0, 900)
const MAX_FALL_SPEED = Vector2(0, 1500)
const JUMP_SPEED = 400
const JUMP_HEIGHT = 400
const ACCELERATION = 50
const AIR_ACCELERATION = 30
const MAX_SPEED = 200
const MAX_DASH_SPEED = 1500
const AIR_FRICTION = 0.05
const GROUND_FRICTION = .3
const JUMP_FALLOFF_SPEED = .5
const JUMP_BUFFER = 8

var motion = Vector2()
var friction = false

var anim = ""
var new_anim = ""
var facing_right = true
var falling = false
var coyote_jump_buffer = 0
var jump_buffer = 0
var jump_release_buffer = 0

var haxis = 1
var vaxis = 0
var player_dir = haxis

func _ready():
	add_to_group("Player")

func _physics_process(delta):

	haxis = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	vaxis = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if haxis != 0:
		player_dir = haxis

	#add gravity if we havent reached max fall speed yet
	if motion.y < MAX_FALL_SPEED.y:
		motion += delta * GRAVITY
	
	#move
	motion = move_and_slide(motion, UP)
	
	#play idle if we're not landing
	if anim != "squash":
		new_anim = "idle"
	
	#play landing animation when hitting ground
	if is_on_floor() and anim == "jump_fall":
		dust_particle()
		new_anim = "squash"

	#coyote jump buffer
	if is_on_floor():
		coyote_jump_buffer = JUMP_BUFFER
	if coyote_jump_buffer > 0:
		coyote_jump_buffer-=1
		
	#ground jump buffer
	if Input.is_action_just_pressed("jump") and jump_buffer == 0:
		jump_buffer = JUMP_BUFFER
	if jump_buffer > 0:
		jump_buffer-=1
		
	#ground jump release buffer
	if Input.is_action_just_released("jump") and jump_release_buffer == 0:
		jump_release_buffer = JUMP_BUFFER
	if jump_release_buffer > 0:
		jump_release_buffer-=1
		
	#if we're on the floor and press jump, then jump (includes buffer)
	if (is_on_floor() or coyote_jump_buffer > 0) and (Input.is_action_just_pressed("jump") or jump_buffer > 0):
		coyote_jump_buffer = 0
		jump_buffer = 0
		motion.y = -JUMP_SPEED
		new_anim = "jump_inital"
		dust_particle()
	#play jump animations
	elif !is_on_floor():
		if motion.y > -100 and motion.y < 100:
			new_anim = "jump_peak"
		elif motion.y < 0 and motion.y > -JUMP_SPEED+100:
			new_anim = "jump_rise"
		elif motion.y > 0:
			new_anim = "jump_fall"
			falling = true
	
	#if we release the jump key while rising then cut off the jump
	if (Input.is_action_just_released("jump") or jump_release_buffer > 0) and motion.y < 0:
		jump_release_buffer = 0
		motion.y = lerp(motion.y, 0, JUMP_FALLOFF_SPEED)
		new_anim = "jump_peak"
			
	#movement on ground
	if is_on_floor():
		if Input.is_action_pressed("move_right"):
			motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
			if motion.x < ACCELERATION*4:
				dust_particle()
				new_anim = "run_inital"
			else:
				new_anim = "run"
			facing_right = true
			friction = false
		elif Input.is_action_pressed("move_left"):
			motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
			if motion.x > -ACCELERATION*4:
				dust_particle()
				new_anim = "run_inital"
			else:
				new_anim = "run"
			facing_right = false
			friction = false
		else:
			friction = true
	#movement in air
	else:
		if Input.is_action_pressed("move_right"):
			motion.x = min(motion.x+AIR_ACCELERATION, MAX_SPEED)
			facing_right = true
			friction = false
		elif Input.is_action_pressed("move_left"):
			motion.x = max(motion.x-AIR_ACCELERATION, -MAX_SPEED)
			facing_right = false
			friction = false
		else:
			friction = true
			
	#random dust particles when moving
	if is_on_floor():
		if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
			if randi() % 12 == 0:
				dust_particle()

	#deceleration
	if is_on_floor():
		if friction:
			motion.x = lerp(motion.x, 0, GROUND_FRICTION)
	else:
		if friction:
			motion.x = lerp(motion.x, 0, AIR_FRICTION)
			
	#cast fireball
#	if Input.is_action_just_pressed("cast"):
#		var spell = SPELL.instance()
#		get_node("..").add_child(spell)
#		spell.set_position($Cast.get_position()+self.get_position())
#		spell.dir = Vector2(player_dir, 0)
#		spell._beam()

func _process(delta):
	#play animation
	if anim != new_anim:
		anim = new_anim
		$Sprite.play(anim)
	$Sprite.flip_h = !facing_right
	
	#set cast position (ghetto but works)
	if player_dir == -1 and sign($Cast.position.x) == 1:
		$Cast.position.x *= -1
	if player_dir ==  1 and sign($Cast.position.x) == -1:
		$Cast.position.x = abs($Cast.position.x)
		

func _on_Sprite_animation_finished():
	if $Sprite.animation == "squash":
		new_anim = "idle"
		
func dust_particle():
	var dust_particle = DUST_PARTICLE.instance()
	get_node("..").add_child(dust_particle)
	dust_particle.set_position(self.get_position())
	dust_particle.position.y += 16
	dust_particle.position.x -= 2
	
func get_cast_position() -> Vector2:
	return $Cast.position + position

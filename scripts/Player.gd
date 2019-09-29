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
const JUMP_BUFFER_MAX = 6

export(int) var MAX_HEALTH = 3
var health = MAX_HEALTH

var motion = Vector2()
var friction = false

var anim = ""
var new_anim = ""
var facing_right = true
var coyote_jump_buffer = 0
var jump_buffer = 0
var has_jumped = false

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

	#jumping with buffer
	if is_on_floor():
		coyote_jump_buffer = 0
		if !has_jumped and jump_buffer < JUMP_BUFFER_MAX:
			jump_buffer = JUMP_BUFFER_MAX
			has_jumped = true
			motion.y = -JUMP_SPEED
			new_anim = "jump_inital"
			dust_particle()
	jump_buffer+=1
		
	#jumping with coyote time
	if Input.is_action_just_pressed("jump"):
		jump_buffer = 0
		if !has_jumped and coyote_jump_buffer < JUMP_BUFFER_MAX:
			coyote_jump_buffer = JUMP_BUFFER_MAX
			has_jumped = true
			motion.y = -JUMP_SPEED
			new_anim = "jump_inital"
			dust_particle()
	coyote_jump_buffer+=1

	#if we release the jump key while rising then cut off the jump
	if Input.is_action_just_released("jump"):
		has_jumped = false
		#if we're falling
		if motion.y < 0:
			motion.y = lerp(motion.y, 0, JUMP_FALLOFF_SPEED)
			new_anim = "jump_peak"

	#play jump animations
	if !is_on_floor():
		if motion.y > -100 and motion.y < 100:
			new_anim = "jump_peak"
		elif motion.y < 0 and motion.y > -JUMP_SPEED+100:
			new_anim = "jump_rise"
		elif motion.y > 0:
			new_anim = "jump_fall"
			
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

func _process(delta):
	#play animation
	if anim != new_anim:
		anim = new_anim
		$Sprite.play(anim)
	$Sprite.flip_h = !facing_right
	
	#cast a spell based on current tome in inventory
	if $Inventory.current_tome != null:
		if Input.is_action_just_pressed("cast"):
			var this_spell = $Inventory.current_tome.current_school.instance()
			this_spell.move = $Inventory.current_tome.current_movement
			this_spell.position = $Cast.position + position
			this_spell.dir = Vector2(player_dir, 0)
			this_spell.spell_owner = self
			get_node("..").add_child(this_spell)
	
	#set cast position (ghetto but works)
	if player_dir == -1 and sign($Cast.position.x) == 1:
		$Cast.position.x *= -1
	if player_dir ==  1 and sign($Cast.position.x) == -1:
		$Cast.position.x = abs($Cast.position.x)
		
	#kill player
	if health <= 0:
		get_tree().reload_current_scene()

func _on_Sprite_animation_finished():
	if $Sprite.animation == "squash":
		new_anim = "idle"
		
func dust_particle():
	var dust_particle = DUST_PARTICLE.instance()
	get_node("..").add_child(dust_particle)
	dust_particle.set_position(self.get_position())
	dust_particle.position.y += 16
	dust_particle.position.x -= 2
	
func damage(damage, knockback_dir):
	print_debug("hurt player")
	health -= damage
	motion += knockback_dir * 50

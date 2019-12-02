extends KinematicBody2D
class_name Player

const DUST_PARTICLE = preload("../scenes/DustParticle.tscn")
var damage_num = preload("../scenes/DamageNum.tscn")

const UP = Vector2(0, -1)
const GRAVITY = 900
const MAX_FALL_SPEED = 500
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

export(int) var MAX_HEALTH = 100
var health = MAX_HEALTH

var on_ladder = false
var current_ladder = null
var ladder_jump = false
var crouching = false

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

var hit_time = 0
export(int) var i_frames = 60

export(int) var CAST_SPEED = 60
var cast_timer = 0

func _ready():
	add_to_group("Player")

func _physics_process(delta):
	haxis = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	vaxis = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if haxis != 0:
		player_dir = haxis

	#add gravity if we havent reached max fall speed yet
	if !is_on_floor() and !on_ladder:
		motion.y += GRAVITY * delta
		if motion.y >= MAX_FALL_SPEED:
			motion.y = MAX_FALL_SPEED
	
	#move
	var snap_vector = Vector2(0, 7) # magic number is 7, keeps us attached to slopes
	if has_jumped or on_ladder:
		snap_vector = Vector2(0, 0)
	motion = move_and_slide_with_snap(motion, snap_vector, UP, true, 4, deg2rad(46))
	
	#play idle if we're not landing and crouching and looking up (ill fix this later i promise)
	if anim != "squash" and anim != "to_crouch" and anim != "looking_up" and anim != "look_up" and anim != "crouching" and anim != "hurting" and anim != "hurt":
		new_anim = "idle"
		
	#crouching and looking up
	if is_on_floor() and (floor(motion.x) < 10 and floor(motion.x) > -10) and current_ladder == null:
		if Input.is_action_pressed("move_down") and (!Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right")):
			crouching = true
			if Input.is_action_just_pressed("jump"):
				set_collision_layer_bit(5, 0)
				set_collision_mask_bit(5, 0)
			$Camera2D.mode = $Camera2D.MODES.PEEK_DOWN
			if anim != "crouching" and anim != "to_crouch":
				new_anim = "to_crouch"
		elif Input.is_action_pressed("move_up") and (!Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right")):
			$Camera2D.mode = $Camera2D.MODES.PEEK_UP
			if anim != "looking_up" and anim != "look_up":
				new_anim = "look_up"
		else:
			$Camera2D.mode = $Camera2D.MODES.CURSOR
			#new_anim = "idle"
			crouching = false
	else:
		$Camera2D.mode = $Camera2D.MODES.CURSOR
		#new_anim = "idle"
		crouching = false
	
	#play landing animation when hitting ground
	if is_on_floor() and anim == "jump_fall":
		dust_particle()
		new_anim = "squash"

	#jumping with buffer
	if is_on_floor() and !crouching:
		set_collision_layer_bit(5, 1)
		set_collision_mask_bit(5, 1)
		coyote_jump_buffer = 0
		if !has_jumped and jump_buffer < JUMP_BUFFER_MAX:
			jump_buffer = JUMP_BUFFER_MAX
			jump()
	jump_buffer+=1
		
	#jumping with coyote time
	if Input.is_action_just_pressed("jump") and !crouching:
		jump_buffer = 0
		if !has_jumped and coyote_jump_buffer < JUMP_BUFFER_MAX:
			coyote_jump_buffer = JUMP_BUFFER_MAX
			jump()
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
			if motion.x < ACCELERATION*4 and motion.x > 0:
				dust_particle()
				new_anim = "run_inital"
			else:
				new_anim = "run"
			facing_right = true
			friction = false
		elif Input.is_action_pressed("move_left"):
			motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
			if motion.x > -ACCELERATION*4 and motion.x > 0:
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
		if friction and motion.x != 0:
			motion.x = lerp(motion.x, 0, GROUND_FRICTION)
	else:
		if friction and motion.x != 0:
			motion.x = lerp(motion.x, 0, AIR_FRICTION)
			
	#ladders (INCREDIBLY CURSED)
	if current_ladder != null:
		#knock us off the ladder if we get hit
		if hit_time >= 0:
			on_ladder = false
		# only grab the ladder if we press up or down or if we havent just jumped on the ladder
		if Input.is_action_pressed("move_down") or (Input.is_action_pressed("move_up") and !ladder_jump):
			#put us at the center of the ladder
			global_position.x = lerp(global_position.x, current_ladder.global_position.x+7, 0.3)
			on_ladder = true
		elif is_on_floor():
			on_ladder = false
	else:
		on_ladder = false
	if ladder_jump and motion.y > -100 and motion.y < 100:
		ladder_jump = false
	if on_ladder:
		if !is_on_floor():
			new_anim = "climb"
		if Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up"):
			$Sprite.speed_scale = 1
		else:
			$Sprite.frame = 4
			$Sprite.speed_scale = 0
		motion.x = 0
		motion.y = 0
		if Input.is_action_pressed("move_down"):
			motion.y = MAX_SPEED/1.5
		elif Input.is_action_pressed("move_up"):
			motion.y = -MAX_SPEED/1.5
		if Input.is_action_just_pressed("jump"):
			jump()
			ladder_jump = true
			on_ladder = false
	else:
		$Sprite.speed_scale = 1

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
		
	#kill player
	if health <= 0:
		get_tree().reload_current_scene()
		
	if hit_time >= 0:
		if anim != "hurt" and anim != "hurting":
			new_anim = "hurt"
		hit_time+=1
		if hit_time > i_frames:
			new_anim = "idle"
			modulate = Color(1, 1, 1, 1)
			hit_time = -1
		
	cast_timer+=1
	if cast_timer < CAST_SPEED:
		return
	#cast a spell based on current tome in inventory
	if $Inventory.current_tome != null:
		if Input.is_action_just_pressed("cast"):
			cast_timer = 0
			var this_spell = $Inventory.current_tome.current_school.instance()
			this_spell.move = $Inventory.current_tome.current_movement
			this_spell.position = $Cast.position + position
			this_spell.dir = (get_global_mouse_position() - position).normalized()
			this_spell.SPEED *= 1 + (0.2 * $Stats.schoolstats[$Inventory.current_tome.school_num][$Stats.stats.speed])
			this_spell.SIZE *= 1 + (0.2 * $Stats.schoolstats[$Inventory.current_tome.school_num][$Stats.stats.size])
			this_spell.DAMAGE *= 1 + (0.2 * $Stats.schoolstats[$Inventory.current_tome.school_num][$Stats.stats.damage])
			this_spell.DOT_DAMAGE *= 1 + (0.2 * $Stats.schoolstats[$Inventory.current_tome.school_num][$Stats.stats.time])
			#this_spell.dir = Vector2(player_dir, 0)
			this_spell.spell_owner = self
			get_node("..").add_child(this_spell)

func _on_Sprite_animation_finished():
	if $Sprite.animation == "squash":
		new_anim = "idle"
	if $Sprite.animation == "to_crouch":
		new_anim = "crouching"
	if $Sprite.animation == "look_up":
		new_anim = "looking_up"
	if $Sprite.animation == "hurt":
		new_anim = "hurting"
		
func dust_particle():
	var dust_particle = DUST_PARTICLE.instance()
	get_node("..").add_child(dust_particle)
	dust_particle.set_position(self.get_position())
	dust_particle.position.y += 13
	dust_particle.position.x -= 2
	
func damage(damage, knockback_dir):
	if hit_time < i_frames and hit_time >= 0:
		return
	hit_time = 0
	motion = Vector2(0, 0)
	motion += knockback_dir * 100
	modulate = Color(1, 0, 0, 1)
	
	get_tree().paused = true
	yield(get_tree().create_timer(0.1), 'timeout')
	get_tree().paused = false
	
	#calculate damage including resistances/weaknesses
	var damage_calculation = round(damage)
	
	#take damage
	health -= damage_calculation
	
	#update health bar
	$GUILayer/GUI.set_health(health, MAX_HEALTH)
	
	#create damage number. places it into world root so it doesnt stick to the enemy's local position
	var _damage_num = damage_num.instance()
	_damage_num.rect_position = position
	_damage_num.text = str(damage_calculation)
	_damage_num.hit = self
	get_parent().add_child(_damage_num)

func jump():
	has_jumped = true
	motion.y = -JUMP_SPEED
	new_anim = "jump_inital"
	if is_on_floor():
		dust_particle()

func _on_LadderRadius_area_entered(area):
	if area.name == "Ladder":
		current_ladder = area

func _on_LadderRadius_area_exited(area):
	if area.name == "Ladder":
		current_ladder = null

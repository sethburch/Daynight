extends KinematicBody2D
class_name Spell

const UP = Vector2(0, -1)

enum MOVEMENT {BEAM, ARC, BOUNCE, BURST, MISSILE, ROCKET}
enum SCHOOL {FIRE, ICE}

var MAX_BOUNCE = 3
var dir := Vector2(0, 0)

export var MAX_FALL_SPEED = 0
export var GRAVITY = 0
export var ACCELERATION = 0
export var MAX_SPEED = 0
export var SPEED = 5
export var TRAVEL_TIME = 5
export var DESTROY_TIME = 2
export var DAMAGE = 1
export var SIZE = 1

var move = 0
var velocity := Vector2(0, 0)
var spell_done = false
var can_bounce = false
var needs_physics = true
var times_bounced = 0
var collision = null
var spell_owner

var type = SCHOOL.FIRE

export(Resource) var shoot_sound = preload("../sound/fireball_shoot.wav")
export(Resource) var hit_sound = preload("../sound/fireball_hit.wav")
export(Resource) var explosion_particle = preload("../scenes/FireExplodePart.tscn")

func _ready():
	_initial_cast()
	
	#start travel timer
	var travel_time = Timer.new()
	travel_time.connect("timeout", self, "_on_travel_time_timeout")
	add_child(travel_time)
	travel_time.wait_time = TRAVEL_TIME
	travel_time.start()
	scale = Vector2(SIZE, SIZE)
	
	collision = move_and_collide(Vector2(0,0))
	var failsafeTimer = 10
	if (collision && can_bounce):
		position.x -= 16 * dir.x
	while (collision && failsafeTimer >= 0):
		if !collision.get_collider().is_in_group("Player"):
			position += collision.normal
		collision = move_and_collide(Vector2(0,0))
		failsafeTimer -= 1

#when the spell is first cast (executed once)
func _initial_cast():
	$Sound.stream = shoot_sound
	$Sound.pitch_scale = rand_range(0.9, 1.1)
	$Sound.play()
	
	match move:
		MOVEMENT.BEAM:
			pass
		MOVEMENT.ARC:
			velocity += Vector2(dir.x, -1) * SPEED
		MOVEMENT.BOUNCE:
			can_bounce = true
			velocity += Vector2(dir.x, -1) * SPEED
		MOVEMENT.BURST:
			TRAVEL_TIME = 0.1
			SIZE = SIZE*1.5
		MOVEMENT.MISSILE:
			pass
		MOVEMENT.ROCKET:
			position.y -= 20
	
func _physics_process(delta):
	match move:
		MOVEMENT.BEAM:
			velocity.x = dir.x * SPEED
		MOVEMENT.ARC:
			velocity += Vector2(0, .5)
		MOVEMENT.BOUNCE:
			velocity += Vector2(0, .5)
		MOVEMENT.BURST:
			pass
		MOVEMENT.MISSILE:
			position = get_global_mouse_position()
		MOVEMENT.ROCKET:
			velocity.y = sin(((2*3.14)/120) * position.x) * SPEED
			velocity.x = dir.x * SPEED
			
	if needs_physics:
		collision = move_and_collide(velocity)
		if collision and can_bounce:
			_bounce(collision)

func _on_travel_time_timeout():
	#the spell has travelled for too long
	if !spell_done:
		_spell_finish()
		
	_start_destroy()
	
func _start_destroy():
	#destroy the particle after a certain amount of time
	var destroy_time = Timer.new()
	destroy_time.connect("timeout", self, "_on_destroy_time_timeout")
	add_child(destroy_time)
	destroy_time.wait_time = DESTROY_TIME
	destroy_time.start()
	
func _on_destroy_time_timeout():
	queue_free()
	
func _spell_finish():
	#play explosion effect, stop it from moving
	set_physics_process(false)
	
	$Sound.stream = hit_sound
	$Sound.pitch_scale = rand_range(0.9, 1.1)
	$Sound.play()
	
	get_node("..").screen_shake(.2, 15, 8)
	$Particles/Inner.emitting = false
	$Particles/Outer.emitting = false
	var explosion = explosion_particle.instance()
	add_child(explosion)
	explosion.emitting = true
	spell_done = true
	$CollisionShape2D.disabled = true
	_start_destroy()

func _bounce(col):
	if can_bounce and times_bounced < MAX_BOUNCE:
		$Sound.stream = shoot_sound
		$Sound.pitch_scale = rand_range(0.9, 1.1)
		$Sound.play()
		times_bounced+=1
		velocity = velocity.bounce(col.normal)
		return
		
func _on_Hitbox_body_entered(body):
	if spell_done:
		return

	if body == spell_owner:
		return

	if body.is_in_group("Player"):
		body.damage(DAMAGE, velocity)
		
	if body.is_in_group("Enemy"):
		body.damage(DAMAGE, velocity, type)

	if can_bounce and times_bounced < MAX_BOUNCE:
		return

	#the spell has hit a wall or enemy
	if !spell_done:
		_spell_finish()

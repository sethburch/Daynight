extends Enemy

const MAX_SPEED = 3
const ACCEL = 0.1
#var motion = Vector2(0, 0)
var wanderTimer = 0
var attackTimer = 10
var target = Vector2()
var rng = RandomNumberGenerator.new()
var collision = KinematicCollision2D.new()

onready var home = get_position()
onready var player = get_node("../Player")
onready var detectionRadius = get_node("PlayerDetect")

var fire_spell = preload("../scenes/SpellFire.tscn")

func _ready():
	._ready()
	damage_modifier[SCHOOL.FIRE] = MODIFIER_RESIST
	damage_modifier[SCHOOL.ICE] =  MODIFIER_WEAK

func _physics_process(delta):
	if detectionRadius.overlaps_body(player):
		target = player.get_position()
		if position.distance_to(player.get_position()) > 200:
			chase()
		else:
			if target.x < global_position.x:
				motion.x += ACCEL
			elif target.x > global_position.x:
				motion.x -= ACCEL
			if target.y > global_position.y:
				motion.y -= ACCEL
		if attackTimer < 0:
			print_debug("test")
			attack()
			attackTimer = rng.randi_range(10, 20)
		attackTimer -= 1
	elif wanderTimer < 0:
		wander()
		chase()
		wanderTimer = rng.randi_range(0, 60)
	else:
		attackTimer = rng.randi_range(10,20)
		wanderTimer -= 1
		chase()
	
	motion = motion.clamped(MAX_SPEED)
	
	collision = move_and_collide(motion)
	
	if collision:
		motion = motion * collision.normal * 2

func chase():
	if target.x < global_position.x:
		motion.x -= ACCEL
	elif target.x > global_position.x:
		motion.x += ACCEL
	if target.y < global_position.y:
		motion.y -= ACCEL
	elif target.y > global_position.y:
		motion.y += ACCEL

func wander():
	var tempRand = rng.randi_range(-100, 100)
	target.x += tempRand
	tempRand = rng.randi_range(-100, 100)
	target.y += tempRand
		
	if target.x > home.x + 200:
		target.x = home.x + 200
	elif target.x < home.x - 200:
		target.x = home.x - 200
	if target.y > home.y + 200:
		target.y = home.y + 200
	elif target.y < home.y - 200:
		target.y = home.y - 200
		
func attack():
	print_debug("test")
	var this_spell = fire_spell.instance()
	this_spell.move = MOVEMENT.BEAM
	this_spell.position = position
	this_spell.dir = Vector2(sign(player.position.x - position.x), 0)
	this_spell.spell_owner = self
	get_node("..").add_child(this_spell)
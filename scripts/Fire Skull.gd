extends Enemy

var MAX_SPEED = speed
const ACCEL = 5
var wanderTimer = 0
var attackTimer = 60
var target = Vector2()
var rng = RandomNumberGenerator.new()

onready var home = get_position()
onready var player = get_parent().get_parent().get_parent().get_node("../Player")
onready var detectionRadius = get_node("PlayerDetect")

var fire_spell = preload("../scenes/SpellFire.tscn")

func _ready():
	._ready()
	damage_modifier[SCHOOL.FIRE] = MODIFIER_RESIST
	damage_modifier[SCHOOL.ICE] =  MODIFIER_WEAK

func _physics_process(delta):
	._physics_process(delta)
#	if player == null:
#		return
	if detectionRadius.overlaps_body(player):
		target = player.get_global_position()
		if global_position.distance_to(player.get_global_position()) > 150:
			chase()
		else:
			if target.x < global_position.x:
				motion.x += ACCEL
			elif target.x > global_position.x:
				motion.x -= ACCEL
			if target.y > global_position.y:
				motion.y -= ACCEL
		if attackTimer < 0:
			attack()
			attackTimer = rng.randi_range(60, 120)
		attackTimer -= 1
	elif wanderTimer < 0:
		wander()
		chase()
		wanderTimer = rng.randi_range(0, 60)
	else:
		attackTimer = rng.randi_range(60, 120)
		wanderTimer -= 1
		chase()
	
	motion = motion.clamped(MAX_SPEED)
	
	collision = move_and_collide(motion*delta)
	
	if collision:
		motion = motion.bounce(collision.normal) * 2

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
	var this_spell = fire_spell.instance()
	this_spell.move = MOVEMENT.BEAM
	this_spell.dir = global_position.direction_to(player.global_position)#Vector2(sign(player.position.x - position.x), 0)
	this_spell.global_position = global_position + (this_spell.dir*20)
	this_spell.spell_owner = self
	this_spell.DAMAGE = DAMAGE
	get_node("..").add_child(this_spell)
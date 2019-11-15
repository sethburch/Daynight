extends KinematicBody2D
class_name Enemy

enum MOVEMENT {BEAM, ARC, BOUNCE, BURST, MISSILE, ROCKET}
enum SCHOOL {FIRE, ICE, LIGHTNING}
var damage_modifier = [1, 1, 1]

var death_particle = preload("../scenes/DeathParticle.tscn")
var death_sound = preload("../sound/death_sound.wav")
var damage_num = preload("../scenes/DamageNum.tscn")
var DOT = preload("../scenes/DOT.tscn")
var slow_effect = preload("../scenes/SlowEffect.tscn")
var paralyze_effect = preload("../scenes/ParalyzeEffect.tscn")

var collision = null
export(int) var speed = 100

const MODIFIER_WEAK = 1.75
const MODIFIER_RESIST = 0.25

var part_angle = 0
var motion = Vector2(0, 0)
export(float) var KNOCKBACK_AMOUNT = 100
export(int) var health = 100
export(int) var DAMAGE = 30
export(bool) var DOES_CONTACT_DAMAGE = true

var hit_time = 0
const HIT_TIME = 15

func _ready():
	add_to_group("Enemy")

func _physics_process(delta):
	if !DOES_CONTACT_DAMAGE:
		return
	if collision == null:
		return
	if collision.collider == null:
		return
	if collision.collider.is_in_group("Player"):
		collision.collider.damage(DAMAGE, (collision.position - position).normalized())

func damage(damage, crit_chance, knockback_dir, spell, is_dot):
	#do knockback
	motion += knockback_dir.normalized() * KNOCKBACK_AMOUNT
	#check for crit
	var crit_modifier = 1
	if randf() <= crit_chance:
		crit_modifier = 2
	
	#calculate damage including resistances/weaknesses
	var damage_calculation = round(damage * damage_modifier[spell] * crit_modifier)
	
	#create damage number. places it into world root so it doesnt stick to the enemy's local position
	var _damage_num = damage_num.instance()
	var _modifier_text = ""
	_damage_num.rect_position = position
	if crit_modifier > 1:
		_damage_num.crit = true
	if damage_modifier[spell] > 1:
		_modifier_text = "\nWeak"
	elif damage_modifier[spell] < 1:
		_modifier_text = "\nResist"
	_damage_num.text = str(damage_calculation) + _modifier_text
	_damage_num.hit = self
	_damage_num.is_dot = is_dot
	get_parent().add_child(_damage_num)
	
	#do damage and create particles
	health -= damage_calculation
	hit_time = 0
	part_angle = knockback_dir.angle()
	#modulate = Color(1, 0, 0, 1)
	set_process(true)
	
func _process(delta):
	if health <= 0:
		var sound = get_parent().get_parent().get_parent().get_node("../WorldSound")
		sound.stream = death_sound
		sound.pitch_scale = rand_range(0.9, 1.1)
		sound.play()
		
		var part = death_particle.instance()
		get_node("..").add_child(part)
		part.position = position
		part.rotation = part_angle
		part.emitting = true
		queue_free()
	
	hit_time+=1
	if hit_time > HIT_TIME:
		#modulate = Color(1, 1, 1, 1)
		hit_time = 0
		set_process(false)
		
func apply_dot(DOT_DAMAGE, time, ticks, type):
	var dot = DOT.instance()
	dot.damage = DOT_DAMAGE
	dot.length = time
	dot.tick_length = ticks
	dot.type = type
	add_child(dot)

func apply_slow(time, amount):
	var slow = slow_effect.instance()
	slow.length = time
	slow.amount = amount
	add_child(slow)
	
func apply_paralyze(time):
	var paralyze = paralyze_effect.instance()
	paralyze.length = time
	add_child(paralyze)
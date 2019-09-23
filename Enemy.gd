extends KinematicBody2D
class_name Enemy

var death_particle = preload("../DeathParticle.tscn")
var death_sound = preload("../sound/death_sound.wav")

var part_angle = 0
var motion = Vector2(0, 0)
export(float) var KNOCKBACK_AMOUNT = 100
export(int) var health = 3

var hit_time = 0
const HIT_TIME = 15

func damage(knockback_dir):
	motion += knockback_dir * KNOCKBACK_AMOUNT
	health -= 1
	hit_time = 0
	part_angle = knockback_dir.angle()
	modulate = Color(1, 0, 0, 1)
	set_process(true)
	
func _process(delta):
	if health <= 0:
		var sound = get_node("../WorldSound")
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
		modulate = Color(1, 1, 1, 1)
		hit_time = 0
		set_process(false)
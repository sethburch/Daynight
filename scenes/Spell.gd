extends Area2D
class_name Spell

const UP = Vector2(0, -1)
const EXPLOSION_PART = preload("res://FireExplodePart.tscn")

enum MOVEMENT {BEAM, ARC, BOUNCE}

var dir := Vector2(0, 0)
export var MAX_FALL_SPEED = 0
export var GRAVITY = 0
export var ACCELERATION = 0
export var MAX_SPEED = 0
export var SPEED = 0
export var TRAVEL_TIME = 5

export var SIZE = 1

var move = 0
var velocity := Vector2(0, 0)
var spell_done = false

func _ready():
	connect("body_entered", self, "_on_body_entered")
	
	#start travel timer
	var travel_time = Timer.new()
	travel_time.connect("timeout", self, "_on_travel_time_timeout")
	add_child(travel_time)
	travel_time.wait_time = TRAVEL_TIME
	travel_time.start()
	
	scale = Vector2(SIZE, SIZE)
	
func _physics_process(delta):
	match move:
		MOVEMENT.BEAM:
			position.x += dir.x * SPEED
		MOVEMENT.ARC:
			pass
		MOVEMENT.BOUNCE:
			pass
	
func _on_body_entered(body):
	if spell_done:
		return
	if body.is_a_parent_of(self):
		return
	if body.is_in_group("Player"):
		return
	#the spell has hit a wall or enemy
	if !spell_done:
		_spell_finish()
	
func _on_travel_time_timeout():
	#the spell has travelled for too long
	if !spell_done:
		_spell_finish()
	
	#destroy the particle after a certain amount of time
	var destroy_time = Timer.new()
	destroy_time.connect("timeout", self, "_on_destroy_time_timeout")
	add_child(destroy_time)
	destroy_time.wait_time = TRAVEL_TIME
	destroy_time.start()

func _on_destroy_time_timeout():
	queue_free()
	
func _spell_finish():
	#play explosion effect, stop it from moving
	set_physics_process(false)
	get_node("..").screen_shake(.2, 15, 8)
	$Particles/Inner.emitting = false
	$Particles/Outer.emitting = false
	var explosion = EXPLOSION_PART.instance()
	add_child(explosion)
	explosion.emitting = true
	spell_done = true
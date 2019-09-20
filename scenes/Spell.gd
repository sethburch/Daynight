extends Area2D
class_name Spell

const UP = Vector2(0, -1)

enum MOVEMENT {BEAM, ARC, BOUNCE}

var dir := Vector2(0, 0)
export var MAX_FALL_SPEED = 0
export var GRAVITY = 0
export var ACCELERATION = 0
export var MAX_SPEED = 0
export var SPEED = 0
export var TRAVEL_TIME = 1

var move = 0
var velocity := Vector2(0, 0)

func _ready():
	connect("body_entered", self, "_on_body_entered")
	var travel_time = Timer.new()
	travel_time.connect("timeout", self, "_on_timer_timeout")
	add_child(travel_time)
	travel_time.wait_time = TRAVEL_TIME
	travel_time.start()
	
func _physics_process(delta):
	match move:
		MOVEMENT.BEAM:
			position.x += dir.x * SPEED
		MOVEMENT.ARC:
			pass
	
func _on_body_entered(body):
	if body.is_a_parent_of(self):
		return
	if body.is_in_group("Player"):
		return
	queue_free()
	
func _on_timer_timeout():
	queue_free()
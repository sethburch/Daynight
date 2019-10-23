extends Node2D

enum SCHOOL {FIRE, ICE, LIGHTNING}

var damage = 0
var length = 0
var tick_length = 0
var type = SCHOOL.FIRE
var dot_tick_timer = 0

func _ready():
	var dot_length = Timer.new()
	dot_length.connect("timeout", self, "_on_dot_length_timeout")
	add_child(dot_length)
	dot_length.wait_time = length
	dot_length.start()
	get_parent().modulate = Color(1, .5, .2)
	
func _process(delta):
	dot_tick_timer+=1
	if (tick_length * 60) <= dot_tick_timer:
		dot_tick_timer = 0
		get_parent().damage(damage, 0, Vector2(0, 0), type, true)
	
func _on_dot_length_timeout():
	get_parent().modulate = Color(1,1,1)
	queue_free()
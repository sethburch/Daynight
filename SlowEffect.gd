extends Node2D

var length = 0
var amount = 2

var default_speed = 0

func _ready():
	var slow_length = Timer.new()
	slow_length.connect("timeout", self, "_on_slow_length_timeout")
	add_child(slow_length)
	slow_length.wait_time = length
	slow_length.start()
	
	default_speed = get_parent().speed
	get_parent().speed = get_parent().speed / amount
	get_parent().modulate = Color(0, 0, 1)
	
func _on_slow_length_timeout():
	get_parent().modulate = Color(0, 0, 0)
	get_parent().speed = default_speed
	queue_free()
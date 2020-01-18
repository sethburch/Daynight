extends Node2D

var length = 0
var amount = 2

var default_speed = 0

func _ready():
	var paralyze_length = Timer.new()
	paralyze_length.connect("timeout", self, "_on_paralyze_length_timeout")
	add_child(paralyze_length)
	paralyze_length.wait_time = length
	paralyze_length.start()
	
	get_parent().set_physics_process(false)
	get_parent().modulate = Color(1, .8, .2)
	
func _on_paralyze_length_timeout():
	get_parent().modulate = Color(1, 1, 1)
	get_parent().set_physics_process(true)
	queue_free()
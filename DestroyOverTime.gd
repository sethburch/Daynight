extends Node2D

export(float) var DESTROY_TIME = 5.0

func _ready():
	var destroy_time = Timer.new()
	destroy_time.connect("timeout", self, "_on_destroy_time_timeout")
	add_child(destroy_time)
	destroy_time.wait_time = DESTROY_TIME
	destroy_time.start()

func _on_destroy_time_timeout():
	queue_free()
extends Node

func _ready():
	randomize()
	
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func screen_shake(duration, frequency, amplitude):
	get_node("Player/Camera2D").shake(duration, frequency, amplitude)
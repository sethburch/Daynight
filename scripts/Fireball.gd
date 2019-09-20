extends Area2D

const SPEED = 400
export(int) var speed_x = 1
export(int) var speed_y = 0	

	
func _process(delta):
	var motion = Vector2(speed_x, speed_y) * SPEED
	set_position(get_position() + motion * delta)

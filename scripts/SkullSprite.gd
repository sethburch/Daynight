extends AnimatedSprite

onready var fireSkull = get_parent()

func _process(delta):
	if fireSkull.attackTimer < 36: 
		set_animation("Attack")
	else: set_animation("Idle")
	
	if fireSkull.target.x < fireSkull.get_position().x:
		set_flip_h(true)
	else: set_flip_h(false)
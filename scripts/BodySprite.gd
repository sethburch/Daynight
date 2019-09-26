extends AnimatedSprite

onready var slime = get_parent()

func _process(delta):
	if slime.motion.y < 0:
		set_animation("Jump_rise")
	elif slime.waitTimer < 20:
		set_animation("Prejump")
	else:
		set_animation("Idle")
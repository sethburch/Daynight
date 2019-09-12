extends AnimatedSprite

onready var slime = get_parent()

func _process(delta):
	if slime.angry:
		set_frame(1)
		if abs(slime.target.x - slime.global_position.x) < 30:
			if slime.target.y < slime.global_position.y:
				set_animation("LookUp")
		elif slime.target.y - slime.global_position.y > 3 * abs(slime.target.x - slime.global_position.x):
			set_animation("Idle")
		elif slime.target.x > slime.global_position.x:
			set_animation("LookSide")
			set_flip_h(false)
		elif slime.target.x < slime.global_position.x:
			set_animation("LookSide")
			set_flip_h(true)
		if slime.waitTimer < 20:
			set_animation("Prejump")
		set_frame(1)
	elif slime.motion.x == 0:
		if slime.motion.y < 0:
			set_animation("LookUp")
		elif slime.motion.y == 0:
			set_animation("Idle")
	elif slime.motion.x > 0:
		set_animation("LookSide")
		set_flip_h(false)
	elif slime.motion.x < 0:
		set_animation("LookSide")
		set_flip_h(true)
	else:
		set_animation("Idle")
	if slime.waitTimer < 20:
		set_animation("Prejump")
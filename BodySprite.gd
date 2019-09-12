extends AnimatedSprite

onready var slime = get_parent()

func _process(delta):
	if !slime.is_on_floor():
		set_animation("Jump")
	elif slime.waitTimer < 20:
		set_animation("Prejump")
	else:
		set_animation("Idle")
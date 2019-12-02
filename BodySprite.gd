extends AnimatedSprite

onready var mush = get_parent()

func _process(delta):
	if mush.target.x < mush.get_position().x:
		set_flip_h(true)
	else: set_flip_h(false)
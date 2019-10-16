extends Enemy

const UP = Vector2(0, -1)

func _ready():
	pass

func _physics_process(delta):
	motion.y += 20
	motion = move_and_slide(motion, UP)
	
	motion.x = lerp(motion.x, 0, 0.5)
	
	for body in $PlayerDetect.get_overlapping_bodies():
		if $Body.animation == "angry":
			return
		if body is Player:
			$Body.play("angry")

func _on_Body_animation_finished():
	if $Body.animation == "angry":
		$Explosion.visible = true
		$Explosion/AnimationPlayer.play("explosion")

func _on_AnimationPlayer_animation_finished(anim_name):
	$Explosion/AnimationPlayer.stop()
	$Explosion.visible = false
	$Body.play("idle")

func _on_Area2D_body_entered(body):
	if body is Player:
		body.damage(DAMAGE, body.position - position)

extends AnimatedSprite
#
#const IDLE_ANIM = preload("res://sprites/player/idle.png")
#const JUMP_ANIM = preload("res://sprites/player/jump_fall.png")
#
#func _on_Player_animation_changed(anim_name):
#	if anim_name == "jump_inital":
#		texture = JUMP_ANIM
#		hframes = 8
#	$AnimationPlayer.play(anim_name)
#
#
#func _on_AnimationPlayer_animation_finished(anim_name):
#	if anim_name == "jump_inital":
#		$AnimationPlayer.play("jump_rise")
#	if anim_name == "jump_peak":
#		$AnimationPlayer.play("jump_fall")
#	if anim_name == "squash":
#		texture = IDLE_ANIM
#		hframes = 3
#		$AnimationPlayer.play("idle")




func _on_Player_animation_changed(anim_name):
	play(anim_name)

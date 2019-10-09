extends Label

var hit = null
var crit = false

var damage_color = "#ffffff"
export(Color) var player_color = Color("#ff6157")
export(Color) var crit_color = Color("#ff823b")
export(Color) var enemy_color = Color("#ffffff")

func _ready():
	if hit.is_in_group("Player"):
		damage_color = player_color
	else:
		damage_color = enemy_color
	if crit:
		damage_color = crit_color
	$AnimationPlayer.play("damage")
	$Tween.interpolate_property(
		self, "rect_position",
		rect_position,
		Vector2(rect_position.x, rect_position.y-50),
		2.0,
		Tween.TRANS_BACK,
		Tween.EASE_OUT,
		0.0)
	$Tween.start()
	set("custom_colors/font_color", damage_color)

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

extends ParallaxLayer

var dawn_texture = preload("res://sprites/backgrounds/sky/sky_morning.png")
var day_texture = preload("res://sprites/backgrounds/sky/sky_day.png")
var night_texture = preload("res://sprites/backgrounds/sky/sky_night.png")

func _on_CycleController_time(cycle_state):
	match cycle_state:
		Global.Cycle.DAWN:
			$BG.texture = dawn_texture
		Global.Cycle.DAY:
			$BG.texture = day_texture
		Global.Cycle.NIGHT:
			$BG.texture = night_texture
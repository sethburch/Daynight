extends Light2D

func _ready():
	$AnimationPlayer.play("light")
	
func fade():
	$AnimationPlayer.play("fade")

func _on_CycleController_time(cycle_state):
	match cycle_state:
		Global.Cycle.DAWN:
			visible = false
			$AnimationPlayer.play("fade")
		Global.Cycle.NIGHT:
			visible = true
			$AnimationPlayer.play("light")
extends Light2D

func _ready():
	$AnimationPlayer.play("light")
	
func fade():
	$AnimationPlayer.play("fade")

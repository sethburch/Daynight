extends Polygon2D

var player = null
var dir = 0
var spd = 0

func _ready():
	set_process(false)


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		spd = player.motion.x
		$Skeleton2D/Bone2D.position.x = sign(body.player_dir) * abs(spd/20)
		dir = body.player_dir
		set_process(true)
		#$Skeleton2D/Bone2D.position.x = lerp(8 * sign(body.player_dir), 0, 0.1)
		
func _process(delta):
	$Skeleton2D/Bone2D.position.x += sin(((2*3.14)/180) * $Skeleton2D/Bone2D.position.x) * dir
	#dir += (1 * sign(dir))
	if $Skeleton2D/Bone2D.position.x > 10 and dir == 1:
		dir = -1
	if $Skeleton2D/Bone2D.position.x < -10 and dir == -1:
		dir = 1
		#set_process(false)
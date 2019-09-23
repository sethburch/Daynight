extends Enemy

const UP = Vector2(0, -1)
const GRAVITY = 20
const JUMP_VEL_HIGH = Vector2(250, -575)
const JUMP_VEL_LOW = Vector2(150, -450)
#var motion = Vector2()
var waitTimer = 100
var target = Vector2(0,0)
var angry = false
var rng = RandomNumberGenerator.new()

onready var player = get_node("../Player")
onready var detectionRadius = get_node("PlayerDetect")

func _physics_process(delta):
	if detectionRadius.overlaps_body(player):
		target = player.get_global_position()
		if waitTimer > 20:
			waitTimer = 20
		angry = true
	elif waitTimer < 1:
		angry = false
		var tempRand = rng.randi_range(0, 20)
		if tempRand == 20:
			target = Vector2(global_position.x + 100, global_position.y + 100)
		elif tempRand == 19:
			target = Vector2(global_position.x - 100, global_position.y + 100)
		elif tempRand > 12:
			target = Vector2(global_position.x + 75, global_position.y)
		elif tempRand > 6:
			target = Vector2(global_position.x - 75, global_position.y)
		else:
			target = Vector2(global_position.x, global_position.y + 20)
	else:
		angry = false
	if is_on_floor():
		motion.x = 0
		waitTimer -= 1
		chase()
	
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, UP)

func chase():
	if waitTimer < 0:
		if global_position.distance_to(target) > 125:
			motion = JUMP_VEL_HIGH
		else:
			motion = JUMP_VEL_LOW
		if target.x < global_position.x:
			motion.x *= -1
		elif target.x == global_position.x:
			motion.x = 0
		waitTimer = rng.randi_range(20, 120)
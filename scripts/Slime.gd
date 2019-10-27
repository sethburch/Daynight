extends Enemy

const UP = Vector2(0, -1)
var GRAVITY = speed/5
const JUMP_VEL_HIGH = Vector2(180, -475)
const JUMP_VEL_LOW = Vector2(100, -350)

var waitTimer = 100
var jumpTimer = 20
var target = Vector2(0,0)
var angry = false
var rng = RandomNumberGenerator.new()
var anim = ""
var new_anim = ""

onready var player = get_node("../Player")
onready var detectionRadius = get_node("PlayerDetect")

func _ready():
	._ready()

func _physics_process(delta):
	._physics_process(delta)
	#play idle if we're not landing
	if anim != "Land":
		new_anim = "Idle"
	
	if detectionRadius.overlaps_body(player):
		target = player.get_global_position()
		if waitTimer > 0:
			waitTimer = 0
			jumpTimer = 20
		angry = true
	elif waitTimer < 1:
		angry = false
		var tempRand = rng.randi_range(0, 20)
		if tempRand == 20:
			target = Vector2(global_position.x + speed, global_position.y + speed)
		elif tempRand == 19:
			target = Vector2(global_position.x - speed, global_position.y + speed)
		elif tempRand > 12:
			target = Vector2(global_position.x + (speed-25), global_position.y)
		elif tempRand > 6:
			target = Vector2(global_position.x - (speed-25), global_position.y)
		else:
			target = Vector2(global_position.x, global_position.y + 20)
	else:
		angry = false
	
	motion.y += GRAVITY
	
	collision = move_and_collide(motion * delta)
	
	if collision:
		motion = motion.bounce(collision.normal) * .75
		if collision.normal == UP:
			motion.y = 0
			waitTimer -= 1
			chase()
			if anim == "Jump_fall":
				new_anim = "Land"
			if waitTimer < 0 && anim != "Land" && anim != "Jump_fall":
				jumpTimer -= 1
				new_anim = "Prejump"

	else:
		if motion.y < -1:
			new_anim = "Jump_rise"
		else:
			new_anim = "Jump_fall"
	
	if anim != new_anim:
		anim = new_anim
		$BodySprite.play(anim)

func chase():
	if waitTimer < 0 && jumpTimer < 0 && anim != "Land":
		if global_position.distance_to(target) > 100:
			motion = JUMP_VEL_HIGH
		else:
			motion = JUMP_VEL_LOW
		if target.x < global_position.x:
			motion.x *= -1
		elif target.x == global_position.x:
			motion.x = 0
		waitTimer = rng.randi_range(20, 120)
		jumpTimer = 20
		
func _on_BodySprite_animation_finished():
	if $BodySprite.animation == "Land":
		new_anim = "Idle"

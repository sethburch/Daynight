extends Enemy

const UP = Vector2(0, -1)
var GRAVITY = speed/5

const ACCEL = 5
var wanderTimer = 0
var attackTimer = 30
var target = Vector2()
var rng = RandomNumberGenerator.new()

var anim = ""
var new_anim = ""

var facing_right = true

onready var home = get_global_position()
onready var player = get_parent().get_parent().get_parent().get_node("../Player")
onready var detectionRadius = get_node("PlayerDetect")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	._physics_process(delta)
#	if player == null:
#		return
	$BodySprite.flip_h = facing_right
	if detectionRadius.overlaps_body(player):
		target = player.get_global_position()
		chase()
		if attackTimer < 0:
			attack()
		elif global_position.distance_to(player.get_global_position()) < 50:
			attackTimer -= 1
	elif wanderTimer < 0:
		wander()
		chase()
		wanderTimer = rng.randi_range(30, 180)
		attackTimer = 30
	else:
		attackTimer = 30
		wanderTimer -= 1
		chase()
	
	if motion.x > speed:
		motion.x = speed
	elif motion.x < (speed * -1):
		motion.x = speed * -1
	
	if new_anim != "Explosion":
		if abs(motion.x) < 5:
			new_anim = "Idle"
		else:
			new_anim = "Walk"
		
	
	if anim != new_anim:
		anim = new_anim
		$BodySprite.play(anim)
	
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, UP)

func chase():
	if target.x < global_position.x:
		facing_right = false
		motion.x -= ACCEL
	elif target.x > global_position.x:
		facing_right = true
		motion.x += ACCEL
	if (is_on_floor()) && (abs(global_position.x - target.x) < 80) && (target.y < global_position.y):
		motion.y = speed * -1

func wander():
	var tempRand = rng.randi_range(-100, 100)
	target.x += tempRand
	tempRand = rng.randi_range(-20, 50)
	target.y += tempRand
		
	if target.x > home.x + 200:
		target.x = home.x + 200
	elif target.x < home.x - 200:
		target.x = home.x - 200
	if target.y > home.y + 200:
		target.y = home.y + 200
	elif target.y < home.y - 50:
		target.y = home.y - 50
	if (abs(target.y - global_position.y) < 20):
		target.y = global_position.y

func attack():
	new_anim = "Explosion"
	$ExplosionRadius/Explosion.disabled = false
	speed = 0
	motion.x = 0
	motion.y = 0
	position.y -= 20
	GRAVITY = 0
	attackTimer = 300

func _on_BodySprite_animation_finished():
	if anim == "Explosion":
		queue_free()

func _on_ExplosionRadius_body_entered(body):
	if body.is_in_group("Player"):
		body.damage(DAMAGE*time_modifier, (body.global_position - global_position).normalized() * 6)

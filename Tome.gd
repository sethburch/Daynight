extends Node2D
class_name Tome

const UP = Vector2(0, -1)

enum MOVEMENT {BEAM, ARC, BOUNCE}

export(Array) var school = [preload("../scenes/SpellFire.tscn"), preload("../scenes/SpellIce.tscn")]

export(PackedScene) var current_school = school[0]
export(int) var current_movement = MOVEMENT.BEAM

func _ready():
	current_school = school[randi() % school.size()]
	current_movement = randi() % MOVEMENT.size()

func _physics_process(delta):
	if Input.is_action_just_pressed("cast"):
		var spell = current_school.instance()
		get_node("..").add_child(spell)
		spell.move = current_movement
		spell.position = get_node("../Player").get_cast_position()
		spell.dir = Vector2(get_node("../Player").player_dir, 0)
		
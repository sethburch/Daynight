extends Node2D
class_name Tome

const UP = Vector2(0, -1)

enum MOVEMENT {BEAM, ARC, BOUNCE}
var move_names = ["Beaming", "Arching", "Bouncing"]

export(Array) var school = [preload("../scenes/SpellFire.tscn"), preload("../scenes/SpellIce.tscn")]

export(PackedScene) var current_school = school[0]
export(int) var current_movement = MOVEMENT.BEAM

var tome_name = ""

func _ready():
	current_school = school[randi() % school.size()]
	current_movement = randi() % MOVEMENT.size()
	tome_name = current_school.instance().spell_name + " Tome of " + move_names[current_movement]
	print_debug(tome_name)

func _process(delta):
	if Input.is_action_just_pressed("cast"):
		var this_spell = current_school.instance()
		get_node("..").add_child(this_spell)
		this_spell.move = current_movement
		this_spell.position = get_node("../Player").get_cast_position()
		this_spell.dir = Vector2(get_node("../Player").player_dir, 0)
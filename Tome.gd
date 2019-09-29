extends Area2D
class_name Tome

const UP = Vector2(0, -1)

enum MOVEMENT {BEAM, ARC, BOUNCE, BURST, MISSILE, ROCKET, RAIL}
var move_names = ["Beaming", "Arching", "Bouncing", "Bursting", "Guiding", "Rocketing", "Unswerving"]

export(Array) var school = [preload("../scenes/SpellFire.tscn"), preload("../scenes/SpellIce.tscn")]

export(PackedScene) var current_school = school[0]
export(int) var current_movement = MOVEMENT.BEAM

var tome_name = ""

func _ready():
	current_school = school[randi() % school.size()]
	current_movement = randi() % MOVEMENT.size()
	tome_name = current_school.instance().spell_name + " Tome of " + move_names[current_movement]

#func _process(delta):
#	if Input.is_action_just_pressed("cast"):
#		var this_spell = current_school.instance()
#		this_spell.move = current_movement
#		this_spell.position = get_node("../Player").get_cast_position()
#		this_spell.dir = Vector2(get_node("../Player").player_dir, 0)
#		get_node("..").add_child(this_spell)
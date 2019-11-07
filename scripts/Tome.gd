extends Area2D
class_name Tome

const UP = Vector2(0, -1)

enum MOVEMENT {BEAM, ARC, BOUNCE, BURST, MISSILE, ROCKET, LEAP}
var move_names = ["Beaming", "Arching", "Bouncing", "Bursting", "Guiding", "Rocketing", "Leaping"]
var tome_sprites = [preload("../sprites/tomes/book_beam.png"),
					preload("../sprites/tomes/book_arc.png"),
					preload("../sprites/tomes/book_bounce.png"),
					preload("../sprites/tomes/book_burst.png"),
					preload("../sprites/tomes/book_guide.png"),
					preload("../sprites/tomes/book_sine.png"),
					preload("../sprites/tomes/defense_book.png")]

export(Array) var school = [preload("../scenes/SpellFire.tscn"),
							preload("../scenes/SpellIce.tscn"),
							preload("../scenes/SpellLightning.tscn")]

export(PackedScene) var current_school = school[0]
export(int) var current_movement = MOVEMENT.BEAM

var tome_name = ""
var this_tome_sprite = tome_sprites[0]
var this_tome_color = Color("#ffffff")

func _ready():
	randomize()
	add_to_group("Tome")
	$Sprites/AnimationPlayer.play("tome_float")
	
	current_school = school[randi() % school.size()]
	current_movement = randi() % MOVEMENT.size()
	
	tome_name = current_school.instance().spell_name + " Tome of " + move_names[current_movement]
	this_tome_color = current_school.instance().spell_color
	this_tome_sprite = tome_sprites[current_movement]
	
	$Sprites/Aura.modulate = this_tome_color
	$Sprites/Tome.texture = this_tome_sprite
	
func remove():
	get_parent().remove_child(self)
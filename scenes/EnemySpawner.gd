extends Position2D

var ground_enemies : Array = [
	preload("res://scenes/Slime.tscn"),
	preload("res://scenes/EnemyMushroom.tscn")
]
var air_enemies : Array = [
	preload("res://scenes/FireSkull.tscn")
]

export(bool) var ground = true

func _ready():
	var _enemy = ground_enemies[randi() % ground_enemies.size()].instance()
	if !ground:
		_enemy = air_enemies[randi() % air_enemies.size()].instance()
	_enemy.global_position = get_parent().get_parent().global_position
	add_child(_enemy)
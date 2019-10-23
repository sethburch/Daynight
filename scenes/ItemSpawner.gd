extends Position2D

var items : Array = [
	preload("res://scenes/Tome.tscn"),
	preload("res://scenes/Tome.tscn")
]

func _ready():
	var _item = items[randi() % items.size()].instance()
	_item.global_position = get_parent().global_position+position
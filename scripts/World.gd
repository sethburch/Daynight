extends Node

func _ready():
	randomize()
	
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	if $TileMap2 == null:
		return
	
	for i in $TileMap2.get_used_cells():
		$TileMap.set_cell(i.x, i.y, 0)
	$TileMap.update_bitmask_region()
	remove_child($TileMap2)
		
func screen_shake(duration, frequency, amplitude):
	get_node("Player/Camera2D").shake(duration, frequency, amplitude)
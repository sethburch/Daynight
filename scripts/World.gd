extends Node

enum cycle_state { NIGHT, DAWN, DAY, DUSK }

func _ready():
	randomize()
	for i in range(-100, 100):
		for j in range(-100, 100):
			if $TileMap.get_cell(i, j) != TileMap.INVALID_CELL:
				#$RainSplash.set_cell((i*4), (j*4)-3, 0)
				break
			#$Rain.set_cell(i, j, 0)
			$SnowBottom.set_cell(i, j, 0)
			$SnowTop.set_cell(i, j, 0)
	
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("scroll_down"):
		$TileMap.tile_set.tile_set_texture(1, load("res://sprites/snow_grass.png"))
	if Input.is_action_just_pressed("scroll_up"):
		$TileMap.tile_set.tile_set_texture(1, load("res://sprites/grass_tileset5.png"))
		
		
func screen_shake(duration, frequency, amplitude):
	get_node("Player/Camera2D").shake(duration, frequency, amplitude)

func _on_DayNightCycle2_time(cycle):
	if cycle == cycle_state.NIGHT:
		$Player/FlickeringLight.visible = true

	if cycle == cycle_state.DAWN:
		$Player/FlickeringLight.visible = false
		$SeasonController.start()

	if cycle == cycle_state.DAY:
		$Player/FlickeringLight.visible = false

	if cycle == cycle_state.DUSK:
		$Player/FlickeringLight.visible = false

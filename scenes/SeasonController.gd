extends Node2D

var new_season = 0

enum SEASONS {NORMAL, WINTER, FALL, SUMMER, SPRING}

var seasons = []
var unused_seasons = []

func _ready():
	seasons = [SEASONS.NORMAL, SEASONS.WINTER, SEASONS.FALL, SEASONS.SUMMER, SEASONS.SPRING]
	unused_seasons = seasons

func start():
	if unused_seasons.size() <= 0:
		print_debug("experienced all seasons")
		unused_seasons = [SEASONS.NORMAL, SEASONS.WINTER, SEASONS.FALL, SEASONS.SUMMER, SEASONS.SPRING]
	new_season = randi() % unused_seasons.size()
	
	match unused_seasons[new_season]:
		SEASONS.NORMAL:
			print_debug("normal")
		SEASONS.WINTER:
			print_debug("winter")
		SEASONS.SUMMER:
			print_debug("summer")
		SEASONS.SPRING:
			print_debug("spring")
		SEASONS.FALL:
			print_debug("fall")
			
	if unused_seasons.size() > 0:
		unused_seasons.remove(new_season)

func _on_CycleController_time(cycle_state):
	if cycle_state == Global.Cycle.DAWN:
		start()

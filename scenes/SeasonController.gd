extends Node2D

var new_season = 0

onready var tilemap = get_parent().get_node("TileMap")
onready var rain_tile = get_parent().get_node("RainTile")
onready var rain_splash_tile = get_parent().get_node("RainSplashTile")
onready var snow_bottom_tile = get_parent().get_node("SnowBottomTile")
onready var snow_top_tile = get_parent().get_node("SnowTopTile")
onready var leaves = get_parent().get_node("LeafController")

onready var grass_tileset = preload("res://sprites/grass_tileset5.png")
onready var snow_tileset = preload("res://sprites/snow_grass.png")

enum SEASONS {NORMAL, WINTER, FALL, SUMMER, SPRING}

var seasons = []
var unused_seasons = []

func _ready():
	seasons = [SEASONS.NORMAL, SEASONS.WINTER, SEASONS.FALL, SEASONS.SUMMER, SEASONS.SPRING]
	unused_seasons = seasons
	
	tilemap.tile_set.tile_set_texture(1, grass_tileset)
	rain_splash_tile.visible = false
	rain_tile.visible = false
	snow_top_tile.visible = false
	snow_bottom_tile.visible = false
	leaves.visible = false
	
	start()

func start():
	#reset seasons
	rain_splash_tile.visible = false
	rain_tile.visible = false
	snow_top_tile.visible = false
	snow_bottom_tile.visible = false
	leaves.visible = false
	
	if unused_seasons.size() <= 0:
		print_debug("experienced all seasons")
		unused_seasons = [SEASONS.NORMAL, SEASONS.WINTER, SEASONS.FALL, SEASONS.SUMMER, SEASONS.SPRING]
	new_season = randi() % unused_seasons.size()
	
	match unused_seasons[new_season]:
		SEASONS.NORMAL:
			print_debug("normal")
			tilemap.tile_set.tile_set_texture(1, grass_tileset)
		SEASONS.WINTER:
			print_debug("winter")
			snow_top_tile.visible = true
			snow_bottom_tile.visible = true
			tilemap.tile_set.tile_set_texture(1, snow_tileset)
		SEASONS.SUMMER:
			print_debug("summer")
			rain_splash_tile.visible = true
			rain_tile.visible = true
			tilemap.tile_set.tile_set_texture(1, grass_tileset)
		SEASONS.SPRING:
			print_debug("spring")
			tilemap.tile_set.tile_set_texture(1, grass_tileset)
		SEASONS.FALL:
			print_debug("fall")
			leaves.visible = true
			tilemap.tile_set.tile_set_texture(1, grass_tileset)
			
	if unused_seasons.size() > 0:
		unused_seasons.remove(new_season)

func _on_CycleController_time(cycle_state):
	if cycle_state == Global.Cycle.DAWN:
		start()

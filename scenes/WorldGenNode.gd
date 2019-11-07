extends Node2D

enum P {L, U, R, D}

var is_item_node : bool = false

var grass_scene = preload("../scenes/Grass.tscn")

export(Array) var paths = [0,1,2,3]
export(bool) var left = false
export(bool) var up = false
export(bool) var right = false
export(bool) var down = false

########generate a random inherited node
func _ready():
	#get everything in the folder and pick a random one
	var path = filename.trim_suffix(".tscn")
	var nodes = list_files_in_directory(path)
	var _scene_num = randi() % nodes.size() + 1
	var _s = load(path + "/" + str(_scene_num) + ".tscn")
	if _s != null:
		var inst = _s.instance()
	#	for i in inst.get_children():
	#		if i.name == "ItemSpawner":
	#			inst.is_item_node = true
		inst.global_position = global_position
		for i in inst.get_node("TileMap").get_used_cells():
			#spawn grass
			if inst.get_node("TileMap").get_cell(i.x, i.y-1) == TileMap.INVALID_CELL and i.y > 0 and inst.get_node("TileMap").get_cell_autotile_coord(i.x, i.y) == Vector2(0, 1):
				if randi() % 5 == 0:
					var _grass = grass_scene.instance()
					_grass.global_position = Vector2((i.x*16)+global_position.x, ((i.y-1)*16)+global_position.y)
					get_parent().add_child(_grass)
			#set tilemap to global tilemap
			get_parent().get_node("TileMap").set_cell(i.x+(global_position.x/16), i.y+(global_position.y/16), 1)
		get_parent().add_child(inst)
		inst.remove_child(inst.get_node("TileMap"))

	queue_free()
	
##########generate base nodes
#func _ready():
#	for i in $TileMap.get_used_cells():
#		get_parent().get_node("TileMap").set_cell(i.x+(global_position.x/16), i.y+(global_position.y/16), 1)
#	get_parent().get_node("TileMap").update_bitmask_region()
#	remove_child($TileMap)
		
func list_files_in_directory(path):
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin()

    while true:
        var file = dir.get_next()
        if file == "":
            break
        elif not file.begins_with("."):
            files.append(file)

    dir.list_dir_end()

    return files
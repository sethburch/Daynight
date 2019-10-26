extends Node2D

enum P {L, U, R, D}

var is_item_node : bool = false

export(Array) var paths = [0,1,2,3]
export(bool) var left = false
export(bool) var up = false
export(bool) var right = false
export(bool) var down = false

########generate a random inherited node
func _ready():
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
			get_parent().get_node("TileMap").set_cell(i.x+(global_position.x/16), i.y+(global_position.y/16), 0)
		
		get_parent().add_child(inst)
		inst.remove_child(inst.get_node("TileMap"))

	queue_free()
	
##########generate base nodes
#func _ready():
#	for i in $TileMap.get_used_cells():
#		get_parent().get_node("TileMap").set_cell(i.x+(global_position.x/16), i.y+(global_position.y/16), 0)
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
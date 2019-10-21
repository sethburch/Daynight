extends Node2D

enum P {L, U, R, D}


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
	var inst = _s.instance()
	inst.global_position = global_position
	inst.modulate = modulate
	get_parent().add_child(inst)
	queue_free()
	
##########generate base nodes
#func _ready():
#	pass
		
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
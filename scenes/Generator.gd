extends Node2D

enum P {L, U, R, D}

var world_nodes = [
	preload("res://world_gen_nodes/LD.tscn"),
	preload("res://world_gen_nodes/LR.tscn"),
	preload("res://world_gen_nodes/LRD.tscn"),
	preload("res://world_gen_nodes/LU.tscn"),
	preload("res://world_gen_nodes/LUR.tscn"),
	preload("res://world_gen_nodes/LURD.tscn"),
	preload("res://world_gen_nodes/RD.tscn"),
	preload("res://world_gen_nodes/UD.tscn"),
	preload("res://world_gen_nodes/UR.tscn"),
	preload("res://world_gen_nodes/URD.tscn"),
	preload("res://world_gen_nodes/L.tscn"),
	preload("res://world_gen_nodes/U.tscn"),
	preload("res://world_gen_nodes/R.tscn"),
	preload("res://world_gen_nodes/D.tscn")
]

var start_node = preload("res://world_gen_nodes/StartNode.tscn")
var wall_node = preload("res://world_gen_nodes/Wall.tscn")

var current_nodes_array : Array = []
var main_path_array : Array = []

var exclude_paths : Array = []
var adjacent_connections : Array = []

var current_node = null
var previous_node = null
var current_coords = null
var next_node = null

var current_col = 0
var current_row = 0

var node_height = 160
var node_width = 160
export(int) var height = 2
export(int) var width = 100

var map = null

func _ready():
	randomize()
	#create map array
	map = create_2d_array(width, height, null)
	
	#chooses random starting height for start node
	#current_row = randi() % height
	
	current_node = Vector2(current_col, current_row)
	current_coords = Vector2(current_col*node_height, current_row*node_width)

	#place start node
	var sn = start_node.instance()
	sn.global_position = current_coords
	add_child(sn)
	
	#add start node to map
	previous_node = current_node
	map[current_col][current_row] = sn
	
	#start node always goes right
	var main_path_dir = 2
	
	main_path_array.append(current_node)
			
	#create main path
	while(current_col < width):
		current_node = Vector2(current_col, current_row)
		current_coords = Vector2(current_col*node_height, current_row*node_width)
		
		#var previous_node = current_node
				
		var prev_main_path_dir = main_path_dir
		var exclude_path_dir = -1
		var include_path_dir = -1

		exclude_paths.clear()

		#choose next direction of the main path
		#dont go out of bounds
		if current_col == 0: #if we're at the starting node, go right
			main_path_dir = 2
		elif current_row == 0: #if we're at the top
			var _dir = [2, 3] # go right or down
			main_path_dir = _dir[randi() % _dir.size()]
			#always go up
			include_path_dir = 1
		elif current_row == height-1: #if we're at the bottom
			var _dir = [1, 2] #go up or right
			main_path_dir = _dir[randi() % _dir.size()]
			exclude_paths.append(3)
		#else just pick a non-left direction
		else:
			main_path_dir = randi() % 3 + 1
			
		#increment row or column based on main_path_dir
		match main_path_dir:
			1:
				#prevents nodes from overlapping
				if prev_main_path_dir == 3:
					current_col+=1
					main_path_dir = 2
				else:
					current_row-=1
			2:
				current_col+=1
			3:
				#prevents nodes from overlapping
				if prev_main_path_dir == 1:
					current_col+=1
					main_path_dir = 2
				else:
					current_row+=1
			
		match prev_main_path_dir:
			0:
				prev_main_path_dir = 2
			1:
				prev_main_path_dir = 3
			2:
				prev_main_path_dir = 0
			3:
				prev_main_path_dir = 1
			
			
		#check for adjacent connections
		adjacent_connections.clear()
		if current_node.x-1 > -1 and map[current_node.y][current_node.x-1] != null:
			for i in map[current_node.y][current_node.x-1].paths:
				if i == 2:
					adjacent_connections.append(0)
			if !adjacent_connections.has(0):
				exclude_paths.append(0)
		if current_node.y-1 > -1 and map[current_node.y-1][current_node.x] != null:
			for j in map[current_node.y-1][current_node.x].paths:
				if j == 3:
					adjacent_connections.append(1)
			if !adjacent_connections.has(1):
				exclude_paths.append(1)
		if current_node.x+1 < width-1 and map[current_node.y][current_node.x+1] != null:
			for k in [current_node.y][current_node.x+1].paths:
				if k == 0:
					adjacent_connections.append(2)
			if !adjacent_connections.has(2):
				exclude_paths.append(2)
		if current_node.y+1 < height-1 and map[current_node.y+1][current_node.x] != null:
			for l in map[current_node.y+1][current_node.x].paths:
				if l == 1:
					adjacent_connections.append(3)
			if !adjacent_connections.has(3):
				exclude_paths.append(3)
			
		#adds the next node if it matches the prev_main_path and main_path
		for node in world_nodes:
			var _cur_node = node.instance()
			var has_main_path = false
			var has_prev_main_path = false
			var has_excluded_path = false
			var has_included_path = false
			var has_all_adjacent_connections = 0
			if adjacent_connections != null:
				has_all_adjacent_connections = adjacent_connections.size()
			# make sure node has main path
			for i in _cur_node.paths:
				if i == main_path_dir:
					has_main_path = true
					break
			# make sure node connects to previous node
			for j in _cur_node.paths:
				if j == prev_main_path_dir:
					has_prev_main_path = true
					break
			# make sure node doesnt go out of bounds
#			for k in _cur_node.paths:
#				if k == exclude_path_dir:
#					has_excluded_path = true
#					break
			for k in _cur_node.paths:
				for ep in exclude_paths:
					if k == ep:
						has_excluded_path = true
						break
			# make sure nodes on the top row are open at the top
			for l in _cur_node.paths:
				if l == include_path_dir:
					has_included_path = true
			if include_path_dir == -1:
				has_included_path = true
			# make sure we are connected to all adjacent nodes
			if has_all_adjacent_connections > 0:
				for n in _cur_node.paths:
					for m in adjacent_connections:
						if n == m:
							has_all_adjacent_connections -= 1

			#check all conditions and add to an array of potential options
			var adj_con = true
			if adjacent_connections != null:
				adj_con =  has_all_adjacent_connections <= 0
			if has_main_path and has_prev_main_path and !has_excluded_path and has_included_path and adj_con:
				current_nodes_array.append(_cur_node)

		#pick a random one from the options
		next_node = current_nodes_array[randi() % current_nodes_array.size()]
		next_node.global_position = current_coords
		add_child(next_node)
		current_nodes_array.clear()
		
		#update map
		map[current_node.y][current_node.x] = next_node
		main_path_array.append(current_node)
		
	#add branching paths
	for i in main_path_array:
		var cur_main_path = map[i.y][i.x]
		
		for j in cur_main_path.paths:
			var adj_dir = 0
			if j == 0 and i.x-1 != -1 and map[i.y][i.x-1] == null:
				adj_dir = 2
				create_branch(i.x-1, i.y, adj_dir)
			if j == 1 and i.y-1 != -1 and map[i.y-1][i.x] == null:
				adj_dir = 3
				create_branch(i.x, i.y-1, adj_dir)
			if j == 2 and i.x+1 != width and map[i.y][i.x+1] == null:
				adj_dir = 0
				create_branch(i.x+1, i.y, adj_dir)
			if j == 3 and i.y+1 != height and map[i.y+1][i.x] == null:
				adj_dir = 1
				create_branch(i.x, i.y+1, adj_dir)
				
	#finally, fill in all empty nodes with walls
	for i in map.size():
		for j in map[i].size():
			if map[i][j] == null:
				var wn = wall_node.instance()
				wn.global_position = Vector2((j)*node_height, (i)*node_width)
				add_child(wn)
				map[i][j] = wn

func create_branch(x, y, dir):
	exclude_paths.clear()
	adjacent_connections.clear()
	var include_path = -1
	
	#check for adjacent connections
	if x-1 > -1 and map[y][x-1] != null:
		for i in map[y][x-1].paths:
			if i == 2:
				adjacent_connections.append(0)
		if !adjacent_connections.has(0):
			exclude_paths.append(0)
	if y-1 > -1 and map[y-1][x] != null:
		for j in map[y-1][x].paths:
			if j == 3:
				adjacent_connections.append(1)
		if !adjacent_connections.has(1):
			exclude_paths.append(1)
	if x+1 < width:
		if map[y][x+1] != null:
			for k in map[y][x+1].paths:
				if k == 0:
					adjacent_connections.append(2)
			if !adjacent_connections.has(2):
				exclude_paths.append(2)
	if y+1 < height:
		if map[y+1][x] != null:
			for l in map[y+1][x].paths:
				if l == 1:
					adjacent_connections.append(3)
			if !adjacent_connections.has(3):
				exclude_paths.append(3)
	
	
	if x == 0:
		exclude_paths.append(0)
		exclude_paths.append(1)
	if x == width-1:
		exclude_paths.append(2)
	if y == 0:
		#exclude_paths.append(1)
		include_path = 1
	if y == height-1:
		exclude_paths.append(3)
	
	for node in world_nodes:
		var _cur_node = node.instance()
		var has_excluded_path = false
		var has_included_path = false
		var has_adj_dir = false
		var has_all_adjacent_connections = 0
		if adjacent_connections != null:
			has_all_adjacent_connections = adjacent_connections.size()
		for k in _cur_node.paths:
			if k == dir:
				has_adj_dir = true
			for ep in exclude_paths:
				if k == ep:
					has_excluded_path = true
					break
			#make sure it is open at the top
			if include_path == -1:
				has_included_path = true
			elif k == include_path:
				has_included_path = true
			# make sure we are connected to all adjacent nodes
			if has_all_adjacent_connections > 0:
				for m in adjacent_connections:
					if k == m:
						has_all_adjacent_connections -= 1
		var adj_con = true
		if adjacent_connections != null:
			adj_con =  has_all_adjacent_connections <= 0
		if has_adj_dir and !has_excluded_path and adj_con and has_included_path:
			current_nodes_array.append(_cur_node)
			
	if current_nodes_array.size() > 0: # later on can remove in favor of 1 entrance rooms (these are exclusive to branching paths)
		next_node = current_nodes_array[randi() % current_nodes_array.size()]
		next_node.global_position = Vector2((x)*node_height, (y)*node_width)
		#next_node.modulate = Color(1, 0, 0)
		add_child(next_node)
		map[y][x] = next_node
	current_nodes_array.clear()
	
	#create branch off of this branch
	for j in next_node.paths:
		var adj_dir = 0
		if j == 0 and x-1 != -1 and map[y][x-1] == null:
			adj_dir = 2
			create_branch(x-1, y, adj_dir)
		if j == 1 and y-1 != -1 and map[y-1][x] == null:
			adj_dir = 3
			create_branch(x, y-1, adj_dir)
		if j == 2 and x+1 != width and map[y][x+1] == null:
			adj_dir = 0
			create_branch(x+1, y, adj_dir)
		if j == 3 and y+1 != height and map[y+1][x] == null:
			adj_dir = 1
			create_branch(x, y+1, adj_dir)

func create_2d_array(width, height, value):
    var a = []
    for y in range(height):
        a.append([])
        a[y].resize(width)
        for x in range(width):
            a[y][x] = value
    return a
	
#func _process(delta):
#	if Input.is_action_just_pressed("move_up"):
#		$Camera2D.zoom += Vector2(0.5, 0.5)
#	if Input.is_action_just_pressed("move_down"):
#		$Camera2D.zoom -= Vector2(0.5, 0.5)
#	if Input.is_action_pressed("move_right"):
#		$Camera2D.offset.x += 20
#	if Input.is_action_pressed("move_left"):
#		$Camera2D.offset.x -= 20
#	if Input.is_action_just_pressed("reset"):
#		get_tree().reload_current_scene()
#	if Input.is_action_just_pressed("jump"):
#		print_debug(map)
#		print_debug(main_path_array)

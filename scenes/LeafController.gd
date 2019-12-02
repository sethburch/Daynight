extends Node2D

onready var player = get_parent().get_node("Player")

var right_set = false
var left_set = true


func _process(delta):
	if player.global_position.x > $CenterLeaf.global_position.x+300:
		#if it's not already on the right
		if !right_set:
			#set it to the right
			$RightLeaf.global_position.x+=2000
			$CenterLeaf.global_position.x+=2000
			
			right_set = true
			left_set = false
	if player.global_position.x < $CenterLeaf.global_position.x-300:
		if !left_set:
			$RightLeaf.global_position.x-=2000
			$CenterLeaf.global_position.x-=2000
			
			left_set = true
			right_set = false
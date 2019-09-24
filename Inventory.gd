#Inventory.gd
extends Node2D

var current_tome = null

var inventory = Array()
var inventory_index = 0

func _ready():
	pass

func _on_Inventory_area_entered(area):
	if area is Tome:
		#adds the tome we just collided with to our inventory
		inventory.append(area)
		print_debug("You picked up: " + area.tome_name)
		
		#removes the tome from the world
		get_node("..").get_parent().remove_child(area)
		
func _process(delta):
	#cycles through inventory slots
	if Input.is_action_just_pressed("inventory_right"):
		inventory_index+=1
		if inventory_index > inventory.size()-1:
			inventory_index = 0
		
	#if we have picked up at least one tome, set that to our current tome
	if inventory.size() != 0:
		current_tome = inventory[inventory_index]
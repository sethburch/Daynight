#Inventory.gd
extends Node2D

var current_tome = null

var inventory = Array()
var inventory_index = 0

func _ready():
	pass

func _on_Inventory_area_entered(area):
	if area.is_in_group("Tome"):
		#adds the tome we just collided with to our inventory
		inventory.append(area)
		get_node("..").get_node("GUILayer/GUI").set_alert_text("You picked up: " + area.tome_name)
		print_debug("You picked up: " + area.tome_name)
		
		#removes the tome from the world
		get_node("..").get_parent().remove_child(area)
		
		
	#when we first pick up a tome
	if inventory.size() == 1:
		current_tome = inventory[inventory_index]
		get_node("..").get_node("GUILayer/GUI").set_aura_visible(true)
		#set the tome texture and aura color on our GUI
		get_node("..").get_node("GUILayer/GUI").set_current_tome(current_tome.this_tome_sprite, current_tome.this_tome_color)
		#show our current tome text
		get_node("..").get_node("GUILayer/GUI").set_item_text(current_tome.tome_name)
		
func _process(delta):
	#cycles through inventory slots
	if Input.is_action_just_pressed("inventory_right"):
		inventory_index+=1
		if inventory_index > inventory.size()-1:
			inventory_index = 0
		if inventory.size() != 0:
			current_tome = inventory[inventory_index]
			get_node("..").get_node("GUILayer/GUI").set_aura_visible(true)
			#set the tome texture and aura color on our GUI
			get_node("..").get_node("GUILayer/GUI").set_current_tome(current_tome.this_tome_sprite, current_tome.this_tome_color)
			#show our current tome text
			get_node("..").get_node("GUILayer/GUI").set_item_text(current_tome.tome_name)
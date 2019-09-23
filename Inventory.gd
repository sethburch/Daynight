#Inventory.gd
extends Node2D

var current_tome = null

func _ready():
	pass

func _on_Inventory_area_entered(area):
	if area is Tome:
		current_tome = area

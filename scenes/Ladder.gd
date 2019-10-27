extends Area2D

export(int) var length = 16

func _ready():
	$Sprites.visible = true
	length = scale.y * length
	$CollisionShape2D.shape.extents.y = length/2
	$Sprites/Vine.region_rect = Rect2(0, 0, 16, length)
	scale.y = 1
	$Sprites/Top.position.y -= (length/2)-8
	$Sprites/Bottom.position.y += (length/2)-8
	position.y+= length/2

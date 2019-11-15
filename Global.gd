extends Node

# don't forget to use stretch mode 'viewport' and aspect 'ignore'
onready var viewport = get_viewport()
var scale = 1
var window_size = OS.get_window_size()

var DayNight
var Moon

func _ready():
	get_tree().connect("screen_resized", self, "_screen_resized")

func _screen_resized():
	window_size = OS.get_window_size()

#func _screen_resized():
#	window_size = OS.get_window_size()
#
#	# see how big the window is compared to the viewport size
#	# floor it so we only get round numbers (0, 1, 2, 3 ...)
#	var scale_x = floor(window_size.x / viewport.size.x)
#	var scale_y = floor(window_size.y / viewport.size.y)
#
#	# use the smaller scale with 1x minimum scale
#	scale = max(1, min(scale_x, scale_y))
#
#	# find the coordinate we will use to center the viewport inside the window
#	var diff = window_size - (viewport.size * scale)
#	var diffhalf = (diff * 0.5).floor()
#
#	# attach the viewport to the rect we calculated
#	viewport.set_attach_to_screen_rect(Rect2(diffhalf, viewport.size * scale))
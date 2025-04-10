extends Camera2D

@export var target_resolution := Vector2(2560, 1440)  # The resolution you're designing for
@export var min_zoom := 3.55  # Minimum zoom level
@export var max_zoom := 50  # Maximum zoom level

func _ready():
	get_tree().root.size_changed.connect(adjust_zoom)
	adjust_zoom()

func adjust_zoom():
	var window_size = get_viewport_rect().size
	var scale_factor = min(window_size.x / target_resolution.x, window_size.y / target_resolution.y)
	
	# Clamp the zoom between min_zoom and max_zoom
	zoom = Vector2.ONE * clamp(scale_factor, min_zoom, max_zoom)

extends Line2D

var max_points = 100
var line_width = 2
var line_color = Color(0, 0, 1)
var line_interval = 0.05
var time_since_last_point = 0

func _ready():
	width = line_width
	default_color = line_color
	set_process(true)

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	time_since_last_point += delta

	if time_since_last_point >= line_interval:
		_add_point(mouse_position)
		time_since_last_point = 0

	_update_points(delta)
	_remove_invisible_points()

func _add_point(position):
	add_point(position)
	if get_point_count() > max_points:
		remove_point(0)

func _update_points(delta):
	for i in range(get_point_count()):
		var point = get_point_position(i)
		point.y += 200 * delta
		set_point_position(i, point)

func _remove_invisible_points():
	var visible_points = []
	for i in range(get_point_count()):
		if get_point_position(i).y < get_viewport().get_size().y:
			visible_points.append(get_point_position(i))

	clear_points()
	for point in visible_points:
		add_point(point)

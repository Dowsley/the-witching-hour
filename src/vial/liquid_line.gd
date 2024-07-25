extends Line2D

class_name LiquidLine


export var max_points := 100
export var line_interval := 0.01
export var gravity := 1000

var time_since_last_point := 0.0
var collision_shapes := []


func _process(delta: float) -> void:
	time_since_last_point += delta
	if time_since_last_point >= line_interval:
		_update_points(delta)
		time_since_last_point = 0
	_remove_invisible_points()
	
	if points.size() == 0:
		queue_free()


func _add_point(position: Vector2) -> void:
	add_point(position)
	if get_point_count() > max_points:
		remove_point(0)


func _update_points(delta: float) -> void:
	for i in range(get_point_count()):
		var point := get_point_position(i)
		point.y += gravity * delta
		set_point_position(i, point)


func _remove_invisible_points() -> void:
	var visible_points := []
	for i in range(get_point_count()):
		var point := get_point_position(i)
		var global_point := to_global(point)
		if point.y < get_viewport().get_size().y and !_collides_with_world(global_point):
			visible_points.append(point)
		elif _collides_with_world(global_point):
			return
	
	clear_points()
	for point in visible_points:
		add_point(point)


func _collides_with_world(global_point: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var result := space_state.intersect_point(global_point, 1, [], 2147483647, true, true)
	return result.size() > 0

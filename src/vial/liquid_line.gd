extends Line2D
class_name LiquidLine


@export var line_interval := 0.01
@export var gravity := 1000
@export var initial_velocity := Vector2(200, 0) # Initial horizontal velocity
@export var damping := 0.9                      # Damping factor to reduce horizontal velocity

@onready var timer := $Timer

var destruction_sequence_started := false
var time_since_last_point := 0.0
var velocities := [] # Store velocities of each point

var origin_vial: Vial
var liquid_type: String


func _process(delta: float) -> void:
	time_since_last_point += delta
	if time_since_last_point >= line_interval:
		_update_points(delta)
		time_since_last_point = 0
	_remove_invalid_points()
	
	if points.size() == 0:
		if not destruction_sequence_started:
			timer.start()
			destruction_sequence_started = true


func _add_point(pos: Vector2, inverted := false) -> void:
	add_point(pos)
	# Calculate the initial velocity in global coordinates
	var global_velocity = origin_vial.global_transform.basis_xform(initial_velocity)
	if inverted:
		global_velocity = -global_velocity
	velocities.append(global_velocity)


func _update_points(delta: float) -> void:
	for i in range(get_point_count()):
		var point := get_point_position(i)
		# Update position based on velocity
		var velocity = velocities[i]
		point += velocity * delta
		velocity.x *= damping # Apply damping to horizontal velocity
		velocity.y += gravity * delta # Apply gravity to the vertical velocity
		# Update the point and velocity
		set_point_position(i, point)
		velocities[i] = velocity


func _remove_invalid_points() -> void:
	var visible_points := []
	var visible_velocities := []
	for i in range(get_point_count()):
		var point := get_point_position(i)
		var global_point := to_global(point)
		var collided_object = _collides_with_world(global_point)
		if not collided_object:
			visible_points.append(point)
			visible_velocities.append(velocities[i])
		elif collided_object.is_in_group("vial"):
			collided_object.add_liquid(liquid_type, Globals.units_per_liquid_line_point)
	
	clear_points()
	velocities = visible_velocities
	for point in visible_points:
		add_point(point)


func _collides_with_world(global_point: Vector2) -> Object:
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = global_point
	query.collide_with_areas = false
	query.collide_with_bodies = true
	var result := space_state.intersect_point(query)

	var collider: Object = null
	for r in result:
		collider = r.collider
		if is_valid_vial_collider(collider): # Can't be itself if it's not pouring.
			break
	return collider if collider != origin_vial else null


func is_valid_vial_collider(collider: Object) -> bool:
	if not collider.is_in_group("vial"):
		return false
	if collider == origin_vial:
		return false
	if collider.get_percent_filled() >= 1.0:
		return false
	return true


func _on_Timer_timeout() -> void:
	queue_free()

extends RigidBody2D
class_name Draggable

var is_dragging := false
var previous_mouse_position := Vector2.ZERO
var velocity := Vector2.ZERO


func _ready() -> void:
	angular_damp = INF
	gravity_scale = Globals.gravity_scale
	linear_damp = Globals.air_resistance


func _input(event: InputEvent) -> void:
	if not is_dragging:
		return

	if event is InputEventMouseButton:
		if MouseInputUtil.is_left_mouse_button_released(event):
			release_drag(event)
		if (MouseInputUtil.is_wheel_up_mouse_button_pressed(event)):
			rotation_degrees += 3
		elif (MouseInputUtil.is_wheel_down_mouse_button_pressed(event)):
			rotation_degrees -= 3

	elif event is InputEventMouseMotion and is_dragging:
		drag_object(event)



# This stops the object from rotating
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	state.angular_velocity = 0
	var new_transform = Transform2D(0, state.transform.origin)
	state.transform = new_transform


func release_drag(mouse_button_event: InputEventMouseButton) -> void:
	previous_mouse_position = Vector2.ZERO
	is_dragging = false
	mode = MODE_RIGID
	rotation_degrees = 0

	var local_impulse_point = to_local(mouse_button_event.position).limit_length(5)
	var is_upside_down = abs(sin(rotation)) > 0.707 # sin(45°) to check for upside down
	if is_upside_down:
		local_impulse_point.x = -local_impulse_point.x

	var impulse = velocity * 20
	apply_impulse(local_impulse_point, impulse.limit_length(1000))
	


func drag_object(mouse_motion_event: InputEventMouseMotion) -> void:
	var previous_position = position
	position += mouse_motion_event.position - previous_mouse_position
	velocity = position - previous_position
	previous_mouse_position = mouse_motion_event.position


func _on_DraggableArea_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if MouseInputUtil.is_left_mouse_button_pressed(event):
			get_viewport().set_input_as_handled()
			previous_mouse_position = event.position
			is_dragging = true
			mode = MODE_STATIC

extends Node


func is_left_mouse_button_pressed(event_mouse_button: InputEventMouseButton) -> bool:
	return event_mouse_button.pressed and event_mouse_button.button_index == MOUSE_BUTTON_LEFT


func is_right_mouse_button_pressed(event_mouse_button: InputEventMouseButton) -> bool:
	return event_mouse_button.pressed and event_mouse_button.button_index == MOUSE_BUTTON_RIGHT


func is_middle_mouse_button_pressed(event_mouse_button: InputEventMouseButton) -> bool:
	return event_mouse_button.pressed and event_mouse_button.button_index == MOUSE_BUTTON_MIDDLE


func is_left_mouse_button_released(event_mouse_button: InputEventMouseButton) -> bool:
	return not event_mouse_button.pressed and event_mouse_button.button_index == MOUSE_BUTTON_LEFT


func is_right_mouse_button_released(event_mouse_button: InputEventMouseButton) -> bool:
	return not event_mouse_button.pressed and event_mouse_button.button_index == MOUSE_BUTTON_RIGHT


func is_middle_mouse_button_released(event_mouse_button: InputEventMouseButton) -> bool:
	return not event_mouse_button.pressed and event_mouse_button.button_index == MOUSE_BUTTON_MIDDLE


func is_wheel_up_mouse_button_pressed(event_mouse_button: InputEventMouseButton) -> bool:
	return not event_mouse_button.pressed and event_mouse_button.button_index == MOUSE_BUTTON_WHEEL_UP


func is_wheel_down_mouse_button_pressed(event_mouse_button: InputEventMouseButton) -> bool:
	return not event_mouse_button.pressed and event_mouse_button.button_index == MOUSE_BUTTON_WHEEL_DOWN

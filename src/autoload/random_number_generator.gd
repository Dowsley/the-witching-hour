extends Node


var rng := RandomNumberGenerator.new()


func _ready():
	rng.randomize()


func get_random_int() -> int:
	return rng.randi()


func get_random_int_range(p_min: int, p_max: int) -> int:
	return rng.randi_range(p_min, p_max)


func get_random_float() -> float:
	return rng.randf()


func get_random_float_range(p_min: float, p_max: float) -> float:
	return rng.randf_range(p_min, p_max)

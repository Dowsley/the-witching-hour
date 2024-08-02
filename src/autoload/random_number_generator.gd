extends Node


var rng := RandomNumberGenerator.new()


func _ready():
	rng.randomize()


func get_random_int() -> int:
	return rng.randi()


func get_random_int_range(min: int, max: int) -> int:
	return rng.randi_range(min, max)


func get_random_float() -> float:
	return rng.randf()


func get_random_float_range(min: float, max: float) -> float:
	return rng.randf_range(min, max)

# Liquids need to be spawned in the root tree for absolute coordinates.

extends Node2D


func add_liquid_line(liquid_line: LiquidLine) -> void:
	add_child(liquid_line)

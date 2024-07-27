# Liquids need to be spawned in the root tree for absolute coordinates.

extends Node2D


func spawn_liquid_line(vial: Vial) -> LiquidLine:
	var liquid_line := preload("res://src/vial/liquid_line.tscn").instantiate()
	
	liquid_line.origin_vial = vial
	add_child(liquid_line)
	
	return liquid_line

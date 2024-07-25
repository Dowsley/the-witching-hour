extends Draggable
class_name Vial


const spill_threshold := 45.0
onready var liquid_spill_pos: Vector2 = $LiquidSpillPos.position

var is_pouring := false
var liquid_line: LiquidLine = null


func _process(_delta: float) -> void:
	is_pouring = abs(rotation_degrees) > spill_threshold

	if is_pouring:
		if liquid_line == null:
			liquid_line = preload("res://src/vial/liquid_line.tscn").instance()
			LiquidManager.add_liquid_line(liquid_line)
		var global_spill_pos = global_transform.xform(liquid_spill_pos)
		liquid_line._add_point(global_spill_pos)
	else:
		liquid_line = null

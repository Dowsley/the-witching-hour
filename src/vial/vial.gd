extends Draggable
class_name Vial


const spill_threshold := 45.0
const spill_threshold_margin := 30.0
onready var liquid_spill_pos: Vector2 = $LiquidSpillPos.position

export var percent_filled := 0.6

var is_pouring := false
var liquid_line: LiquidLine = null


func _ready() -> void:
	$Sprite/Liquid.material.set("shader_param/Fill", percent_filled)


func _process(_delta: float) -> void:
	$Sprite/Liquid.material.set("shader_param/Fill", percent_filled)
	
	var pos_limit := spill_threshold + spill_threshold_margin
	var neg_limit := -spill_threshold - spill_threshold_margin
	if rotation_degrees > pos_limit:
		rotation_degrees = pos_limit
	elif rotation_degrees < neg_limit:
		rotation_degrees = neg_limit
	
	is_pouring = abs(rotation_degrees) >= spill_threshold
	if is_pouring and percent_filled > 0.0:
		if liquid_line == null:
			liquid_line = preload("res://src/vial/liquid_line.tscn").instance()
			liquid_line.origin_vial = self
			LiquidManager.add_liquid_line(liquid_line)
		var global_spill_pos = global_transform.xform(liquid_spill_pos)
		liquid_line._add_point(global_spill_pos)
		percent_filled -= Globals.water_per_liquid_point
	else:
		liquid_line = null

extends Draggable
class_name Vial


@export var spill_threshold := 45.0
@export  var spill_threshold_margin := 30.0
@export var percent_filled := 0.6

@onready var liquid_spill_pos: Vector2 = $LiquidSpillPos.position
@onready var liquid_sprite := $Sprite2D/Liquid

var is_pouring := false
var liquid_line: LiquidLine = null


func _ready() -> void:
	set_percent_filled(percent_filled)


func _process(_delta: float) -> void:
	set_percent_filled(percent_filled)
	
	var pos_limit := spill_threshold + spill_threshold_margin
	var neg_limit := -spill_threshold - spill_threshold_margin
	if rotation_degrees > pos_limit:
		rotation_degrees = pos_limit
	elif rotation_degrees < neg_limit:
		rotation_degrees = neg_limit
	
	is_pouring = abs(rotation_degrees) >= spill_threshold
	if is_pouring and percent_filled > 0.0:
		if liquid_line == null:
			liquid_line = preload("res://src/vial/liquid_line.tscn").instantiate()
			liquid_line.origin_vial = self
			LiquidSpawner.add_liquid_line(liquid_line)
		var global_spill_pos = global_transform * (liquid_spill_pos)
		var inverted := rotation_degrees <= -spill_threshold
		liquid_line._add_point(global_spill_pos, inverted)
		percent_filled -= Globals.water_per_liquid_point
	else:
		liquid_line = null


func set_percent_filled(percent: float) -> void:
	liquid_sprite.material.set_shader_parameter("Fill", percent)
	

func _on_draggable_area_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	super._on_draggable_area_input_event(viewport, event, shape_idx)

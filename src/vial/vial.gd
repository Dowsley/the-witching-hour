extends Draggable
class_name Vial


@export var percent_filled: float = 60.0

@onready var liquid_spill_pos_left: Vector2 = $LiquidSpillPosLeft.position
@onready var liquid_spill_pos_right: Vector2 = $LiquidSpillPosRight.position
@onready var liquid_sprite := $Sprite2D/Liquid

var is_pouring := false
var liquid_line: LiquidLine = null
var liquid_spill_pos: Vector2


func _ready() -> void:
	set_percent_filled(percent_filled)


func _process(_delta: float) -> void:
	set_percent_filled(percent_filled)
	
	is_pouring = abs(rotation_degrees) >= spill_threshold
	if is_pouring and percent_filled > 0.0:
		liquid_spill_pos = liquid_spill_pos_right if is_tilted_to_the_right() else liquid_spill_pos_left
		if liquid_line == null:
			liquid_line = LiquidSpawner.spawn_liquid_line(self)
		var global_spill_pos := global_transform * (liquid_spill_pos)
		var inverted := rotation_degrees <= -spill_threshold
		liquid_line._add_point(global_spill_pos, inverted)
		percent_filled -= Globals.water_per_liquid_point
	else:
		liquid_line = null

func is_tilted_to_the_right() -> bool:
	return rotation_degrees > 0


func set_percent_filled(percent: float) -> void:
	liquid_sprite.material.set_shader_parameter("Fill", percent / 100)

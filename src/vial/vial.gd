extends Draggable
class_name Vial


@export var debug := false
@export var max_units_capacity := 1000
@export var filled_with := {
	"Gin": 500
}

@onready var liquid_spill_pos_left: Vector2 = $LiquidSpillPosLeft.position
@onready var liquid_spill_pos_right: Vector2 = $LiquidSpillPosRight.position
@onready var liquid_sprite := $Sprite2D/Liquid

var is_pouring := false
var liquid_line: LiquidLine = null
var liquid_spill_pos: Vector2


func _ready() -> void:
	draw_liquid()


func _process(_delta: float) -> void:
	draw_liquid()
	
	is_pouring = abs(rotation_degrees) >= spill_threshold
	if is_pouring and get_total_units() > 0.0:
		liquid_spill_pos = liquid_spill_pos_right if is_tilted_to_the_right() else liquid_spill_pos_left
		if liquid_line == null:
			liquid_line = LiquidSpawner.spawn_liquid_line(self)
		var global_spill_pos := global_transform * (liquid_spill_pos)
		var inverted := rotation_degrees <= -spill_threshold
		var chosen_liquid_type_name := choose_random_liquid_in_container()
		liquid_line._add_point(global_spill_pos, chosen_liquid_type_name, inverted)
		liquid_line.default_color = compute_liquid_color()
		remove_liquid(chosen_liquid_type_name, Globals.units_per_liquid_line_point)
	else:
		liquid_line = null


func get_total_units() -> int:
	var amount := 0
	for i in filled_with:
		amount += filled_with[i]
	return amount


func get_percent_filled() -> float: # 0.0 to 1.0
	return float(get_total_units()) / float(max_units_capacity)


func is_tilted_to_the_right() -> bool:
	return rotation_degrees > 0


func compute_liquid_color() -> Color:
	var total_units := get_total_units()
	if total_units == 0:
		return Color(0, 0, 0, 0)

	var weighted_color := Color(0, 0, 0, 0)
	for liquid_type in filled_with.keys():
		var liquid_amount: int = filled_with[liquid_type]
		var liquid_resource := LiquidTypeManager.get_liquid_type(liquid_type)
		var liquid_color := liquid_resource.color
		weighted_color.r += liquid_color.r * (liquid_amount / float(total_units))
		weighted_color.g += liquid_color.g * (liquid_amount / float(total_units))
		weighted_color.b += liquid_color.b * (liquid_amount / float(total_units))
		weighted_color.a += liquid_color.a * (liquid_amount / float(total_units))
	return weighted_color


func draw_liquid() -> void:
	liquid_sprite.material.set_shader_parameter("Color", compute_liquid_color())
	liquid_sprite.material.set_shader_parameter("Fill", get_percent_filled())


func choose_random_liquid_in_container() -> String:
	var total_units := get_total_units()
	if total_units == 0:
		return ""

	var rand_value := randi() % total_units
	var accumulated_weight := 0

	for liquid_type in filled_with.keys():
		accumulated_weight += filled_with[liquid_type]
		if rand_value < accumulated_weight:
			return liquid_type

	return filled_with.keys()[0]


func remove_liquid(type: String, amount: int) -> void:
	assert(filled_with.has(type), "Dictionary has no key with entry " + type)
	filled_with[type] -= amount
	if filled_with[type] <= 0:
		filled_with.erase(type)


func add_liquid(type: String, amount: int) -> void:
	if not filled_with.has(type):
		filled_with[type] = 0
	filled_with[type] += amount

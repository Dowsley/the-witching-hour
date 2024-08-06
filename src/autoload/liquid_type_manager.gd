extends Node


var liquid_type_map: Dictionary = {}


func _ready() -> void:
	load_liquid_types("res://data/definitions/liquids/")


func load_liquid_types(directory_path: StringName) -> void:
	var dir = DirAccess.open(directory_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				file_name = dir.get_next()
				continue
			if file_name.ends_with(".tres"):
				var file_path = directory_path + "/" + file_name
				var resource = ResourceLoader.load(file_path)
				if resource is LiquidTypeDefinition:
					liquid_type_map[resource.name] = resource
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		assert(false, "Failed to open directory: " + directory_path)


func get_liquid_type(liquid_name: StringName) -> LiquidTypeDefinition:
	return liquid_type_map[liquid_name]

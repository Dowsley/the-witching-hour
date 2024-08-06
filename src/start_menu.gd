extends Node2D

@export var main_game_scene: PackedScene

@onready var bg_sprite := $Bg
@onready var press_sprite := $Press
@onready var title_sprite := $Title

var time_elapsed := 0.0
const BLINK_INTERVAL := 0.7

func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventMouseButton) and event.pressed:
		get_tree().change_scene_to_packed(main_game_scene)


func _process(delta: float) -> void:
	time_elapsed += delta
	if time_elapsed >= BLINK_INTERVAL:
		press_sprite.visible = not press_sprite.visible
		time_elapsed = 0.0

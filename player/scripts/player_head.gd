class_name PlayerHead extends Node3D

const HEAD_ROTATION_MIN: int = -90
const HEAD_ROTATION_MAX: int = 90

var input_look_vector: Vector2 = Vector2()

@onready var player_character: PlayerCharacter = get_parent()

func _physics_process(_delta: float) -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if Input.is_action_pressed("player_mode_action"):
		return

	input_look_vector = PlayerUtils.get_look_vector()

	rotate_x(deg_to_rad( input_look_vector.y ))
	player_character.rotate_y(deg_to_rad( input_look_vector.x ))
	rotation_degrees.x = clamp(rotation_degrees.x, HEAD_ROTATION_MIN, HEAD_ROTATION_MAX)

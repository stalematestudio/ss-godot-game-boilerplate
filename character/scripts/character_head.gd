class_name CharacterHead extends Node3D

const HEAD_ROTATION_MIN: int = -90
const HEAD_ROTATION_MAX: int = 90

var input_look_vector: Vector2 = Vector2()

@onready var character: Character = get_parent()

func freelook() -> void:
	rotate_x(deg_to_rad( input_look_vector.y ))
	character.rotate_y(deg_to_rad( input_look_vector.x ))
	rotation_degrees.x = clamp(rotation_degrees.x, HEAD_ROTATION_MIN, HEAD_ROTATION_MAX)

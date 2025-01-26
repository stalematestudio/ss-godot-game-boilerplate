class_name CharacterHead extends Node3D

const HEAD_ROTATION_MIN: int = -90
const HEAD_ROTATION_MAX: int = 90

var input_look_vector: Vector2 = Vector2()

@onready var character: Character = get_parent()
@onready var character_spot_light_3D: CharacterSpotLight3D = $character_spot_light_3D
@onready var character_ray_cast_3D: CharacterRayCast3D = $character_ray_cast_3D
@onready var character_spring_arm_3D: CharacterSpringArm3D = $character_spring_arm_3D

func _ready() -> void:
	character_spring_arm_3D.interactor = character_ray_cast_3D

func freelook() -> void:
	rotate_x(deg_to_rad( input_look_vector.y ))
	character.rotate_y(deg_to_rad( input_look_vector.x ))
	rotation_degrees.x = clamp(rotation_degrees.x, HEAD_ROTATION_MIN, HEAD_ROTATION_MAX)

func save_data() -> Dictionary:
	return {
		"rotation_degrees": rotation_degrees,
		"character_spot_light_3D_on": character_spot_light_3D.on,
		"character_spring_arm_3D": character_spring_arm_3D.save_data()
	}

func load_data(data: Dictionary) -> void:
	rotation_degrees = Helpers.string_to_vector(data.rotation_degrees) if data.rotation_degrees is String else data.rotation_degrees
	character_spot_light_3D.on = data.character_spot_light_3D_on if data.has("character_spot_light_3D_on") else character_spot_light_3D.on
	character_spring_arm_3D.load_data(data.character_spring_arm_3D)

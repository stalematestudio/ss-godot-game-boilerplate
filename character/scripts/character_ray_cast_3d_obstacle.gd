class_name CharacterRayCast3DObstacle extends RayCast3D

@onready var character_instance: Character = get_parent()

@export var height: float = 0.0
@export_enum(
	"TOP_DOWN",
	"BOTTOM_UP",
) var checking_mode: String = "TOP_DOWN"

var distance: float:
	get:
		var get_global_transform_origin: Vector3 = get_global_transform().origin
		return get_global_transform_origin.distance_to(get_collision_point()) if is_colliding() else get_global_transform_origin.distance_to(get_global_transform_origin + target_position)

var offset: float:
	get:
		return position.y

var clearance: float:
	get:
		match checking_mode:
			"TOP_DOWN":
				return offset - distance
			"BOTTOM_UP":
				return offset + distance
			_:
				return height

var jump_strength: float:
	get:
		return 1.0

var can: bool:
	get:
		if not is_colliding():
			return false
		match checking_mode:
			"TOP_DOWN":
				return height > clearance
			"BOTTOM_UP":
				return height < clearance
			_:
				return false

var input_movement_vector: Vector2:
	get:
		return Vector2.ZERO
	set(input_movement_vector_in):
		position.x = input_movement_vector_in.x * 0.5
		position.z = input_movement_vector_in.y * 0.5

func _ready() -> void:
	add_exception(character_instance)

class_name BaseProp extends RigidBody3D

@export var interactive: bool = true
@export_enum(
	"GRAB",
	"PUSH",
	"DROP",
	"THROW",
	"PRESS",
) var primary_action: String
@export_enum(
	"GRAB",
	"PUSH",
	"DROP",
	"THROW",
	"PRESS",
) var secondary_action: String

func _ready() -> void:
	if is_inside_tree() and not is_in_group("game_objects_props"):
		add_to_group("game_objects_props", true)

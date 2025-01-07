class_name BaseProp extends RigidBody3D

@onready var outline_mesh_array: Array[Node] = find_children("outline_mesh")

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

func un_highlight_interactible() -> void:
	for outline_mesh in outline_mesh_array:
		outline_mesh.hide()

func highlight_interactible() -> void:
	for outline_mesh in outline_mesh_array:
		outline_mesh.show()

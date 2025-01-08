class_name BaseProp extends RigidBody3D

@export var interactive: bool = true

@onready var outline_mesh_array: Array[Node] = find_children("outline_mesh*")

var is_grabbed: bool = false

var primary_action: String:
	get:
		return "DROP" if is_grabbed else "GRAB"

var secondary_action: String:
	get:
		return "THROW" if is_grabbed else "PUSH"

func _ready() -> void:
	if is_inside_tree() and not is_in_group("game_objects_props"):
		add_to_group("game_objects_props", true)

func un_highlight_interactible() -> void:
	for outline_mesh in outline_mesh_array:
		outline_mesh.hide()

func highlight_interactible() -> void:
	for outline_mesh in outline_mesh_array:
		outline_mesh.show()

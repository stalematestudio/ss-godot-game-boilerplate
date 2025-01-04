class_name CardboardBox extends RigidBody3D

@export var interactive: bool = true
@export var primary_action: String = Constants.INTERACTION_GRAB
@export var secondary_action: String = Constants.INTERACTION_PUSH

func _ready() -> void:
	if is_inside_tree() and not is_in_group("game_save_objects"):
		add_to_group("game_objects_props", true)

class_name PlayArea extends Area3D

@onready var maps_manager: MapsManager = get_parent()

func _ready() -> void:
	if is_inside_tree() and not is_in_group("play_areas"):
		add_to_group("play_areas", true)
	for child in find_children("*", "StaticBody3D"):
		child.add_to_group("navigation_mesh_source_group")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if (body is Character) and (body.is_player_controlled):
		maps_manager.level_active = name

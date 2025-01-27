class_name DynamicNavigationRegion3D extends NavigationRegion3D

# @onready var play_area: PlayArea = get_parent()
# @onready var nav_mesh_group_name: String = "navigation_mesh_source_group_" + play_area.name

# @export var rebake_interval: float = 2.0
# var rebake_timer: float = 0

# func _ready() -> void:
# 	navigation_mesh.geometry_source_geometry_mode = NavigationMesh.SOURCE_GEOMETRY_GROUPS_EXPLICIT
# 	navigation_mesh.geometry_source_group_name = nav_mesh_group_name
# 	for child in play_area.find_children("*", "StaticBody3D"):
# 		child.add_to_group(nav_mesh_group_name)

# func _physics_process(delta: float) -> void:
# 	rebake_timer -= delta
# 	if rebake_timer > 0:
# 		return
# 	rebake_timer = rebake_interval
# 	if not is_baking():
# 		bake_navigation_mesh()

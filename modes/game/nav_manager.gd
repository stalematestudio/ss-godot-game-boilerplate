extends NavigationRegion3D

@export var navigation_mesh_re_bake_interval: float = 10
var navigation_mesh_re_bake_time: float = navigation_mesh_re_bake_interval

@onready var props_manager: PropsManager = 	Helpers.get_game_manager("props_manager")

func _ready() -> void:
	# bake_finished.connect(print_debug.bind("bake_finished ", get_navigation_map()))
	pass

func _process(delta: float) -> void:
	if is_baking():
		return
	navigation_mesh_re_bake_time -= delta
	if navigation_mesh_re_bake_time > 0:
		return
	navigation_mesh_re_bake_time = navigation_mesh_re_bake_interval
	var get_navigation_map_rid: RID = get_navigation_map()
	# print_debug("bake_navigation_mesh ", get_navigation_map_rid)
	for props_parent in props_manager.props_parents:
		for prop in props_parent.prop_list:
			var navigation_obstacle_3d: NavigationObstacle3D = prop.find_child("navigation_obstacle_3d", false)
			navigation_obstacle_3d.set_navigation_map(get_navigation_map_rid)
			# print_debug(prop, navigation_obstacle_3d.get_navigation_map())
	bake_navigation_mesh()
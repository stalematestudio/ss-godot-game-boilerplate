extends NavigationRegion3D

@export var navigation_mesh_re_bake_interval: float = 10
var navigation_mesh_re_bake_time: float = navigation_mesh_re_bake_interval

func _ready() -> void:
	bake_finished.connect(print_debug.bind("bake_finished"))

func _process(delta: float) -> void:
	navigation_mesh_re_bake_time -= delta
	if navigation_mesh_re_bake_time > 0:
		return
	navigation_mesh_re_bake_time = navigation_mesh_re_bake_interval
	print_debug("bake_navigation_mesh")
	bake_navigation_mesh()

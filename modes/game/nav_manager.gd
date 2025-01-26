class_name DynamicNavigationRegion3D extends NavigationRegion3D

@export var rebake_interval: float = 2.0
var rebake_timer: float = 0

func _physics_process(delta: float) -> void:
	# rebake_timer -= delta
	# if rebake_timer > 0:
	# 	return
	# rebake_timer = rebake_interval
	# if not is_baking():
	# 	bake_navigation_mesh()
	pass

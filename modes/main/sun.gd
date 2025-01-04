class_name Sun extends DirectionalLight3D

var look_at_target: Vector3 = Vector3(2.5,0,0)

func _process(_delta: float) -> void:
	look_at(look_at_target)

class_name CharacterSpringArm3D extends SpringArm3D

var interactor: CharacterRayCast3D

func save_child() -> Dictionary:
	if get_child_count():
		return get_children()[0].save_data()
	else:
		return {}

func save_data() -> Dictionary:
	return {
		"spring_length": spring_length,
		"child": save_child()
	}

func load_data(data: Dictionary) -> void:
	if data.child:
		var child_instance = load(data.child.scene).instantiate()
		add_child(child_instance)
		child_instance.load_data(data.child)
		child_instance.on_mouse_entered()
		child_instance.get_grabbed(interactor.character_instance, interactor)
	spring_length = data.spring_length

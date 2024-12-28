class_name PlayerLight extends SpotLight3D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_flashlight"):
		if is_visible_in_tree():
			hide()
		else:
			show()
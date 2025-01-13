class_name CharacterSpotLight3D extends SpotLight3D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_flashlight"):
		if is_visible_in_tree():
			hide()
		else:
			show()

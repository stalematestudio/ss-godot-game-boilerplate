extends Node

var mouse_look_vector: Vector2 = Vector2.ZERO

func get_move_vector() -> Vector2:
	var input_movement_vector: Vector2 = Input.get_vector("player_movement_right", "player_movement_left", "player_movement_backward", "player_movement_forward")

	input_movement_vector.y = input_movement_vector.y * ConfigManager.config_data.controller.left_y_sensitivity
	if ConfigManager.config_data.controller.left_y_inverted:
		input_movement_vector.y = input_movement_vector.y * -1
	
	input_movement_vector.x = input_movement_vector.x * ConfigManager.config_data.controller.left_x_sensitivity
	if ConfigManager.config_data.controller.left_x_inverted:
		input_movement_vector.x = input_movement_vector.x * -1

	return input_movement_vector

func get_look_vector() -> Vector2:
	var input_look_vector: Vector2 = Input.get_vector("player_look_right", "player_look_left", "player_look_up", "player_look_down")

	input_look_vector.y = input_look_vector.y * ConfigManager.config_data.controller.right_y_sensitivity
	if ConfigManager.config_data.controller.right_y_inverted:
		input_look_vector.y = input_look_vector.y * -1
	
	input_look_vector.x = input_look_vector.x * ConfigManager.config_data.controller.right_x_sensitivity
	if ConfigManager.config_data.controller.right_x_inverted:
		input_look_vector.x = input_look_vector.x * -1

	var look_vector = mouse_look_vector if mouse_look_vector else input_look_vector
	mouse_look_vector = Vector2.ZERO

	return look_vector

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return
	# This can use `relative` or a prefered `screen_relative`
	mouse_look_vector = Vector2(
		event.screen_relative.x * ConfigManager.config_data.mouse.mouse_sensitivity_x if ConfigManager.config_data.mouse.mouse_inverted_x else event.screen_relative.x * ConfigManager.config_data.mouse.mouse_sensitivity_x * -1,
		event.screen_relative.y * ConfigManager.config_data.mouse.mouse_sensitivity_y * -1 if ConfigManager.config_data.mouse.mouse_inverted_y else event.screen_relative.y * ConfigManager.config_data.mouse.mouse_sensitivity_y,
	)

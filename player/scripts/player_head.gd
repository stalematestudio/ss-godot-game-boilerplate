class_name PlayerHead extends Node3D

const HEAD_ROTATION_MIN: int = -90
const HEAD_ROTATION_MAX: int = 90

var input_look_vector: Vector2 = Vector2()
var player_head_rotation: Vector3 = Vector3()

@onready var player_character: PlayerCharacter = get_parent()

func _physics_process(_delta: float) -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if Input.is_action_pressed("player_mode_action"):
		return

	input_look_vector = Input.get_vector("player_look_right", "player_look_left", "player_look_up", "player_look_down")

	if ConfigManager.config_data.controller.right_y_inverted:
		input_look_vector.y = input_look_vector.y * -1
	
	if ConfigManager.config_data.controller.right_x_inverted:
		input_look_vector.x = input_look_vector.x * -1

	rotate_x(deg_to_rad( input_look_vector.y * ConfigManager.config_data.controller.right_y_sensitivity ))
	player_character.rotate_y(deg_to_rad( input_look_vector.x * ConfigManager.config_data.controller.right_x_sensitivity ))
	player_head_rotation = rotation_degrees
	player_head_rotation.x = clamp(player_head_rotation.x, HEAD_ROTATION_MIN, HEAD_ROTATION_MAX)
	rotation_degrees = player_head_rotation

func _input(event: InputEvent) -> void:
	if not Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		return
	if not event is InputEventMouseMotion:
		return
	if Input.is_action_pressed("player_mode_action"):
		return

	# This can use `relative` or a prefered `screen_relative`
	if ConfigManager.config_data.mouse.mouse_inverted_y:
		rotate_x(deg_to_rad(event.screen_relative.y * ConfigManager.config_data.mouse.mouse_sensitivity_y * -1))
	else:
		rotate_x(deg_to_rad(event.screen_relative.y * ConfigManager.config_data.mouse.mouse_sensitivity_y))
	
	if ConfigManager.config_data.mouse.mouse_inverted_x:
		player_character.rotate_y(deg_to_rad(event.screen_relative.x * ConfigManager.config_data.mouse.mouse_sensitivity_x))
	else:
		player_character.rotate_y(deg_to_rad(event.screen_relative.x * ConfigManager.config_data.mouse.mouse_sensitivity_x * -1))

extends Node

onready var fps_display = $VBoxContainer/HBoxContainer/FPS_Display

onready var m_forward = $player/VBoxContainer/sticks/move/forward
onready var m_backward = $player/VBoxContainer/sticks/move/backward
onready var m_left = $player/VBoxContainer/sticks/move/HBoxContainer/left
onready var m_right = $player/VBoxContainer/sticks/move/HBoxContainer/right

onready var l_up = $player/VBoxContainer/sticks/look/up
onready var l_down = $player/VBoxContainer/sticks/look/down
onready var l_left = $player/VBoxContainer/sticks/look/HBoxContainer/left
onready var l_right = $player/VBoxContainer/sticks/look/HBoxContainer/right

onready var player_target_name = $player/VBoxContainer/player_target/player_target_name
onready var player_target_distance = $player/VBoxContainer/player_target/player_target_distance
onready var player_target_velocity = $player/VBoxContainer/player_velocity
onready var player_target_direction = $player/VBoxContainer/player_direction

onready var input_display = $input_display

onready var input_map_dictionary = Dictionary()

func _ready():
	for action in InputMap.get_actions():
		input_map_dictionary[action] = []
		input_display.add_text(action)
		input_display.newline()
		for inev in InputMap.get_action_list(action):
			input_display.add_text(inev.as_text())
			input_display.newline()
		input_display.newline()

func _process(delta):
	fps_display.text = String(Engine.get_frames_per_second())

	m_forward.text = String(Input.get_action_strength("player_movement_forward"))
	m_backward.text = String(Input.get_action_strength("player_movement_backward"))
	m_left.text = String(Input.get_action_strength("player_movement_left"))
	m_right.text = String(Input.get_action_strength("player_movement_right"))

	l_up.text = String(Input.get_action_strength("player_look_up"))
	l_down.text = String(Input.get_action_strength("player_look_down"))
	l_left.text = String(Input.get_action_strength("player_look_left"))
	l_right.text = String(Input.get_action_strength("player_look_right"))

	var player_instance = get_node_or_null("/root/main/game_scene/player")
	if is_instance_valid(player_instance):
		if player_instance.raycast_target:
			player_target_name.text = player_instance.raycast_target.name
			player_target_distance.text = String(stepify(player_instance.raycast_target_distance, 0.1))
		else:
			player_target_name.text = ""
			player_target_distance.text = ""
		player_target_velocity.text = " x " + String(stepify(player_instance.velocity.x, 0.2)) + " y " + String(stepify(player_instance.velocity.y, 0.2)) + " z " + String(stepify(player_instance.velocity.z, 0.2))
		player_target_direction.text = " x " + String(stepify(player_instance.direction.x, 0.2)) + " y " + String(stepify(player_instance.direction.y, 0.2)) + " z " + String(stepify(player_instance.direction.z, 0.2))
	else:
		player_target_velocity.text = ""
		player_target_direction.text = ""

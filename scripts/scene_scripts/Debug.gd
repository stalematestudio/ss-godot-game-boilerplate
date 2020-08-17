extends Control

onready var fps_display = $VBoxContainer/HBoxContainer/FPS_Display

onready var m_forward = $player/VBoxContainer/sticks/move/forward
onready var m_backward = $player/VBoxContainer/sticks/move/backward
onready var m_left = $player/VBoxContainer/sticks/move/HBoxContainer/left
onready var m_right = $player/VBoxContainer/sticks/move/HBoxContainer/right

onready var l_up = $player/VBoxContainer/sticks/look/up
onready var l_down = $player/VBoxContainer/sticks/look/down
onready var l_left = $player/VBoxContainer/sticks/look/HBoxContainer/left
onready var l_right = $player/VBoxContainer/sticks/look/HBoxContainer/right

onready var player_target = $player/VBoxContainer/player_target

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

	var player_instance = get_node_or_null("/root/main/Demo/Player")
	if is_instance_valid(player_instance) and player_instance.raycast_target :
		player_target.text = player_instance.raycast_target.name
	else:
		player_target.text = ""

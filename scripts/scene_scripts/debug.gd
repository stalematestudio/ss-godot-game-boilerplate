extends Node

onready var vd_display = $VBC/VD_HBC/VD_Display
onready var fps_display = $VBC/FSP_HBC/FPS_Display
onready var gt_display = $GT_VBC/GT_Label

onready var m_forward = $player/HSplitContainer/VBoxContainerL/sticks/move/forward
onready var m_backward = $player/HSplitContainer/VBoxContainerL/sticks/move/backward
onready var m_left = $player/HSplitContainer/VBoxContainerL/sticks/move/HBoxContainer/left
onready var m_right = $player/HSplitContainer/VBoxContainerL/sticks/move/HBoxContainer/right

onready var l_up = $player/HSplitContainer/VBoxContainerL/sticks/look/up
onready var l_down = $player/HSplitContainer/VBoxContainerL/sticks/look/down
onready var l_left = $player/HSplitContainer/VBoxContainerL/sticks/look/HBoxContainer/left
onready var l_right = $player/HSplitContainer/VBoxContainerL/sticks/look/HBoxContainer/right

onready var player_target_name = $player/HSplitContainer/VBoxContainerL/player_target/player_target_name
onready var player_target_distance = $player/HSplitContainer/VBoxContainerL/player_target/player_target_distance
onready var player_target_velocity = $player/HSplitContainer/VBoxContainerL/player_velocity
onready var player_target_direction = $player/HSplitContainer/VBoxContainerL/player_direction

onready var input_display = $input_display

var last_event
var game_instance
var player_instance

func _ready():
	vd_display.set_text( String( OS.get_current_video_driver() ) + " - " + OS.get_video_driver_name( OS.get_current_video_driver() ) )
	game_instance = get_node_or_null("/root/main/game_scene")
	player_instance = get_node_or_null("/root/main/game_scene/player")
	GameManager.connect("game_state_changed", self, "_on_game_state_changed")

func _input(event):
	if event.is_pressed():
		if not last_event == event.as_text():
			last_event = event.as_text()
			if not event is InputEventMouseMotion:
				input_display.add_text(event.as_text())
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

	if is_instance_valid(player_instance):
		if player_instance.raycast_target:
			player_target_name.set_text(player_instance.raycast_target.name)
			player_target_distance.set_text(String(stepify(player_instance.raycast_target_distance, 0.1)))
		else:
			player_target_name.set_text("")
			player_target_distance.set_text("")
		player_target_velocity.set_text(" x " + String(stepify(player_instance.velocity.x, 0.2)) + " y " + String(stepify(player_instance.velocity.y, 0.2)) + " z " + String(stepify(player_instance.velocity.z, 0.2)))
		player_target_direction.set_text(" x " + String(stepify(player_instance.direction.x, 0.2)) + " y " + String(stepify(player_instance.direction.y, 0.2)) + " z " + String(stepify(player_instance.direction.z, 0.2)))

	if is_instance_valid(game_instance):
		gt_display.set_text(String(game_instance.game_time))

func _on_game_state_changed():
	if GameManager.game_state.scene == "game_scene":
		game_instance = get_node_or_null("/root/main/game_scene")
		player_instance = get_node_or_null("/root/main/game_scene/player")
	else:
		gt_display.set_text("")
		player_target_velocity.set_text("")
		player_target_direction.set_text("")

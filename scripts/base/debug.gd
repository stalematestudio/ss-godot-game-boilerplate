extends Node

@onready var vd_display = $VBC/VD_HBC/VD_Display
@onready var fps_display = $VBC/FSP_HBC/FPS_Display

@onready var game_time_display = $GAME_VBC/time
@onready var game_difficulty_display = $GAME_VBC/difficulty
@onready var game_level_loaded_display = $GAME_VBC/level

@onready var m_forward = $player/HSplitContainer/VBoxContainerL/sticks/move/forward
@onready var m_backward = $player/HSplitContainer/VBoxContainerL/sticks/move/backward
@onready var m_left = $player/HSplitContainer/VBoxContainerL/sticks/move/HBoxContainer/left
@onready var m_right = $player/HSplitContainer/VBoxContainerL/sticks/move/HBoxContainer/right

@onready var l_up = $player/HSplitContainer/VBoxContainerL/sticks/look/up
@onready var l_down = $player/HSplitContainer/VBoxContainerL/sticks/look/down
@onready var l_left = $player/HSplitContainer/VBoxContainerL/sticks/look/HBoxContainer/left
@onready var l_right = $player/HSplitContainer/VBoxContainerL/sticks/look/HBoxContainer/right

@onready var player_target_name = $player/HSplitContainer/VBoxContainerL/player_target/player_target_name
@onready var player_target_distance = $player/HSplitContainer/VBoxContainerL/player_target/player_target_distance

@onready var player_velocity_vector = $player/HSplitContainer/VBoxContainerL/player_velocity/vector
@onready var player_velocity_length = $player/HSplitContainer/VBoxContainerL/player_velocity/length

@onready var player_direction_vector = $player/HSplitContainer/VBoxContainerL/player_direction/vector
@onready var player_direction_length = $player/HSplitContainer/VBoxContainerL/player_direction/length

@onready var player_on_ceiling = $player/HSplitContainer/VBoxContainerR/ceiling
@onready var player_on_wall = $player/HSplitContainer/VBoxContainerR/wall
@onready var player_on_floor = $player/HSplitContainer/VBoxContainerR/floor
@onready var player_collisions = $player/HSplitContainer/VBoxContainerR/collisions
@onready var player_collider = $player/HSplitContainer/VBoxContainerR/collider

@onready var input_display = $input_display

var last_event
var game_instance
var player_instance

func _ready():
	vd_display.set_text( RenderingServer.get_video_adapter_name() )
	game_instance = get_node_or_null("/root/main/game")
	player_instance = get_node_or_null("/root/main/game/player")
	GameManager.connect("game_state_changed", Callable(self, "_on_game_state_changed"))

func _input(event):
	if event.is_pressed():
		if not last_event == event.as_text():
			last_event = event.as_text()
			if not event is InputEventMouseMotion:
				input_display.add_text(event.as_text())
				input_display.newline()

func _process(delta):
	fps_display.text = String.num(Engine.get_frames_per_second())
	
	m_forward.text = String.num(Input.get_action_strength("player_movement_forward"))
	m_backward.text = String.num(Input.get_action_strength("player_movement_backward"))
	m_left.text = String.num(Input.get_action_strength("player_movement_left"))
	m_right.text = String.num(Input.get_action_strength("player_movement_right"))
	
	l_up.text = String.num(Input.get_action_strength("player_look_up"))
	l_down.text = String.num(Input.get_action_strength("player_look_down"))
	l_left.text = String.num(Input.get_action_strength("player_look_left"))
	l_right.text = String.num(Input.get_action_strength("player_look_right"))

	if GameManager.game_state.scene == "game_scene":
		if is_instance_valid(player_instance):
			if player_instance.raycast_target:
				player_target_name.set_text(player_instance.raycast_target.name)
				player_target_distance.set_text(String.num(snapped(player_instance.raycast_target_distance, 0.1)))
			else:
				player_target_name.set_text("")
				player_target_distance.set_text("")
			
			player_velocity_vector.set_text(" x " + String(snapped(player_instance.velocity.x, 0.2)) + " y " + String(snapped(player_instance.velocity.y, 0.2)) + " z " + String(snapped(player_instance.velocity.z, 0.2)))
			player_velocity_length.set_text(" l " + String(player_instance.velocity.length()))

			player_direction_vector.set_text(" x " + String(snapped(player_instance.direction.x, 0.2)) + " y " + String(snapped(player_instance.direction.y, 0.2)) + " z " + String(snapped(player_instance.direction.z, 0.2)))
			player_direction_length.set_text(" l " + String(player_instance.direction.length()))

			player_on_ceiling.set_text(String(player_instance.is_on_ceiling()))
			player_on_wall.set_text(String(player_instance.is_on_wall()))
			player_on_floor.set_text(String(player_instance.is_on_floor()))
			var player_slide_collisions = player_instance.get_slide_collision_count()
			player_collisions.set_text(String(player_slide_collisions))
			if player_slide_collisions > 0:
				player_collider.set_text(String(player_instance.get_slide_collision(0).get_collider().name))
			else:
				player_collider.set_text("")
		else:
			player_instance = get_node_or_null("/root/main/game/player")

		if is_instance_valid(game_instance):
			game_time_display.set_text(String(game_instance.game_time))
			game_difficulty_display.set_text(String(game_instance.game_difficulty))
			game_level_loaded_display.set_text(String(game_instance.game_level_loaded))
		else:
			game_instance = get_node_or_null("/root/main/game")

func _on_game_state_changed():
	if GameManager.game_state.scene == "game_scene":
		game_instance = get_node_or_null("/root/main/game")
		player_instance = get_node_or_null("/root/main/game/player")
	else:
		game_time_display.set_text("")
		game_difficulty_display.set_text("")
		game_level_loaded_display.set_text("")

		player_target_name.set_text("")
		player_target_distance.set_text("")
		
		player_velocity_vector.set_text("")
		player_velocity_length.set_text("")

		player_direction_vector.set_text("")
		player_direction_length.set_text("")

		player_on_ceiling.set_text("")
		player_on_wall.set_text("")
		player_on_floor.set_text("")
		player_collisions.set_text("")
		player_collider.set_text("")

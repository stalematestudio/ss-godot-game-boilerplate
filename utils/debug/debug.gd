extends Node

@onready var vd_display = $h_box_container/v_box_container/VBC/VD_HBC/VD_Display
@onready var fps_display = $h_box_container/v_box_container/VBC/FSP_HBC/FPS_Display

@onready var game_time_display = $h_box_container/v_box_container/GAME_VBC/time
@onready var game_difficulty_display = $h_box_container/v_box_container/GAME_VBC/difficulty
@onready var game_level_loaded_display = $h_box_container/v_box_container/GAME_VBC/level

@onready var m_forward = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerL/sticks/move/forward
@onready var m_backward = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerL/sticks/move/backward
@onready var m_left = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerL/sticks/move/HBoxContainer/left
@onready var m_right = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerL/sticks/move/HBoxContainer/right

@onready var l_up = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerL/sticks/look/up
@onready var l_down = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerL/sticks/look/down
@onready var l_left = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerL/sticks/look/HBoxContainer/left
@onready var l_right = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerL/sticks/look/HBoxContainer/right

@onready var player_target_name = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerL/player_target/player_target_name
@onready var player_target_distance = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerL/player_target/player_target_distance

@onready var player_velocity_vector = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerL/player_velocity/vector
@onready var player_velocity_length = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerL/player_velocity/length

@onready var player_direction_vector = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerL/player_direction/vector
@onready var player_direction_length = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerL/player_direction/length

@onready var player_on_ceiling = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerR/ceiling
@onready var player_on_wall = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerR/wall
@onready var player_on_floor = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerR/floor
@onready var player_collisions = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerR/collisions
@onready var player_collider = $h_box_container/v_box_container/player/HSplitContainer/VBoxContainerR/collider

@onready var input_display = $h_box_container/input_display

var last_event: String
var game_instance: Node
var player_control: PlayerController

func _ready():
	vd_display.set_text( RenderingServer.get_video_adapter_name() )
	GameManager.game_state_changed.connect(_on_game_state_changed)

func _input(event: InputEvent):
	if event.is_pressed():
		if not last_event == event.as_text():
			last_event = event.as_text()
			if not event is InputEventMouseMotion:
				input_display.add_text(event.as_text())
				input_display.newline()

func _process(_delta):
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
		if is_instance_valid(player_control.character):
			player_velocity_vector.set_text(" x " + String.num(snapped(player_control.character.velocity.x, 0.2)) + " y " + String.num(snapped(player_control.character.velocity.y, 0.2)) + " z " + String.num(snapped(player_control.character.velocity.z, 0.2)))
			player_velocity_length.set_text(" l " + String.num(player_control.character.velocity.length()))

			player_direction_vector.set_text(" x " + String.num(snapped(player_control.character.movement_direction.x, 0.2)) + " y " + String.num(snapped(player_control.character.movement_direction.y, 0.2)) + " z " + String.num(snapped(player_control.character.movement_direction.z, 0.2)))
			player_direction_length.set_text(" l " + String.num(player_control.character.movement_direction.length()))

			player_on_ceiling.set_text( "True" if player_control.character.is_on_ceiling() else "False" )
			player_on_wall.set_text( "True" if player_control.character.is_on_wall() else "False" )
			player_on_floor.set_text( "True" if player_control.character.is_on_floor() else "False")

			var player_slide_collisions = player_control.character.get_slide_collision_count()
			player_collisions.set_text(String.num(player_slide_collisions))

			if player_slide_collisions > 0:
				var colider = player_control.character.get_slide_collision(0).get_collider()
				player_collider.set_text(colider.name if colider else "")

			if is_instance_valid(player_control.character_ray_cast_3D):
				if player_control.character_ray_cast_3D.raycast_target:
					player_target_name.set_text(player_control.character_ray_cast_3D.raycast_target.name)
					player_target_distance.set_text(String.num(snapped(player_control.character_ray_cast_3D.raycast_target_distance, 0.1)))
				else:
					player_target_name.set_text("")
					player_target_distance.set_text("")
		else:
			_on_game_state_changed()

		if is_instance_valid(game_instance):
			game_time_display.set_text("%.2f" % game_instance.game_time)
			game_difficulty_display.set_text(game_instance.game_difficulty)
			game_level_loaded_display.set_text(" | ".join(game_instance.maps_manager.levels_loaded))
		else:
			_on_game_state_changed()

func _on_game_state_changed():
	if GameManager.game_state.scene == "game_scene":
		game_instance = get_node_or_null("/root/main/game")
		player_control = get_node_or_null("/root/main/game/player_control")
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

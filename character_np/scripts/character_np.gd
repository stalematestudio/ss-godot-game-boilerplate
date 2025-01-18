class_name CharacterNP extends CharacterBody3D

# Environmental Variables will be moved to level scene or game state
var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

const HEAD_ROTATION_MIN: int = -90
const HEAD_ROTATION_MAX: int = 90

# Player stats
const MAX_WALK_SPEED: float = 2
const WALK_ACCEL: float = 0.2

const DEACCEL: float = 9.0

var nav_target: Vector3 = Vector3.ZERO
var nav_target_direction: Vector3 = Vector3.ZERO
var nav_target_direction_horizontal: Vector3 = Vector3.ZERO

var input_look_vector: Vector2 = Vector2()
var input_movement_vector: Vector2 = Vector2()
var input_movement_vector_magnitude: float = float()
var horizontal_velocity: Vector3 = Vector3()

var movement_target_speed: Vector3 = Vector3()
var movement_accel: float = float()
var movement_direction: Vector3 = Vector3()

var step_distance: float = float()

@onready var home_possition: Vector3

# Player Nodes
@onready var head: Node3D = $character_head
@onready var raycast: RayCast3D = $character_head/character_ray_cast_3D
@onready var navigation: NavigationAgent3D = $navigation_agent_3d
@onready var steps_player: AudioStreamPlayer3D = $character_steps_audio_stream_player_3D

var player_character: Character
var player_character_position: Vector3 = Vector3.ZERO
var player_character_direction: Vector3 = Vector3.ZERO
var player_character_distance: float = 0.0

var navigation_next_path_position: Vector3 = Vector3.ZERO
var navigation_next_path_direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	navigation.target_reached.connect(_on_target_reached)
	navigation.navigation_finished.connect(_on_navigation_finished)

	home_possition = global_position

func _process(_delta: float) -> void:
	if player_character:
		player_character_position = player_character.global_position
		player_character_direction = global_position.direction_to(player_character_position)
		player_character_distance = global_position.distance_to(player_character_position)
		nav_target = player_character_position
	elif ( raycast.is_colliding() ) and ( raycast.get_collider() is Character ):
		player_character = raycast.get_collider()
	else:
		nav_target = home_possition

var vector_report_interval: float = 1
var vector_report_time: float = vector_report_interval

func _physics_process(delta: float) -> void:
	if player_character:
		head.look_at(player_character.head.global_position, Vector3.UP, true)
		# This turns the body towars the player character
		# look_at(Vector3(
		# 	player_character.global_position.x,
		# 	global_position.y,
		# 	player_character.global_position.z,
		# ), Vector3.UP, true)
	else:
		head.rotation_degrees = Vector3.ZERO

	navigation.target_position = nav_target
	navigation_next_path_position = navigation.get_next_path_position()
	# if global_position.distance_to(navigation_next_path_position) > 1:
	look_at(Vector3(
		navigation_next_path_position.x,
		global_position.y,
		navigation_next_path_position.z,
	), Vector3.UP, true)
	navigation_next_path_direction = global_position.direction_to(navigation_next_path_position)

	#Get movement inputs
	if is_on_floor() and navigation_next_path_direction:
		# x is side movement, y is back and forth
		input_movement_vector = Vector2(
			0,
			global_position.distance_to(navigation.target_position),
		)
	else:
		input_movement_vector = Vector2()

	# Basis vectors are normalized
	input_movement_vector_magnitude = min(input_movement_vector.length(), 1)
	input_movement_vector = input_movement_vector.normalized()

	movement_direction = (transform.basis * Vector3(input_movement_vector.x, 0, input_movement_vector.y)).normalized()
	
	velocity.y -= default_gravity * delta
	
	horizontal_velocity = velocity
	horizontal_velocity.y = 0

	movement_target_speed = movement_direction * ( MAX_WALK_SPEED * input_movement_vector_magnitude ) 

	if movement_direction.dot(horizontal_velocity) > 0:
		movement_accel = WALK_ACCEL * input_movement_vector_magnitude
	else:
		movement_accel = DEACCEL
		
	if is_on_floor():
		horizontal_velocity = horizontal_velocity.lerp(movement_target_speed, movement_accel * delta)

	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	
	move_and_slide()
	
	if is_on_floor():
		step_distance = step_distance + ( velocity.length() * delta )
		if step_distance >= 1:
			step_distance = 0
			if not steps_player.is_playing():
				steps_player.set_pitch_scale( velocity.length() )
				steps_player.play()

func _on_target_reached() -> void:
	pass

func _on_navigation_finished() -> void:
	pass

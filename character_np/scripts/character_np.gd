class_name CharacterNP extends CharacterBody3D

# Environmental Variables will be moved to level scene or game state
var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

const HEAD_ROTATION_MIN: int = -90
const HEAD_ROTATION_MAX: int = 90

# Player stats
const MAX_WALK_SPEED: float = 4.5
const WALK_ACCEL: float = 0.8

const DEACCEL: float = 9.0

var nav_target: Vector3 = Vector3.ZERO
var nav_target_direction: Vector3 = Vector3.ZERO
var nav_target_direction_horizontal: Vector3 = Vector3.ZERO
var nav_target_direction_vertical: Vector3 = Vector3.ZERO

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
@onready var collision_shape: CollisionShape3D = $character_collision_shape_3D
@onready var head: Node3D = $character_np_head
@onready var raycast: RayCast3D = $character_np_head/ray_cast_3d
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

	home_possition = Vector3(
		global_position.x,
		global_position.y,
		global_position.z,
	)

func _process(delta):
	if ( raycast.is_colliding() ) and ( raycast.get_collider() is Character ):
		player_character = raycast.get_collider()

func _physics_process(delta: float) -> void:

	if player_character:
		player_character_position = player_character.global_position
		player_character_direction = global_position.direction_to(player_character_position)
		player_character_distance = global_position.distance_to(player_character_position)
		nav_target = player_character_position
	else:
		nav_target = home_possition

	navigation.target_position = nav_target
	navigation_next_path_position = navigation.get_next_path_position()

	nav_target_direction = global_position.direction_to(nav_target)
	nav_target_direction_horizontal = Vector3(
		nav_target_direction.x,
		0,
		nav_target_direction.z,
	)

	# look_at(global_position + nav_target_direction_horizontal, Vector3.UP, true)

	navigation_next_path_direction = global_position.direction_to(navigation_next_path_position)

	# head.rotate_x(deg_to_rad( input_look_vector.y ))
	# rotate_y(deg_to_rad( input_look_vector.x ))
	# rotation_degrees.x = clamp(rotation_degrees.x, HEAD_ROTATION_MIN, HEAD_ROTATION_MAX)

	#Get movement inputs
	if is_on_floor() and navigation_next_path_direction:
		input_movement_vector = Vector2(
			navigation_next_path_direction.x,
			navigation_next_path_direction.z,
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
	# print_debug("_on_target_reached")
	if player_character:
		player_character = null
	else:
		navigation.target_position = home_possition

func _on_navigation_finished() -> void:
	print_debug("_on_navigation_finished ", navigation.is_target_reachable())

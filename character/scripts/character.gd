class_name Character extends CharacterBody3D

# Environmental Variables will be moved to level scene or game state
var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

# Player stats
const MAX_WALK_SPEED: float = 4.5
const WALK_ACCEL: float = 0.8

const MAX_SPRINT_SPEED: float = 9.0
const SPRINT_ACCEL: float = 1.6

const MAX_CROUCH_SPEED: float = 2.0
const CROUCH_ACCEL: float = 0.4

const DEACCEL: float = 9.0
const JUMP_SPEED: float = 6.0

@onready var health_max: float = 100
@onready var health: float = 100

@onready var stamina_max: float = 30
@onready var stamina: float = 30

var _is_player_controlled: bool = false
@export var is_player_controlled: bool:
	get:
		return _is_player_controlled
	set(new_is_player_controlled):
		if new_is_player_controlled == _is_player_controlled:
			return
		var player_control: PlayerController = Helpers.get_character_controler("player_control")
		if player_control.character:
			return
		_is_player_controlled = new_is_player_controlled
		Helpers.get_character_controler("player_control").character = self

var is_jumping: bool = false
var is_sprinting: bool  = false
var is_crouching: bool  = false

var input_movement_vector: Vector2 = Vector2()
var input_movement_vector_magnitude: float = float()
var horizontal_velocity: Vector3 = Vector3()

var movement_target_speed: Vector3 = Vector3()
var movement_accel: float = float()
var movement_direction: Vector3 = Vector3()

var step_distance: float = float()

# Player Nodes
@onready var head: CharacterHead = $character_head
@onready var steps_player: AudioStreamPlayer3D = $character_steps_audio_stream_player_3D
@onready var animation: CharacterAnimationPlayer = $character_animation_player

func _ready() -> void:
	if is_inside_tree() and not is_in_group("chracters"):
		add_to_group("chracters", true)

func movement(delta: float) -> void:
	# Basis vectors are normalized
	input_movement_vector_magnitude = min(input_movement_vector.length(), 1)
	input_movement_vector = input_movement_vector.normalized()

	movement_direction = (global_basis * Vector3(input_movement_vector.x, 0, input_movement_vector.y)).normalized()
	
	velocity.y -= default_gravity * delta
	
	horizontal_velocity = velocity
	horizontal_velocity.y = 0
	
	if is_sprinting:
		movement_target_speed = movement_direction * ( MAX_SPRINT_SPEED * input_movement_vector_magnitude ) 
	elif is_crouching:
		movement_target_speed = movement_direction * ( MAX_CROUCH_SPEED * input_movement_vector_magnitude ) 
	else:
		movement_target_speed = movement_direction * ( MAX_WALK_SPEED * input_movement_vector_magnitude ) 

	if movement_direction.dot(horizontal_velocity) > 0:
		if is_sprinting:
			stamina = clamp( stamina - delta , 0 , stamina_max ) 
			movement_accel = SPRINT_ACCEL * input_movement_vector_magnitude
		elif is_crouching:
			movement_accel = CROUCH_ACCEL * input_movement_vector_magnitude
		else:
			movement_accel = WALK_ACCEL * input_movement_vector_magnitude
	else:
		movement_accel = DEACCEL
		is_sprinting = false
		stamina = clamp( stamina + delta / 2 , 0 ,  stamina_max )
		
	if is_on_floor():
		horizontal_velocity = horizontal_velocity.lerp(movement_target_speed, movement_accel * delta)

	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	
	move_and_slide()
	
	if is_on_floor():
		if is_jumping:
			is_jumping = false
			step_distance = 0
			if not steps_player.is_playing():
				steps_player.set_pitch_scale(1)
				steps_player.play()
		step_distance = step_distance + ( velocity.length() * delta )
		if step_distance >= 1:
			step_distance = 0
			if not steps_player.is_playing():
				steps_player.set_pitch_scale( velocity.length() )
				steps_player.play()
	else:
		is_jumping = true

func save_data() -> Dictionary:
	return {
	"name": name,
	"scene": get_scene_file_path(),
	"is_player_controlled": is_player_controlled,
	"player_health": health,
	"player_stamina": stamina,
	"is_jumping": is_jumping,
	"is_sprinting": is_sprinting,
	"is_crouching": is_crouching,
	"position": position,
	"rotation":	rotation,
	"velocity" : velocity,
	"rotation_head": head.rotation_degrees,
	}

func load_data(data: Dictionary) -> void:
	is_player_controlled = data.is_player_controlled if data.has("is_player_controlled") else is_player_controlled
	health = data.player_health if data.has("player_health") else health
	stamina = data.player_stamina if data.has("player_stamina") else stamina
	is_jumping = data.is_jumping if data.has("is_jumping") else is_jumping
	is_sprinting = data.is_sprinting if data.has("is_sprinting") else is_sprinting
	# TODO: crouching doesn't work on load game
	is_crouching = data.is_crouching if data.has("is_crouching") else is_crouching
	position = Helpers.string_to_vector(data.position) if data.position is String else data.position
	rotation = Helpers.string_to_vector(data.rotation) if data.rotation is String else data.rotation
	velocity = Helpers.string_to_vector(data.velocity) if data.velocity is String else data.velocity
	head.rotation_degrees = Helpers.string_to_vector(data.rotation_head) if data.rotation_head is String else data.rotation_head

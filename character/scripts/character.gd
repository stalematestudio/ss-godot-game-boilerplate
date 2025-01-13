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

var is_jumping: bool = false
var is_sprinting: bool  = false
var is_crouching: bool  = false

var input_movement_vector: Vector2 = Vector2()
var input_movement_vector_magnitude: float = float()
var horizontal_velocity: Vector3 = Vector3()

var target: Vector3 = Vector3()
var accel: float = float()
var direction: Vector3 = Vector3()

var step_distance: float = float()

# Player Nodes
@onready var collision_shape: CollisionShape3D = $character_collision_shape_3D
@onready var head: CharacterHead = $character_head
@onready var steps_player: AudioStreamPlayer3D = $character_steps_audio_stream_player_3D
@onready var animation: CharacterAnimationPlayer = $character_animation_player

func _physics_process(delta: float) -> void:
	#Get movement inputs
	if is_on_floor():
		input_movement_vector = PlayerUtils.get_move_vector()

		# Jumping
		if Input.is_action_just_pressed("player_movement_jump"):
			is_jumping = true
			velocity.y = JUMP_SPEED * Input.get_action_strength("player_movement_jump")
		
		# Sprinting
		if Input.is_action_just_pressed("player_movement_sprint") and ( stamina >= stamina_max / 2.0 ):
			is_sprinting = ( input_movement_vector.y > 0 )
			if is_crouching:
				is_crouching = false
				animation.un_crouch()
		elif stamina <= 0 :
			is_sprinting = false
		# Sprint only forward
		is_sprinting = is_sprinting and ( input_movement_vector.y > 0 )

		# Crouching
		if is_on_ceiling() and not is_crouching:
			is_crouching = true
			is_sprinting = false
			animation.crouch()
			
	if Input.is_action_just_pressed("player_movement_crouch"):
		if is_crouching:
			is_crouching = false
			animation.un_crouch()
		else:
			is_crouching = true
			is_sprinting = false
			animation.crouch()
	
	# Basis vectors are normalized
	input_movement_vector_magnitude = min(input_movement_vector.length(), 1)
	input_movement_vector = input_movement_vector.normalized()

	direction = (transform.basis * Vector3(input_movement_vector.x, 0, input_movement_vector.y)).normalized()
	
	velocity.y -= default_gravity * delta
	
	horizontal_velocity = velocity
	horizontal_velocity.y = 0
	
	if is_sprinting:
		target = direction * ( MAX_SPRINT_SPEED * input_movement_vector_magnitude ) 
	elif is_crouching:
		target = direction * ( MAX_CROUCH_SPEED * input_movement_vector_magnitude ) 
	else:
		target = direction * ( MAX_WALK_SPEED * input_movement_vector_magnitude ) 

	if direction.dot(horizontal_velocity) > 0:
		if is_sprinting:
			stamina = clamp( stamina - delta , 0 , stamina_max ) 
			accel = SPRINT_ACCEL * input_movement_vector_magnitude
		elif is_crouching:
			accel = CROUCH_ACCEL * input_movement_vector_magnitude
		else:
			accel = WALK_ACCEL * input_movement_vector_magnitude
	else:
		accel = DEACCEL
		is_sprinting = false
		stamina = clamp( stamina + delta / 2 , 0 ,  stamina_max )
		
	if is_on_floor():
		horizontal_velocity = horizontal_velocity.lerp(target, accel * delta)

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

class_name PlayerCharacter extends CharacterBody3D

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

# Player Health
@onready var player_health_max: float = 100
@onready var player_health: float = 100

# Player Stamina
@onready var player_stamina_max: float = 30
@onready var player_stamina: float = 30

var is_jumping: bool = false
var is_sprinting: bool  = false
var is_crouching: bool  = false

var input_movement_vector: Vector2 = Vector2()
var player_control_orientation = Transform2D()

var player_speed: float = float()
var player_step_distance: float = float()
var input_movement_vector_magnitude: float = float()
var horizontal_velocity: Vector3 = Vector3()
var mouse_scroll_value: float = float()
var mouse_scrolled: float  = float()

var target: Vector3 = Vector3()
var accel: float = float()
var direction: Vector3 = Vector3()

# Player Nodes
@onready var player_collision_shape: CollisionShape3D = $PlayerCollisionShape
@onready var player_head: PlayerHead = $PlayerHead
@onready var player_steps_player: AudioStreamPlayer3D = $PlayerStepsAudio3D
@onready var player_animation: PlayerAnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# if is_inside_tree() and not is_in_group("game_save_objects"):
	# 	add_to_group("game_save_objects", true)
	pass

func _physics_process(delta: float) -> void:
	#Get movement inputs
	input_movement_vector = Vector2()
	if is_on_floor():
		if Input.is_action_pressed("player_movement_forward"):
			input_movement_vector.y = input_movement_vector.y + Input.get_action_strength("player_movement_forward")
		if Input.is_action_pressed("player_movement_backward"):
			input_movement_vector.y = input_movement_vector.y - Input.get_action_strength("player_movement_backward")
		if Input.is_action_pressed("player_movement_left"):
			input_movement_vector.x = input_movement_vector.x + Input.get_action_strength("player_movement_left")
		if Input.is_action_pressed("player_movement_right"):
			input_movement_vector.x = input_movement_vector.x - Input.get_action_strength("player_movement_right")

		if ConfigManager.config_data.controller.left_y_inverted:
			input_movement_vector.y = input_movement_vector.y * -1
		
		if ConfigManager.config_data.controller.left_x_inverted:
			input_movement_vector.x = input_movement_vector.x * -1

		# Jumping
		if Input.is_action_just_pressed("player_movement_jump"):
			is_jumping = true
			velocity.y = JUMP_SPEED * Input.get_action_strength("player_movement_jump")
		
		# Sprinting
		if Input.is_action_just_pressed("player_movement_sprint") and ( player_stamina >= player_stamina_max / 2.0 ):
			is_sprinting = ( input_movement_vector.y > 0 )
			if is_crouching:
				is_crouching = false
				player_animation.un_crouch()
		elif player_stamina <= 0 :
			is_sprinting = false
		# Sprint only forward
		is_sprinting = is_sprinting and ( input_movement_vector.y > 0 )

		# Crouching
		if is_on_ceiling() and not is_crouching:
			is_crouching = true
			is_sprinting = false
			player_animation.crouch()
			
	if Input.is_action_just_pressed("player_movement_crouch"):
		if is_crouching:
			is_crouching = false
			player_animation.un_crouch()
		else:
			is_crouching = true
			is_sprinting = false
			player_animation.crouch()
	
	# Basis vectors are normalized
	input_movement_vector_magnitude = min(input_movement_vector.length(), 1)
	input_movement_vector = input_movement_vector.normalized()
	
	direction = Vector3()
	player_control_orientation = player_head.get_global_transform()
	direction += player_control_orientation.basis.z * input_movement_vector.y
	direction += player_control_orientation.basis.x * input_movement_vector.x
	
	direction.y = 0
	direction = direction.normalized()
	
	velocity.y = velocity.y + ( delta * default_gravity * -1 )
	
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
			player_stamina = clamp( player_stamina - delta , 0 , player_stamina_max ) 
			accel = SPRINT_ACCEL * input_movement_vector_magnitude
		elif is_crouching:
			accel = CROUCH_ACCEL * input_movement_vector_magnitude
		else:
			accel = WALK_ACCEL * input_movement_vector_magnitude
	else:
		accel = DEACCEL
		is_sprinting = false
		player_stamina = clamp( player_stamina + delta / 2 , 0 ,  player_stamina_max )
		
	if is_on_floor():
		horizontal_velocity = horizontal_velocity.lerp(target, accel * delta)

	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	
	move_and_slide()
	
	if is_on_floor():
		player_speed = velocity.length()
		if is_jumping:
			is_jumping = false
			player_step_distance = 0
			if not player_steps_player.is_playing():
				player_steps_player.set_pitch_scale(1)
				player_steps_player.play()
		player_step_distance = player_step_distance + ( player_speed * delta )
		if player_step_distance >= 1:
			player_step_distance = 0
			if not player_steps_player.is_playing():
				player_steps_player.set_pitch_scale( player_speed )
				player_steps_player.play()
	else:
		is_jumping = true

# Not sure what I needed this for.
# func _input(event: InputEvent) -> void:
# 	if (Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED) and (event is InputEventMouseButton):
# 		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
# 			if ConfigManager.config_data.mouse.mouse_inverted_scroll:
# 				mouse_scrolled = ConfigManager.config_data.mouse.mouse_sensitivity_scroll * -1
# 			else:
# 				mouse_scrolled = ConfigManager.config_data.mouse.mouse_sensitivity_scroll
# 			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
# 				mouse_scroll_value += mouse_scrolled
# 			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
# 				mouse_scroll_value -= mouse_scrolled

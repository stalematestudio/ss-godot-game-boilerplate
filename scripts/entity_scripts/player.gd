extends KinematicBody

# Camera positions
export (Array, Transform) var camera_position
onready var camera_position_selected = 0

# Environmental Variables will be moved to level scene or game state
const GRAVITY = 9.8
const GRAVITY_VECTOR = Vector3(0,1,0)

# Player stats
const MAX_WALK_SPEED = 4.5
const WALK_ACCEL = 0.8

const MAX_SPRINT_SPEED = 9
const SPRINT_ACCEL = 1.6

const MAX_CROUCH_SPEED = 2
const CROUCH_ACCEL = 0.4

const DEACCEL = 9
const MAX_SLOPE_ANGLE = 40

const JUMP_SPEED = 6

# Player Health
onready var player_health_max = 100
onready var player_health = 100

# Player Stamina
onready var player_stamina_max = 30
onready var player_stamina = 30

var player_move_snap = Vector3(0,1,0)
var player_move_up_direction = GRAVITY_VECTOR
var player_move_stop_on_slope = true 
var player_move_max_slides = 4
var player_move_floor_max_angle = deg2rad(MAX_SLOPE_ANGLE)
var player_move_infinite_inertia = false

var mouse_scroll_value = 0

var is_sprinting = false
var is_crouching = false

var velocity = Vector3()
var direction = Vector3()

onready var player_collision_shape = $PlayerCollisionShape
onready var player_head = $PlayerHead
onready var player_ray_cast = $PlayerHead/PlayerRayCast
onready var player_camera = $PlayerHead/PlayerCamera
onready var player_light = $PlayerHead/PlayerLight

onready var player_stats_health = $player_stats/health
onready var player_stats_stamina = $player_stats/stamina

onready var player_animation = $AnimationPlayer

var raycast_target = false
var raycast_target_distance = false

const OBJECT_THROW_FORCE = 1
const OBJECT_GRAB_DISTANCE = 2
var grabbed_object = null
var grabbed_object_distance = 0.5

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player_stats_health.set_max(player_health_max)
	player_stats_stamina.set_max(player_stamina_max)

func _process(delta):
	player_stats_health.set_value(player_health)
	player_stats_stamina.set_value(player_stamina)

	process_input()
	process_ray_cast()

func _physics_process(delta):
	process_look()
	process_movement(delta)

func process_input():
	#Change Camera
	if Input.is_action_just_pressed("util_camera_switch"):
		camera_position_selected = camera_position_selected + 1 if camera_position_selected < camera_position.size() - 1 else 0
		player_camera.transform = camera_position[camera_position_selected]

	# Grabbin and throwing objects
	if Input.is_action_just_pressed("player_primary_action"):
		if ( grabbed_object == null ) and ( player_ray_cast.is_colliding() ) and ( raycast_target is RigidBody ) and ( raycast_target_distance < OBJECT_GRAB_DISTANCE ) :
			grabbed_object = raycast_target
			grabbed_object_distance = raycast_target_distance
			add_collision_exception_with(grabbed_object)
		elif grabbed_object != null:
			grabbed_object.apply_central_impulse(player_head.global_transform.basis.z.normalized() * OBJECT_THROW_FORCE)
			remove_collision_exception_with(grabbed_object)
			grabbed_object = null
	
	# Holding object
	if grabbed_object != null:
		grabbed_object.global_transform.origin = player_head.global_transform.origin + ( player_head.global_transform.basis.z.normalized() * grabbed_object_distance )

	# Flashlight
	if Input.is_action_just_pressed("player_flashlight"):
		if player_light.is_visible_in_tree():
			player_light.hide()
		else:
			player_light.show()

func process_look():
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return

	var input_look_vector = Vector2()
	if Input.is_action_pressed("player_look_up"):
		input_look_vector.y = input_look_vector.y - Input.get_action_strength("player_look_up") 
	if Input.is_action_pressed("player_look_down"):
		input_look_vector.y = input_look_vector.y + Input.get_action_strength("player_look_down")
	if Input.is_action_pressed("player_look_left"):
		input_look_vector.x = input_look_vector.x + Input.get_action_strength("player_look_left")
	if Input.is_action_pressed("player_look_right"):
		input_look_vector.x = input_look_vector.x - Input.get_action_strength("player_look_right")

	if ConfigManager.config_data.controller.right_y_inverted:
		input_look_vector.y = input_look_vector.y * -1
	
	if ConfigManager.config_data.controller.right_x_inverted:
		input_look_vector.x = input_look_vector.x * -1

	player_head.rotate_x(deg2rad( input_look_vector.y * ConfigManager.config_data.controller.right_y_sensitivity ))
	rotate_y(deg2rad( input_look_vector.x * ConfigManager.config_data.controller.right_x_sensitivity ))
	var player_head_rotation = player_head.rotation_degrees
	player_head_rotation.x = clamp(player_head_rotation.x, -70, 70)
	player_head.rotation_degrees = player_head_rotation

func process_movement(delta):
	direction = Vector3()
	var head_x_form = player_head.get_global_transform()
	var input_movement_vector = Vector2()
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
			velocity.y = JUMP_SPEED * Input.get_action_strength("player_movement_jump")

	# Basis vectors are normalized 
	var input_movement_vector_magnitude = min(1, input_movement_vector.length())
	input_movement_vector = input_movement_vector.normalized()
	direction += head_x_form.basis.z * input_movement_vector.y
	direction += head_x_form.basis.x * input_movement_vector.x

	# Sprinting
	if Input.is_action_just_pressed("player_movement_sprint") and ( player_stamina >= player_stamina_max / 2 ) and ( not is_crouching ) :
		is_sprinting = true
	elif player_stamina <= 0 :
		is_sprinting = false

	# Crouching
	if is_on_ceiling():
		is_crouching = true
		is_sprinting = false
		player_animation.play("crouch")
		
	if Input.is_action_just_pressed("player_movement_crouch"):
		if is_crouching:
			is_crouching = false
			player_animation.play_backwards("crouch")
		else:
			is_crouching = true
			is_sprinting = false
			player_animation.play("crouch")
	
	direction.y = 0
	direction = direction.normalized()
	
	velocity.y += delta * GRAVITY * -1
	
	var horizontal_velocity = velocity
	horizontal_velocity.y = 0
	
	var target
	if is_sprinting:
		target = direction * ( MAX_SPRINT_SPEED * input_movement_vector_magnitude ) 
	elif is_crouching:
		target = direction * ( MAX_CROUCH_SPEED * input_movement_vector_magnitude ) 
	else:
		target = direction * ( MAX_WALK_SPEED * input_movement_vector_magnitude ) 

	var accel
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
		horizontal_velocity = horizontal_velocity.linear_interpolate(target, accel * delta)

	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	
	velocity = move_and_slide_with_snap(
	#velocity = move_and_slide(
			velocity, 
			player_move_snap, # Coment out for move and slide w/o snap
			player_move_up_direction, 
			player_move_stop_on_slope, 
			player_move_max_slides, 
			player_move_floor_max_angle, 
			player_move_infinite_inertia
			)

func _input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			if ConfigManager.config_data.mouse.mouse_inverted_y:
				player_head.rotate_x(deg2rad(event.relative.y * ConfigManager.config_data.mouse.mouse_sensitivity_y * -1))
			else:
				player_head.rotate_x(deg2rad(event.relative.y * ConfigManager.config_data.mouse.mouse_sensitivity_y))
			
			if ConfigManager.config_data.mouse.mouse_inverted_x:
				self.rotate_y(deg2rad(event.relative.x * ConfigManager.config_data.mouse.mouse_sensitivity_x))
			else:
				self.rotate_y(deg2rad(event.relative.x * ConfigManager.config_data.mouse.mouse_sensitivity_x * -1))
			
			var player_head_rotation = player_head.rotation_degrees
			player_head_rotation.x = clamp(player_head_rotation.x, -55, 55)
			player_head.rotation_degrees = player_head_rotation
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_WHEEL_UP or event.button_index == BUTTON_WHEEL_DOWN:
				var mouse_scrolled
				if ConfigManager.config_data.mouse.mouse_inverted_scroll:
					mouse_scrolled = ConfigManager.config_data.mouse.mouse_sensitivity_scroll * -1
				else:
					mouse_scrolled = ConfigManager.config_data.mouse.mouse_sensitivity_scroll				
				if event.button_index == BUTTON_WHEEL_UP:
					mouse_scroll_value += mouse_scrolled
				elif event.button_index == BUTTON_WHEEL_DOWN:
					mouse_scroll_value -= mouse_scrolled

func process_ray_cast():
	if player_ray_cast.is_colliding():
		raycast_target = player_ray_cast.get_collider()
		raycast_target_distance = player_ray_cast.get_global_transform().origin.distance_to(player_ray_cast.get_collision_point())
	else:
		raycast_target = false
		raycast_target_distance = false

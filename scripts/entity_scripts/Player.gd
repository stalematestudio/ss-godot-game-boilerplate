extends KinematicBody

# Get Globals
onready var globals = get_node("/root/Globals")
onready var config_manager = get_node("/root/ConfigManager")
onready var audio_manager = get_node("/root/AudioManager")

# Environmental Variables
const GRAVITY = -24.8 # this variable goes to the level or game state

# Player stats
const MAX_WALK_SPEED = 20
const WALK_ACCEL = 4.5

const MAX_SPRINT_SPEED = 30
const SPRINT_ACCEL = 18

const MAX_CROUCH_SPEED = 10
const CROUCH_ACCEL = 4.5

const DEACCEL = 16
const MAX_SLOPE_ANGLE = 40

const JUMP_SPEED = 18

var JOYPAD_SENSITIVITY = 2
const JOYPAD_DEADZONE = 0.15

var mouse_scroll_value = 0
var camera_3d_person = false

var velocity = Vector3()
var direction = Vector3()
var is_sprinting = false
var is_crouching = false

onready var player_head = $PlayerHead
onready var player_ray_cast = $PlayerHead/PlayerRayCast
onready var player_camera = $PlayerHead/PlayerCamera
onready var player_light = $PlayerHead/PlayerLight

const OBJECT_THROW_FORCE = 120
const OBJECT_GRAB_DISTANCE = 7
const OBJECT_GRAB_RAY_DISTANCE = 10
var grabbed_object = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_input(delta)
	process_view_input(delta)
	process_movement(delta)
	process_ray_cast()

func process_input(delta):
	# Grabbin and throwing objects
	if Input.is_action_just_pressed("fire"):
		if grabbed_object == null:
			var state = get_world().direct_space_state
			var center_position = get_viewport().size / 2
			var ray_from = player_camera.project_ray_origin(center_position)
			var ray_to = ray_from + player_camera.project_ray_normal(center_position) * OBJECT_GRAB_RAY_DISTANCE
			var ray_result = state.intersect_ray(ray_from, ray_to, [self])
			if ray_result != null:
				if ray_result.size() != 0:
					if ray_result["collider"] is RigidBody:
						grabbed_object = ray_result["collider"]
						grabbed_object.mode = RigidBody.MODE_STATIC
						grabbed_object.collision_layer = 0
						grabbed_object.collision_mask = 0
		else:
			grabbed_object.mode = RigidBody.MODE_RIGID
			grabbed_object.collision_layer = 1
			grabbed_object.collision_mask = 1
			grabbed_object.apply_central_impulse(-player_camera.global_transform.basis.z.normalized() * OBJECT_THROW_FORCE)
			grabbed_object = null
	if grabbed_object != null:
		grabbed_object.global_transform.origin = player_camera.global_transform.origin + ( -player_camera.global_transform.basis.z.normalized() * OBJECT_GRAB_DISTANCE )

	# Walking
	direction = Vector3()
	var head_x_form = player_head.get_global_transform()
	var input_movement_vector = Vector2()

	# Movement from kayboard
	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += Input.get_action_strength("movement_forward")
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= Input.get_action_strength("movement_backward")
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x += Input.get_action_strength("movement_left")
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x -= Input.get_action_strength("movement_right")

	# Movement from joystick
	#if Input.get_connected_joypads().size() > 0:
	#	var joypad_vec = Vector2(0,0)
	#	match globals.OS_NAME:
	#		"Windows":
	#			joypad_vec = Vector2(Input.get_joy_axis(0,0), -Input.get_joy_axis(0,1))
	#		"X11":
	#			joypad_vec = Vector2(Input.get_joy_axis(0,1), Input.get_joy_axis(0,2))
	#		"OSX":
	#			joypad_vec = Vector2(Input.get_joy_axis(0,1), Input.get_joy_axis(0,2))
	#	if joypad_vec.length() < JOYPAD_DEADZONE:
	#		joypad_vec = Vector2(0,0)
	#	else:
	#		joypad_vec = joypad_vec.normalized() * ((joypad_vec.length() - JOYPAD_DEADZONE)/(1 - JOYPAD_DEADZONE))
	#		input_movement_vector += joypad_vec

	# Basis vectors are normalized 
	input_movement_vector = input_movement_vector.normalized()
	direction += head_x_form.basis.z * input_movement_vector.y
	direction += head_x_form.basis.x * input_movement_vector.x

	# Sprinting
	if Input.is_action_pressed("movement_sprint"):
		is_sprinting = true
	else:
		is_sprinting = false

	# Flashlight
	if Input.is_action_just_pressed("flashlight"):
		if player_light.is_visible_in_tree():
			player_light.hide()
		else:
			player_light.show()

	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("movement_jump"):
			velocity.y = JUMP_SPEED

	# Capturing / Freeing cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func process_view_input(delta):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return

	var joypad_vec = Vector2()
	if Input.get_connected_joypads().size() > 0:
		match globals.OS_NAME:
			"Windows":
				joypad_vec = Vector2(Input.get_joy_axis(0,2), Input.get_joy_axis(0,3))
			"X11":
				joypad_vec = Vector2(Input.get_joy_axis(0,3), Input.get_joy_axis(0,4))
			"OSX":
				joypad_vec = Vector2(Input.get_joy_axis(0,3), Input.get_joy_axis(0,4))
		
		if joypad_vec.length() < JOYPAD_DEADZONE:
			joypad_vec = Vector2(0,0)
		else:
			joypad_vec = joypad_vec.normalized() * (( joypad_vec.length() - JOYPAD_DEADZONE ) / ( 1 - JOYPAD_DEADZONE ))

	player_head.rotate_x(deg2rad( joypad_vec.y * JOYPAD_SENSITIVITY ))
	rotate_y(deg2rad( joypad_vec.x * JOYPAD_SENSITIVITY * -1 ))
	var player_head_rotation = player_head.rotation_degrees
	player_head_rotation.x = clamp(player_head_rotation.x, -70, 70)
	player_head.rotation_degrees = player_head_rotation

func process_movement(delta):
	direction.y = 0
	direction = direction.normalized()
	
	velocity.y += delta * GRAVITY
	
	var horizontal_velocity = velocity
	horizontal_velocity.y = 0
	
	var target = direction
	if is_sprinting:
		target *= MAX_SPRINT_SPEED
	else:
		target *= MAX_WALK_SPEED
	
	var accel
	if direction.dot(horizontal_velocity) > 0:
		if is_sprinting:
			accel = SPRINT_ACCEL
		else:
			accel = WALK_ACCEL
	else:
		accel = DEACCEL
	
	horizontal_velocity = horizontal_velocity.linear_interpolate(target, accel * delta)
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	velocity = move_and_slide(velocity, Vector3(0,1,0), 0.5, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			player_head.rotate_x(deg2rad(event.relative.y * config_manager.config_data.mouse.mouse_sensitivity_x))
			self.rotate_y(deg2rad(event.relative.x * config_manager.config_data.mouse.mouse_sensitivity_y * -1))
			var player_head_rotation = player_head.rotation_degrees
			player_head_rotation.x = clamp(player_head_rotation.x, -55, 55)
			player_head.rotation_degrees = player_head_rotation
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_WHEEL_UP or event.button_index == BUTTON_WHEEL_DOWN:
				if event.button_index == BUTTON_WHEEL_UP:
					mouse_scroll_value += config_manager.config_data.mouse.mouse_sensitivity_scroll
				elif event.button_index == BUTTON_WHEEL_DOWN:
					mouse_scroll_value -= config_manager.config_data.mouse.mouse_sensitivity_scroll
				print(mouse_scroll_value, int(round(mouse_scroll_value)))

func process_ray_cast():
	if player_ray_cast.is_colliding():
		print(player_ray_cast.get_collider())

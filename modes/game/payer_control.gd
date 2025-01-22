class_name PlayerController extends Node

var character_hud_scene: Resource = preload("res://character/scenes/character_hud.tscn")
var character_hud: CharacterHud

var head: CharacterHead = null

var camera: CharacterCamera3D = null
var character_spot_light_3D: CharacterSpotLight3D = null
var character_ray_cast_3D: CharacterRayCast3D = null

var steps_player: AudioStreamPlayer3D = null
var animation: CharacterAnimationPlayer = null

var navigation: NavigationAgent3D = null
var ray_cast_3d_obstacle_top: RayCast3D = null
var ray_cast_3d_obstacle_bottom: RayCast3D = null

var _mouse_mode_current: String = "ray_cast"
var mouse_mode_current: String:
	get:
		return _mouse_mode_current
	set(new_mouse_mode):
		if not new_mouse_mode in ["ray_cast", "mouse"]:
			return
		_mouse_mode_current = new_mouse_mode
		match new_mouse_mode:
			"ray_cast":
				character_ray_cast_3D.enabled = true
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			"mouse":
				character_ray_cast_3D.enabled = false
				character_ray_cast_3D.raycast_target = null
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

var _character: Character = null
var character: Character:
	get:
		return _character
	set(new_character):
		if new_character == _character:
			return
		if _character:
			camera.set_fov(ConfigManager.config_data.video.fov)
		_character = new_character
		if _character:
			print_debug("Switching to character: ", _character.name)
			head = _character.get_node("character_head")
			camera = head.get_node("character_camera_3D")
			character_spot_light_3D = head.get_node("character_spot_light_3D")
			character_ray_cast_3D = head.get_node("character_ray_cast_3D")
			steps_player = _character.get_node("character_steps_audio_stream_player_3D")
			animation = _character.get_node("character_animation_player")
			navigation = _character.get_node("navigation_agent_3d")
			ray_cast_3d_obstacle_top = _character.get_node("ray_cast_3d_obstacle_top")
			ray_cast_3d_obstacle_bottom = _character.get_node("ray_cast_3d_obstacle_bottom")
			set_hud()
		else:
			print_debug("Switching to character: null")
			head = null
			camera = null
			character_spot_light_3D = null
			character_ray_cast_3D = null
			steps_player = null
			animation = null
			navigation = null
			ray_cast_3d_obstacle_top = null
			ray_cast_3d_obstacle_bottom = null

func set_hud() -> void:
	character_hud = character_hud_scene.instantiate()
	character_hud.character = character
	character_hud.character_ray_cast_3D = character_ray_cast_3D
	add_child(character_hud)

func _ready() -> void:
	if is_inside_tree() and not is_in_group("character_controlers"):
		add_to_group("character_controlers", true)

func _process(_delta: float) -> void:
	if not character:
		return
	# CAMERA
	camera.set_fov(camera.fov + Input.get_axis("zoom_in", "zoom_out"))

func _physics_process(delta: float) -> void:
	if not character:
		return
	# Get look inputs
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		pass
	elif Input.is_action_pressed("player_mode_action"):
		pass
	else:
		head.input_look_vector = PlayerUtils.get_look_vector()
		head.freelook()

	# Get movement inputs
	_character.input_movement_vector = PlayerUtils.get_move_vector()
	if _character.is_on_floor():
		# Jumping
		if Input.is_action_just_pressed("player_movement_jump"):
			_character.is_jumping = true
			_character.velocity.y = _character.JUMP_SPEED * Input.get_action_strength("player_movement_jump")

		# Sprinting
		if Input.is_action_just_pressed("player_movement_sprint") and ( _character.stamina >= _character.stamina_max / 2.0 ):
			_character.is_sprinting = ( _character.input_movement_vector.y > 0 )
			if _character.is_crouching:
				_character.is_crouching = false
				animation.un_crouch()
		elif _character.stamina <= 0 :
			_character.is_sprinting = false
		# Sprint only forward
		_character.is_sprinting = _character.is_sprinting and ( _character.input_movement_vector.y > 0 )

		# Crouching
		if _character.is_on_ceiling() and not _character.is_crouching:
			_character.is_crouching = true
			_character.is_sprinting = false
			animation.crouch()

	if Input.is_action_just_pressed("player_movement_crouch"):
		if _character.is_crouching:
			_character.is_crouching = false
			animation.un_crouch()
		else:
			_character.is_crouching = true
			_character.is_sprinting = false
			animation.crouch()

	_character.movement(delta)

func _unhandled_input(event: InputEvent) -> void:
	if not character:
		return
	# Raycast
	if not is_instance_valid(character_ray_cast_3D.raycast_target):
		return
	if character_ray_cast_3D.raycast_target_distance > character_ray_cast_3D.OBJECT_INTERACT_DISTANCE:
		return
	if not "interactive" in character_ray_cast_3D.raycast_target:
		return
	if not character_ray_cast_3D.raycast_target.interactive:
		return

	if character_ray_cast_3D.raycast_target is BaseScreen:
		character_ray_cast_3D.active_screen = character_ray_cast_3D.raycast_target
		if ( event is InputEventMouse ):
			if character_ray_cast_3D.active_screen.has_method("_mouse_input_event"):
				character_ray_cast_3D.active_screen._mouse_input_event(camera, event, character_ray_cast_3D.raycast_collision_point, Vector3(), int())
		if event.is_action_pressed("player_secondary_action") and character_ray_cast_3D.active_screen.has_signal("mouse_exited_area"):
			mouse_mode_current = "mouse"
			character_ray_cast_3D.active_screen.mouse_exited_area.connect(_on_interaction_end)
		return

	if ( character_ray_cast_3D.raycast_target is BaseProp ) or ( character_ray_cast_3D.raycast_target is BaseDoor ):
		if event.is_action_pressed("player_primary_action"):
			character_ray_cast_3D.raycast_primary_action.emit()
		elif event.is_action_pressed("player_secondary_action"):
			character_ray_cast_3D.raycast_secondary_action.emit()
		elif event.is_action_pressed("player_mode_action"):
			character_ray_cast_3D.raycast_mode_action.emit()
		elif event.is_action_pressed("player_in_action"):
			character_ray_cast_3D.raycast_in_action.emit()
		elif event.is_action_pressed("player_out_action"):
			character_ray_cast_3D.raycast_out_action.emit()


func _unhandled_key_input(event: InputEvent) -> void:
	if not character:
		return
	# CAMERA
	if event.is_action_pressed("util_camera_switch"):
		camera.camera_position_selected += 1

	if event.is_action_pressed("zoom_reset"):
		camera.set_fov(ConfigManager.config_data.video.fov)

	# FLASHLIGHT
	if event.is_action_pressed("player_flashlight"):
		if character_spot_light_3D.is_visible_in_tree():
			character_spot_light_3D.hide()
		else:
			character_spot_light_3D.show()

	# Raycast
	if event.is_action_released("mouse_mode_switch"):
		match mouse_mode_current:
			"ray_cast":
				mouse_mode_current = "mouse"
			"mouse":
				mouse_mode_current = "ray_cast"

func _on_interaction_end() -> void:
	character_ray_cast_3D.active_screen.mouse_exited_area.disconnect(_on_interaction_end)
	character_ray_cast_3D.active_screen = null
	mouse_mode_current = "ray_cast"

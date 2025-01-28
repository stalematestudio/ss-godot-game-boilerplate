class_name NPCController extends Node3D

# TODO: get logic from https://github.com/stalematestudio/ss-godot-game-boilerplate/blob/18e4bb579b1d9bedbe5d4cad6505a5b6382d1ebb/modes/game/non_player_control.gd

@onready var character: Character = get_parent()
@onready var character_hud: CharacterHud = character.get_node("character_hud")
@onready var head: CharacterHead = character.get_node("character_head")

@onready var camera: CharacterCamera3D = head.get_node("character_camera_3D")
@onready var character_spot_light_3D: CharacterSpotLight3D = head.get_node("character_spot_light_3D")
@onready var character_ray_cast_3D: CharacterRayCast3D = head.get_node("character_ray_cast_3D")

@onready var steps_player: AudioStreamPlayer3D = character.get_node("character_steps_audio_stream_player_3D")

@onready var navigation: CharacterNavigationAgent3D = character.get_node("navigation_agent_3d")
@onready var ray_cast_3d_obstacle_top: CharacterRayCast3DObstacle = character.get_node("ray_cast_3d_obstacle_top")
@onready var ray_cast_3d_obstacle_bottom: CharacterRayCast3DObstacle = character.get_node("ray_cast_3d_obstacle_bottom")

const State = {
	IDLE = 0,
	TRACK = 1,
}
var state: int:
	get:
		return state
	set(new_state):
		if new_state in State.values():
			state = new_state

var target: Node3D
var target_last_known_possition: Vector3
var target_line_of_sight: bool:
	get:
		if not character_ray_cast_3D.is_colliding():
			return false
		if character_ray_cast_3D.get_collider() == target:
			return true
		return false

func _ready() -> void:
	if is_inside_tree() and not is_in_group("character_controlers"):
		add_to_group("character_controlers", true)
	character_ray_cast_3D.raycast_target_changed.connect(on_character_ray_cast_3D_raycast_target_changed)

func _process(_delta: float) -> void:
	if character.is_player_controlled:
		return
	character_spot_light_3D.on = true

func _physics_process(delta: float) -> void:
	if character.is_player_controlled:
		return

	match state:
		State.IDLE:
			do_idle()
		State.TRACK:
			do_track()
		_:
			pass

	if character.is_on_floor():
		# Jumping
		if ray_cast_3d_obstacle_top.can:
			character.is_jumping = true
			character.velocity.y = character.JUMP_SPEED # * ray_cast_3d_obstacle_top clearance to get jump strength

		# Sprinting
		# if Input.is_action_just_pressed("player_movement_sprint") and ( _character.stamina >= _character.stamina_max / 2.0 ):
		# 	_character.is_sprinting = ( _character.input_movement_vector.y > 0 )
		# 	if _character.is_crouching:
		# 		_character.is_crouching = false
		# elif _character.stamina <= 0 :
		# 	_character.is_sprinting = false
		# # Sprint only forward
		# _character.is_sprinting = _character.is_sprinting and ( _character.input_movement_vector.y > 0 )

		# Crouching
		if character.is_on_ceiling() and not character.is_crouching:
			character.is_crouching = true
			character.is_sprinting = false

		character.is_crouching = ray_cast_3d_obstacle_bottom.can

	character.movement(delta)

func on_character_ray_cast_3D_raycast_target_changed(raycast_target: Node) -> void:
	if character.is_player_controlled:
		return
	if raycast_target:
		print_debug(raycast_target.name)
	if ( raycast_target is Character ) and ( raycast_target.is_player_controlled ):
		target = raycast_target
		state = State.TRACK

func do_idle() -> void:
	character.input_movement_vector = Vector2.ZERO

func do_track() -> void:
	if target_line_of_sight:
		head.rotate_and_look_at(target)
		target_last_known_possition = target.global_position
	else:
		head.reset_rotation()

	navigation.target_position = target_last_known_possition
	var target_direction = to_local(navigation.get_next_path_position())
	character.input_movement_vector = Vector2(
		target_direction.x,
		target_direction.z,
	)

func save_data() -> Dictionary:
	return {}

func load_data(_data: Dictionary) -> void:
	pass

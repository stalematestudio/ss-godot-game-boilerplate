class_name NPCController extends Node3D

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
	FOLLOW = 2,
}
var state: int:
	get:
		return state
	set(new_state):
		if new_state in State.values():
			state = new_state

var target: Node3D = null
var target_last_known_possition: Vector3 = Vector3.ZERO

var target_line_of_sight_interval: float = 5
var target_line_of_sight_timer: float = target_line_of_sight_interval
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
	character_ray_cast_3D.target_changed.connect(on_character_ray_cast_3D_raycast_target_changed)

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
			do_track(delta)
		State.FOLLOW:
			do_follow()
		_:
			do_reset()

	if character.is_on_floor():
		# Jumping
		if character.is_stuck and ray_cast_3d_obstacle_top.can:
			character.jump(character.ray_cast_3d_obstacle_top.jump_strength)

		# Sprinting
		if character.stamina >= character.stamina_max / 2.0:
			character.is_sprinting = character.input_movement_vector.y > 0
			if character.is_crouching:
				character.is_crouching = false
		elif character.stamina <= 0 :
			character.is_sprinting = false

		# Crouching
		character.is_crouching = ray_cast_3d_obstacle_bottom.can

	character.movement(delta)

func on_character_ray_cast_3D_raycast_target_changed(raycast_target: Node) -> void:
	if character.is_player_controlled:
		return
	if raycast_target:
		# print_debug(raycast_target.name)
		if ( raycast_target is Character ) and ( raycast_target.is_player_controlled ):
			target = raycast_target
			state = State.FOLLOW

func do_idle() -> void:
	character.input_movement_vector = Vector2.ZERO
	head.reset_rotation()

func do_track(delta: float) -> void:
	if target_line_of_sight:
		target_line_of_sight_timer = target_line_of_sight_interval
		target_last_known_possition = target.global_position
	else:
		target_line_of_sight_timer -= delta

	if target_line_of_sight_timer > 0:
		head.rotate_and_look_at_object(target)
	else:
		head.rotate_and_look_at_vector(target_last_known_possition)

	navigation.target_position = target_last_known_possition
	var target_direction = to_local(navigation.get_next_path_position())
	character.input_movement_vector = Vector2(
		target_direction.x,
		target_direction.z,
	)

	if navigation.is_navigation_finished():
		target = null
		state = State.IDLE

func do_follow() -> void:
	head.rotate_and_look_at_object(target)
	var in_front_of_target: Vector3 = target.to_global(Vector3(0,0,1.5))
	if global_position.distance_to(in_front_of_target) > 0.1:
		navigation.target_position = in_front_of_target
		var target_direction = to_local(navigation.get_next_path_position())
		character.input_movement_vector = Vector2(
			target_direction.x,
			target_direction.z,
		)

func do_reset() -> void:
	target = null
	state = State.IDLE

func save_data() -> Dictionary:
	return {}

func load_data(_data: Dictionary) -> void:
	pass

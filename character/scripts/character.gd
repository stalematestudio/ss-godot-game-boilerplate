class_name Character extends CharacterBody3D

# TODO: Make gravity dynamic
var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

# TODO: Move player stats to a stats component and make them dynamic
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

signal is_player_controlled_changed(is_player_controlled: bool)

var is_player_controllable: bool = true
var _is_player_controlled: bool = false
@export var is_player_controlled: bool:
	get:
		return _is_player_controlled
	set(new_is_player_controlled):
		if _is_player_controlled == new_is_player_controlled:
			return
		_is_player_controlled = new_is_player_controlled
		is_player_controlled_changed.emit(_is_player_controlled)

var is_stuck: bool:
	get:
		return ( velocity.z == 0 ) and ( input_movement_vector.y != 0 )

var is_jumping: bool = false
var is_sprinting: bool  = false

var _is_crouching: bool  = false
var is_crouching: bool:
	get:
		return _is_crouching
	set(new_is_crouching):
		if _is_crouching == new_is_crouching:
			return
		_is_crouching = new_is_crouching
		if _is_crouching:
			animation.crouch()
		else:
			animation.un_crouch()

@export var interactive: bool = true
var interactor: CharacterRayCast3D = null
var primary_action: String:
	get:
		return "HI"

var secondary_action: String:
	get:
		return "BYE"

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

@onready var ray_cast_3d_obstacle_top: CharacterRayCast3DObstacle = $ray_cast_3d_obstacle_top
@onready var ray_cast_3d_obstacle_bottom: CharacterRayCast3DObstacle = $ray_cast_3d_obstacle_bottom

@export var npc_control_scene: Resource = preload("res://components/npc_control/npc_control.tscn")
@onready var npc_control: NPCController = npc_control_scene.instantiate()

@onready var outline_mesh_array: Array[Node] = find_children("outline_mesh*", "MeshInstance3D")

func _ready() -> void:
	if is_inside_tree() and not is_in_group("chracters"):
		add_to_group("chracters", true)
	if is_inside_tree() and not is_in_group("game_objects_savable"):
		add_to_group("game_objects_savable", true)
	
	mouse_entered.connect(highlight)
	mouse_exited.connect(un_highlight)
	
	add_child(npc_control)

func jump(strength: float = 1) -> void:
	if is_on_floor():
		is_jumping = true
		velocity.y = JUMP_SPEED * strength


func movement(delta: float) -> void:
	# Basis vectors are normalized
	input_movement_vector_magnitude = min(input_movement_vector.length(), 1)
	input_movement_vector = input_movement_vector.normalized()

	ray_cast_3d_obstacle_top.input_movement_vector = input_movement_vector
	ray_cast_3d_obstacle_bottom.input_movement_vector = input_movement_vector

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
	else:
		# Mid air movement
		horizontal_velocity = horizontal_velocity.lerp(movement_target_speed, movement_accel * delta)

	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z

	# Sprint only forward
	is_sprinting = is_sprinting and ( input_movement_vector.y > 0 )

	# Crouching
	if is_on_ceiling() and not is_crouching:
		is_crouching = true
		is_sprinting = false

	move_and_slide()

	input_movement_vector = Vector2.ZERO

	# Steps audio control needs to be moved out of here
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
	"player_health": health,
	"player_stamina": stamina,
	"is_jumping": is_jumping,
	"is_sprinting": is_sprinting,
	"is_crouching": is_crouching,
	"position": position,
	"rotation":	rotation,
	"velocity" : velocity,
	"head": head.save_data(),
	"npc_control": npc_control.save_data(),
	"is_player_controlled": is_player_controlled,
	}

func load_data(data: Dictionary) -> void:
	name = data.name if data.has("name") else name
	health = data.player_health if data.has("player_health") else health
	stamina = data.player_stamina if data.has("player_stamina") else stamina
	is_jumping = data.is_jumping if data.has("is_jumping") else is_jumping
	is_sprinting = data.is_sprinting if data.has("is_sprinting") else is_sprinting
	_is_crouching = data.is_crouching if data.has("is_crouching") else _is_crouching
	if _is_crouching:
		animation.imediate_crouch()
	else:
		animation.imediate_un_crouch()
	position = Helpers.string_to_vector(data.position) if data.position is String else data.position
	rotation = Helpers.string_to_vector(data.rotation) if data.rotation is String else data.rotation
	velocity = Helpers.string_to_vector(data.velocity) if data.velocity is String else data.velocity
	head.load_data(data.head)
	npc_control.load_data(data.npc_control)
	is_player_controlled = data.is_player_controlled if data.has("is_player_controlled") else is_player_controlled

func activate(new_interactor: CharacterRayCast3D) -> void:
	interactor = new_interactor
	if not interactor.raycast_target_changed.is_connected(_on_interactor_raycast_target_changed):
		interactor.raycast_target_changed.connect(_on_interactor_raycast_target_changed)
	if not interactor.raycast_primary_action.is_connected(_on_interactor_raycast_primary_action):
		interactor.raycast_primary_action.connect(_on_interactor_raycast_primary_action)
	if not interactor.raycast_secondary_action.is_connected(_on_interactor_raycast_secondary_action):
		interactor.raycast_secondary_action.connect(_on_interactor_raycast_secondary_action)
	if not interactor.raycast_in_action.is_connected(_on_interactor_raycast_in_action):	
		interactor.raycast_in_action.connect(_on_interactor_raycast_in_action)
	if not interactor.raycast_out_action.is_connected(_on_interactor_raycast_out_action):
		interactor.raycast_out_action.connect(_on_interactor_raycast_out_action)
	highlight()


func deactivate() -> void:
	if interactor:
		if interactor.raycast_target_changed.is_connected(_on_interactor_raycast_target_changed):
			interactor.raycast_target_changed.disconnect(_on_interactor_raycast_target_changed)
		if interactor.raycast_primary_action.is_connected(_on_interactor_raycast_primary_action):
			interactor.raycast_primary_action.disconnect(_on_interactor_raycast_primary_action)
		if interactor.raycast_secondary_action.is_connected(_on_interactor_raycast_secondary_action):
			interactor.raycast_secondary_action.disconnect(_on_interactor_raycast_secondary_action)
		if interactor.raycast_in_action.is_connected(_on_interactor_raycast_in_action):
			interactor.raycast_in_action.disconnect(_on_interactor_raycast_in_action)
		if interactor.raycast_out_action.is_connected(_on_interactor_raycast_out_action):
			interactor.raycast_out_action.disconnect(_on_interactor_raycast_out_action)
		interactor = null
	un_highlight()


func _on_interactor_raycast_target_changed(new_target: Node) -> void:
	if self == new_target:
		return
	deactivate()

func _on_interactor_raycast_primary_action() -> void:
	pass

func _on_interactor_raycast_secondary_action() -> void:
	pass

func _on_interactor_raycast_in_action() -> void:
	pass

func _on_interactor_raycast_out_action() -> void:
	pass

func highlight() -> void:
	if is_player_controlled or ( not interactor ) or ( not interactor.character_instance.is_player_controlled ):
		return
	for outline_mesh in outline_mesh_array:
		outline_mesh.show()

func un_highlight() -> void:
	for outline_mesh in outline_mesh_array:
		outline_mesh.hide()

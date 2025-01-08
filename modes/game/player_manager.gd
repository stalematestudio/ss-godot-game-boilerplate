class_name PlayerManager extends Node

@export var player_character_scene: PackedScene = preload("res://player/scenes/player_character.tscn")
@onready var player_character: PlayerCharacter = player_character_scene.instantiate()

@onready var player_head: PlayerHead = player_character.find_child("PlayerHead")
@onready var player_camera: PlayerCamera = player_character.find_child("PlayerCamera")
@onready var player_light: PlayerLight = player_character.find_child("PlayerLight")
@onready var player_raycast: PlayerRayCast3D = player_character.find_child("PlayerRayCast")

@export var player_hud_scene: PackedScene = preload("res://player/scenes/player_hud.tscn")
@onready var player_hud: PlayerHud = player_hud_scene.instantiate()

var initial_player_health: float = 100
var initial_player_stamina: float = 100

var initial_player_is_jumping: bool = bool()
var initial_player_is_sprinting: bool  = bool()
var initial_player_is_crouching: bool  = bool()

var initial_player_position: Vector3 = Vector3()
var initial_player_rotation: Vector3 = Vector3()
var initial_player_velocity: Vector3 = Vector3()
var initial_player_rotation_head: Vector3 = Vector3()

var mouse_mode_current: String = "ray_cast"

func _ready() -> void:
	player_hud.player_character = player_character
	player_raycast.raycast_target_changed.connect(player_hud._on_raycast_target_changed)
	player_raycast.player_manager = self
	player_raycast.player_camera = player_camera

	add_child(player_character)
	add_child(player_hud)

func save_data() -> Dictionary:
	return {"player":{
		"player_health": player_character.player_health,
		"player_stamina":player_character.player_stamina,
		"is_jumping": player_character.is_jumping,
		"is_sprinting": player_character.is_sprinting,
		"is_crouching": player_character.is_crouching,
		"position": player_character.position,
		"rotation":	player_character.rotation,
		"velocity" : player_character.velocity,
		"rotation_head": player_head.rotation_degrees,
		"mouse_mode": mouse_mode_current,
	}} if is_instance_valid(player_character) else {"player":{
		"player_health": initial_player_health,
		"player_stamina":initial_player_stamina,
		"is_jumping": initial_player_is_jumping,
		"is_sprinting": initial_player_is_sprinting,
		"is_crouching": initial_player_is_crouching,
		"position": initial_player_position,
		"rotation":	initial_player_rotation,
		"velocity": initial_player_velocity,
		"rotation_head": initial_player_rotation_head,
		"mouse_mode": mouse_mode_current,
	}}

func load_data(player: Dictionary = Dictionary()) -> void:
	player_character.player_health = player.player_health if player.has("player_health") else initial_player_health
	player_character.player_stamina = player.player_stamina if player.has("player_stamina") else initial_player_stamina
	player_character.is_jumping = player.is_jumping if player.has("is_jumping") else initial_player_is_jumping
	player_character.is_sprinting = player.is_sprinting if player.has("is_sprinting") else initial_player_is_sprinting
	# TODO: crouching doesn't work on load game
	player_character.is_crouching = player.is_crouching if player.has("is_crouching") else initial_player_is_crouching
	player_character.position = Helpers.string_to_vector(player.position) if player.has("position") else initial_player_position
	player_character.rotation = Helpers.string_to_vector(player.rotation) if player.has("rotation") else initial_player_rotation
	player_character.velocity = Helpers.string_to_vector(player.velocity) if player.has("velocity") else initial_player_velocity
	player_head.rotation_degrees = Helpers.string_to_vector(player.rotation_head) if player.has("rotation_head") else initial_player_rotation_head

func _input(event: InputEvent) -> void:
	if event.is_action_released("mouse_mode_switch"):
		interaction_switch()

func interaction_switch() -> void:
	if mouse_mode_current == "ray_cast":
		interaction_mouse()
	else:
		interaction_ray_cast()

func interaction_ray_cast() -> void:
	mouse_mode_current = "ray_cast"
	player_raycast.enabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func interaction_mouse() -> void:
	mouse_mode_current = "mouse"
	player_raycast.enabled = false
	player_raycast.raycast_target = null
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

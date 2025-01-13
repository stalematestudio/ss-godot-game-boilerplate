class_name PlayerManager extends Node

@onready var game: GameplayManager = get_parent()

var initial_character_health: float = 100
var initial_character_stamina: float = 100

var initial_character_is_jumping: bool = bool()
var initial_character_is_sprinting: bool  = bool()
var initial_character_is_crouching: bool  = bool()

var initial_character_position: Vector3 = Vector3()
var initial_character_rotation: Vector3 = Vector3()
var initial_character_velocity: Vector3 = Vector3()
var initial_character_rotation_head: Vector3 = Vector3()

@export var character_scene: PackedScene = preload("res://character/scenes/character.tscn")
@onready var character: Character = character_scene.instantiate()

@onready var character_head: CharacterHead = character.find_child("character_head")
@onready var character_camera: CharacterCamera3D = character.find_child("character_camera_3D")
@onready var character_raycast: CharacterRayCast3D = character.find_child("character_ray_cast_3D")

@export var character_hud_scene: PackedScene = preload("res://character/scenes/character_hud.tscn")
@onready var character_hud: CharacterHud = character_hud_scene.instantiate()

func _ready() -> void:
	if is_inside_tree() and not is_in_group("game_managers"):
		add_to_group("game_managers", true)

	character_hud.character = character

	character_raycast.character_instance = character
	character_raycast.character_camera = character_camera
	character_raycast.raycast_target_changed.connect(character_hud._on_raycast_target_changed)

	add_child(character)
	add_child(character_hud)

func save_data() -> Dictionary:
	return {"player":{
		"player_health": character.health,
		"player_stamina": character.stamina,
		"is_jumping": character.is_jumping,
		"is_sprinting": character.is_sprinting,
		"is_crouching": character.is_crouching,
		"position": character.position,
		"rotation":	character.rotation,
		"velocity" : character.velocity,
		"rotation_head": character_head.rotation_degrees,
	}} if is_instance_valid(character) else {"player":{
		"player_health": initial_character_health,
		"player_stamina":initial_character_stamina,
		"is_jumping": initial_character_is_jumping,
		"is_sprinting": initial_character_is_sprinting,
		"is_crouching": initial_character_is_crouching,
		"position": initial_character_position,
		"rotation":	initial_character_rotation,
		"velocity": initial_character_velocity,
		"rotation_head": initial_character_rotation_head,
	}}

func load_data(player: Dictionary = Dictionary()) -> void:
	character.health = player.player_health if player.has("player_health") else initial_character_health
	character.stamina = player.player_stamina if player.has("player_stamina") else initial_character_stamina
	character.is_jumping = player.is_jumping if player.has("is_jumping") else initial_character_is_jumping
	character.is_sprinting = player.is_sprinting if player.has("is_sprinting") else initial_character_is_sprinting
	# TODO: crouching doesn't work on load game
	character.is_crouching = player.is_crouching if player.has("is_crouching") else initial_character_is_crouching
	character.position = Helpers.string_to_vector(player.position) if player.has("position") else initial_character_position
	character.rotation = Helpers.string_to_vector(player.rotation) if player.has("rotation") else initial_character_rotation
	character.velocity = Helpers.string_to_vector(player.velocity) if player.has("velocity") else initial_character_velocity
	character_head.rotation_degrees = Helpers.string_to_vector(player.rotation_head) if player.has("rotation_head") else initial_character_rotation_head

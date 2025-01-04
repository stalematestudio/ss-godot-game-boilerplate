class_name PlayerManager extends Node

@export var player_character_scene: PackedScene = preload("res://player/scenes/player_character.tscn")
@onready var player_character: PlayerCharacter = player_character_scene.instantiate()
@onready var player_head: PlayerHead = player_character.find_child("PlayerHead")

@export var player_hud_scene: PackedScene = preload("res://player/scenes/player_hud.tscn")
@onready var player_hud: PlayerHud = player_hud_scene.instantiate()

var initial_player_position: Vector3 = Vector3()
var initial_player_rotation: Vector3 = Vector3()
var initial_player_rotation_head: Vector3 = Vector3()

func _ready() -> void:
	player_hud.player_character = player_character
	
	add_child(player_character)
	add_child(player_hud)

func save_data() -> Dictionary:
	return {"player":{
		"position": player_character.position,
		"rotation":	player_character.rotation,
		"rotation_head": player_head.rotation_degrees,
	}} if is_instance_valid(player_character) else {"player":{
		"position": initial_player_position,
		"rotation":	initial_player_rotation,
		"rotation_head": initial_player_rotation_head,
	}}

func load_data(player: Dictionary = Dictionary()) -> void:
	player_character.position = Helpers.string_to_vector(player.position) if player.has("position") else initial_player_position
	player_character.rotation = Helpers.string_to_vector(player.rotation) if player.has("rotation") else initial_player_rotation
	player_head.rotation_degrees = Helpers.string_to_vector(player.rotation_head) if player.has("rotation_head") else initial_player_rotation_head

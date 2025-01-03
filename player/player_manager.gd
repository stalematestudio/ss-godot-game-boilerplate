class_name PlayerManager extends Node

@export var player_character_scene: PackedScene = preload("res://player/player_character.tscn")
@onready var player_character: PlayerCharacter

@export var player_hud_scene: PackedScene = preload("res://player/player_hud.tscn")
@onready var player_hud: PlayerHud


func _ready() -> void:
	spawn_player()

func save_player() -> Dictionary:
	return {
		"position": player_character.position,
		"rotation":	player_character.rotation,
		"head_rotation": player_character.player_head_rotation,
	} if is_instance_valid(player_character) else {
		"position": Vector3(),
		"rotation":	Vector3(),
		"head_rotation": float(),
	}

func player_character_exists() -> bool:
	return is_instance_valid(player_character)

func spawn_player(position: Vector3 = Vector3(), rotation: Vector3 = Vector3(), head_rotation: float = float()) -> void:
	if not is_instance_valid(player_character):
		player_character = player_character_scene.instantiate()
		add_child(player_character)
	if not is_instance_valid(player_hud):
		player_hud = player_hud_scene.instantiate()
		player_hud.player_character = player_character
		add_child(player_hud)
	player_character.position = position
	player_character.rotation = rotation
	# player_character.player_head_rotation = head_rotation

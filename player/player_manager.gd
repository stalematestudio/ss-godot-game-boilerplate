class_name PlayerManager extends Node

@export var player_character_scene: PackedScene = preload("res://player/player_character.tscn")
@onready var player_character: PlayerCharacter

@export var player_hud_scene: PackedScene = preload("res://player/player_hud.tscn")
@onready var player_hud: PlayerHud

var player_character_state: Dictionary:
	get:
		return {
			"position": player_character.position,
			"rotation": player_character.rotation,
		} if is_instance_valid(player_character) else {
			"position": Vector3(),
			"rotation": Vector3(),
		}
	set(char_state):
		if is_instance_valid(player_character):
			player_character.position = char_state.position
			player_character.rotation = char_state.rotation


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_character = player_character_scene.instantiate()
	player_hud = player_hud_scene.instantiate()

	player_hud.player_character = player_character

	add_child(player_character)
	add_child(player_hud)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


class_name PlayerManager extends Node

@export var player_character_scene: PackedScene = preload("res://player/player_character.tscn")
@onready var player_character: PlayerCharacter

@export var player_hud_scene: PackedScene = preload("res://player/player_hud.tscn")
@onready var player_hud: PlayerHud

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

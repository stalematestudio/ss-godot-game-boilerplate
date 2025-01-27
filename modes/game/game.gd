class_name GameplayManager extends Node

@onready var world_manager: WorldManager = get_node("world_manager")
@onready var maps_manager: MapsManager = get_node("maps_manager")
@onready var npc_manager: NPCManager = get_node("npc_manager")

@onready var player_control: PlayerController = get_node("player_control")

@onready var game_time: float = 0.0
@onready var game_difficulty: String = "normal"

var game_data: Dictionary = {}

func _ready() -> void:
	GameManager.save_game.connect(_on_save_game)
	GameManager.load_game.connect(_on_load_game)
	_on_load_game()

func  _process(delta: float) -> void:
	game_time += delta

func _on_save_game() -> void:
	var img = get_viewport().get_texture().get_image()
	img.resize(320, 180)
	game_data.merge({"game": {
		"time": game_time,
		"difficulty": game_difficulty,
		"thumbnail": Marshalls.raw_to_base64(img.save_png_to_buffer()),
	}}, true)
	game_data.merge(world_manager.save_data(), true)
	game_data.merge(maps_manager.save_data(), true)
	game_data.merge(npc_manager.save_data(), true)
	ProfileManager.save_game(game_data)

func _on_load_game() -> void:
	game_data = ProfileManager.load_game(ProfileManager.game_data_path)
	game_time = game_data.game.time if "time" in game_data.game else game_time
	game_difficulty = game_data.game.difficulty if "difficulty" in game_data.game else game_difficulty

	world_manager.load_data(game_data.world if game_data.has("world") else Dictionary())
	maps_manager.load_data(game_data.maps if game_data.has("maps") else Dictionary())
	npc_manager.load_data(game_data.npcs if game_data.has("npcs") else Dictionary())

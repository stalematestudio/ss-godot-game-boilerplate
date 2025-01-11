class_name GameplayManager extends Node

@onready var world_manager: WorldManager = get_node("world_manager")
@onready var maps_manager: MapsManager = get_node("maps_manager")
@onready var player_manager: PlayerManager = get_node("player_manager")
@onready var props_manager: PropsManager = get_node("props_manager")

@onready var game_time: float = 0.0
@onready var game_difficulty: String = "normal"

func _ready() -> void:
	GameManager.save_game.connect(_on_save_game)
	GameManager.load_game.connect(_on_load_game)
	_on_load_game()

func  _process(delta: float) -> void:
	game_time += delta

func _on_save_game() -> void:
	var img = get_viewport().get_texture().get_image()
	img.resize(320, 180)
	var game_data: Dictionary = {"game": {
		"time": game_time,
		"difficulty": game_difficulty,
		"thumbnail": Marshalls.raw_to_base64(img.save_png_to_buffer()),
	}}
	game_data.merge(world_manager.save_data())
	game_data.merge(maps_manager.save_data())
	game_data.merge(player_manager.save_data())
	# game_data.merge(props_manager.save_data())
	ProfileManager.save_game(game_data)

func _on_load_game() -> void:
	var game_data: Dictionary = ProfileManager.load_game(ProfileManager.game_data_path)
	game_time = game_data.game.time if "time" in game_data.game else game_time
	game_difficulty = game_data.game.difficulty if "difficulty" in game_data.game else game_difficulty

	world_manager.load_data(game_data.world if game_data.has("world") else Dictionary())
	maps_manager.load_data(game_data.maps if game_data.has("maps") else Dictionary())
	player_manager.load_data(game_data.player if game_data.has("player") else Dictionary())
	# props_manager.load_data(game_data.props if game_data.has("props") else Dictionary())

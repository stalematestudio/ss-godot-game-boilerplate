extends Node

@export var player_scene: PackedScene = preload("res://player/player_manager.tscn")
@export var player_manager: PlayerManager
@export var player_position: Vector3 = Vector3()
@export var player_rotation: Vector3 = Vector3()

@onready var game_map: Dictionary = {
	"demo": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo",
		"position": Vector3(),
		"rotation": Vector3(),
		},
}

@onready var game_time: float = 0.0
@onready var game_difficulty: String = "normal"
@onready var game_level_loaded: String = "demo"

func _ready() -> void:
	GameManager.save_game.connect(_on_save_game)
	GameManager.load_game.connect(_on_load_game)
	_on_load_game()

func  _process(delta) -> void:
	game_time += delta

func _on_save_game() -> void:
	var game_data = []
	var img = get_viewport().get_texture().get_image()
	img.resize(320, 180)
	game_data.append({
			"game_time": game_time,
			"game_difficulty": game_difficulty,
			"game_level_loaded": game_level_loaded,
			"thumbnail": Marshalls.raw_to_base64(img.save_png_to_buffer()),
			})
	for gs_obj in get_tree().get_nodes_in_group("game_save_objects"):
		game_data.append({
				"Name" : gs_obj.name,
				"FileName" : gs_obj.get_scene_file_path(),
				"Path3D" : gs_obj.get_parent().get_path(),
				})
	ProfileManager.save_game(game_data)

func _on_load_game() -> void:
	var game_data: Array = ProfileManager.load_game(ProfileManager.game_data_path)
	game_time = game_data[0].game_time if "game_time" in game_data[0] else game_time
	game_difficulty = game_data[0].game_difficulty if "game_difficulty" in game_data[0] else game_difficulty
	game_level_loaded = game_data[0].game_level_loaded if "game_level_loaded" in game_data[0] else game_level_loaded
	
	var level: Node3D = game_map[game_level_loaded].scene.instantiate()
	level.name = game_map[game_level_loaded].name
	level.position = game_map[game_level_loaded].position
	level.rotation = game_map[game_level_loaded].rotation
	add_child(level)

	player_manager = player_scene.instantiate()
	player_manager.name = "player_manager"
	add_child(player_manager)
	player_manager.player_character_state = {
		"position": player_position,
		"rotation": player_rotation,
	}

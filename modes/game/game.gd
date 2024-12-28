extends Node

@onready var game_time: float = 0.0
@onready var game_difficulty: String = "normal"
@onready var game_level_loaded: String = ""

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
	var game_data = ProfileManager.load_game()
	game_time = game_data[0].game_time if "game_time" in game_data[0] else game_time
	game_difficulty = game_data[0].game_difficulty if "game_difficulty" in game_data[0] else game_difficulty
	game_level_loaded = game_data[0].game_level_loaded if "game_level_loaded" in game_data[0] else game_level_loaded	

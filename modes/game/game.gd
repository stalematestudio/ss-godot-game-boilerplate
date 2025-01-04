extends Node

@export var player_scene: PackedScene = preload("res://player/scenes/player_manager.tscn")
@export var player_manager: PlayerManager



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
@onready var game_levels_loaded: PackedStringArray = ["demo"]

@onready var player_position: Vector3 = Vector3()
@onready var player_rotation: Vector3 = Vector3()
@onready var player_head_rotation: float = float()

func _ready() -> void:
	GameManager.save_game.connect(_on_save_game)
	GameManager.load_game.connect(_on_load_game)
	_on_load_game()

func  _process(delta: float) -> void:
	game_time += delta


func _on_save_game() -> void:
	var game_data = []
	var img = get_viewport().get_texture().get_image()
	img.resize(320, 180)
	var player_data_dict: Dictionary = player_manager.save_player()
	game_data.append({
			"game_time": game_time,
			"game_difficulty": game_difficulty,
			"game_levels_loaded": game_levels_loaded,
			"thumbnail": Marshalls.raw_to_base64(img.save_png_to_buffer()),
			"player_position": player_data_dict.position,
			"player_rotation": player_data_dict.rotation,
			"player_head_rotation": player_data_dict.head_rotation,
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
	game_levels_loaded = game_data[0].game_levels_loaded if "game_levels_loaded" in game_data[0] else game_levels_loaded
	
	for game_level_loaded in game_levels_loaded:
		var level: Node3D = game_map[game_level_loaded].scene.instantiate()
		level.name = game_map[game_level_loaded].name
		level.position = game_map[game_level_loaded].position
		level.rotation = game_map[game_level_loaded].rotation
		add_child(level)

	if not is_instance_valid(player_manager):
		player_manager = player_scene.instantiate()
		player_manager.name = "player_manager"
		add_child(player_manager)
	player_manager.spawn_player(
		Helpers.string_to_vector(game_data[0].player_position) if "player_position" in game_data[0] else player_position,
		Helpers.string_to_vector(game_data[0].player_rotation) if "player_rotation" in game_data[0] else player_rotation,
		float(game_data[0].player_head_rotation) if "player_head_rotation" in game_data[0] else player_head_rotation,
	)

extends Node

@onready var world_manager: WorldManager = get_node("world_manager")
@onready var maps_manager: MapsManager = get_node("maps_manager")
@onready var player_manager: PlayerManager = get_node("player_manager")

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

	game_data.merge(maps_manager.save_data())
	game_data.merge(player_manager.save_data())

	var game_objects_props: Array = []
	for game_object_prop in get_tree().get_nodes_in_group("game_objects_props"):
		game_objects_props.append({
				"name" : game_object_prop.name,
				"scene" : game_object_prop.get_scene_file_path(),
				"path" : game_object_prop.get_parent().get_path(),
				"object" : var_to_bytes_with_objects(game_object_prop),
				})
	game_data.merge({"props": game_objects_props})

	ProfileManager.save_game(game_data)

func _on_load_game() -> void:
	var game_data: Dictionary = ProfileManager.load_game(ProfileManager.game_data_path)
	game_time = game_data.game.time if "time" in game_data.game else game_time
	game_difficulty = game_data.game.difficulty if "difficulty" in game_data.game else game_difficulty

	maps_manager.load_data(game_data.maps if game_data.has("maps") else Dictionary())
	player_manager.load_data(game_data.player if game_data.has("player") else Dictionary())

	# This willbe reworked for prop save/load
	# if game_data.has("player") and game_data.props:
	# 	for game_object_prop in get_tree().get_nodes_in_group("game_objects_props"):
	# 		game_object_prop.queue_free()
	# 	for game_prop in game_data.props:
	# 		var game_prop_instance = bytes_to_var_with_objects(Helpers.string_to_packed_byte_array(game_prop.object))
	# 		print_debug(game_prop_instance)
	# 		# game_prop_instance.name = game_prop.name
	# 		# get_node(game_prop.path).add_child(game_prop_instance)

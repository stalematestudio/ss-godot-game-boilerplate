extends Node

onready var game_time = 0
onready var game_difficulty = "normal"
onready var game_level_loaded = ""

func _ready():
	GameManager.connect("save_game", self, "_on_save_game")
	GameManager.connect("load_game", self, "_on_load_game")
	_on_load_game()

func  _process(delta):
	game_time += delta

func _on_save_game():
	# Save File
	var save_dir_path = ProfileManager.get_current_game_save_path()
	var save_file_path = Helpers.date_time_string() + ".save"
	var save_path = save_dir_path + save_file_path
	var save_dir = Directory.new()
	if not save_dir.dir_exists(save_dir_path):
		save_dir.make_dir_recursive(save_dir_path)
	var save_file = File.new()
	save_file.open(save_path ,File.WRITE)
	
	# Thumbnail
	var img = get_viewport().get_texture().get_data()
	img.flip_y()
	img.resize(320, 180)
	save_file.store_line(to_json({ "thumbnail": Marshalls.raw_to_base64(img.save_png_to_buffer()) }))
	# Game Data
	save_file.store_line(to_json({
			"game_time": game_time,
			"game_difficulty": game_difficulty,
			"game_level_loaded": game_level_loaded,
			}))
	
	for gs_obj in get_tree().get_nodes_in_group("game_save_objects"):
		save_file.store_line(to_json({
				"Name" : gs_obj.name,
				"FileName" : gs_obj.get_filename(),
				"Path" : gs_obj.get_parent().get_path()
				}))
	
	save_file.close()
	
	# Set last saved game
	ProfileManager.game_data_path = save_path
	ProfileManager.save_profile()


func _on_load_game():
	var game_data = ProfileManager.load_game()
	game_time = game_data.game_time if "game_time" in game_data else game_time
	game_difficulty = game_data.game_difficulty if "game_difficulty" in game_data else game_difficulty
	game_level_loaded = game_data.game_level_loaded if "game_level_loaded" in game_data else game_level_loaded
	if "game_objects" in game_data:
		for obj in game_data.game_objects:
			print(obj)

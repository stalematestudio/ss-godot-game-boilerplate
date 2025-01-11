extends Node

signal message(message)
signal save_file_deleted

@onready var save_dir_path: String = Constants.PLAYER_DATA_PATH + Constants.SAVED_GAMES_FOLDER
@onready var screenshot_dir_path: String = Constants.PLAYER_DATA_PATH + Constants.SCREEN_SHOT_FOLDER

var game_data_path: String

var save_files: PackedStringArray:
	get:
		return Helpers.list_files(save_dir_path)

func _ready() -> void:
	await get_node("/root/main").ready
	self.process_mode = Node.PROCESS_MODE_ALWAYS

	if not DirAccess.dir_exists_absolute(save_dir_path):
		DirAccess.make_dir_recursive_absolute(save_dir_path)
	
	if not DirAccess.dir_exists_absolute(screenshot_dir_path):
		DirAccess.make_dir_recursive_absolute(screenshot_dir_path)

func save_game(game_data: Dictionary) -> void:
	var save_file_name: String = Helpers.date_time_string_for_saves() + "_" + game_data.game.difficulty + ".save"
	game_data_path = save_dir_path + save_file_name
	var player_dir: DirAccess = DirAccess.open(Constants.PLAYER_DATA_PATH)
	if not player_dir.dir_exists(save_dir_path):
		player_dir.make_dir_recursive(save_dir_path)
	var save_file: FileAccess = FileAccess.open(game_data_path, FileAccess.WRITE)
	save_file.store_line(JSON.stringify(game_data))
	save_file.close()
	message.emit(game_data_path)

func load_game(save_file_path: String) -> Dictionary:
	game_data_path = save_file_path
	
	var save_file: FileAccess = FileAccess.open(game_data_path, FileAccess.READ)
	var save_data: String = save_file.get_line()
	save_file.close()

	var test_json_conv = JSON.new()
	if test_json_conv.parse(save_data) == OK:
		return test_json_conv.get_data()
	return Dictionary()

func del_save_file(save_file_name: String) -> void:	
	Helpers.delete_file(save_dir_path, save_file_name)
	save_file_deleted.emit()

func screenshot():
	var img = get_viewport().get_texture().get_image()
	var img_path = screenshot_dir_path + Helpers.date_time_string() + ".png"
	var err = img.save_png(screenshot_dir_path + Helpers.date_time_string() + ".png")
	if err == OK:
		message.emit("Screenshot saved: " + img_path)
	else:
		message.emit("Screenshot save " + img_path + " error: " + error_string(err))

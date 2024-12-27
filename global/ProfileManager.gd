extends Node

const PLAYER_DATA_PATH: String = "user://player_profiles/"
const PROFILE_CONFIG_FILE: String = PLAYER_DATA_PATH + "profile_config.ini"
const PROFILE_FILE: String = "profile.ini"
const SCREEN_SHOT_FOLDER: String = "screenshots"
const SAVED_GAMES_FOLDER: String = "saved_games"

const EXCLUDED_FOLDERS: PackedStringArray = ['logs', SCREEN_SHOT_FOLDER, SAVED_GAMES_FOLDER]

enum ProfileErrors {
		OK,
		PROFILE_EXISTS,
		PROFILE_FOLDER_ERROR
		}

signal message(message)
signal profile_created
signal profile_changed
signal game_deleted
signal save_file_deleted

@onready var profile_list: PackedStringArray = []
@onready var profile_current: int = -1

@onready var game_list: PackedStringArray = []
@onready var game_current: int = 0

@onready var game_save_list: PackedStringArray = []
@onready var game_data_path: String = ""

@onready var game_play_time: float = 0.0

func _ready() -> void:
	profile_created.connect(_on_profile_created)
	profile_changed.connect(_on_profile_changed)
	await get_node("/root/main").ready
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func _on_profile_changed() -> void:
	load_profile()

func _on_profile_created() -> void:
	save_profile()

func profile_exists(new_profile_name: String) -> bool:
	get_profile_list()
	return new_profile_name in profile_list

func add_profile(new_profile: String) -> int:
	if profile_exists(new_profile):
		return ProfileErrors.PROFILE_EXISTS
	var dir = DirAccess.open(PLAYER_DATA_PATH)
	if dir.make_dir_recursive(new_profile) == OK:
		if dir.file_exists(PLAYER_DATA_PATH + PROFILE_FILE):
			dir.rename(PLAYER_DATA_PATH + PROFILE_FILE, PLAYER_DATA_PATH + new_profile + "/" + PROFILE_FILE)
		if dir.file_exists(PLAYER_DATA_PATH + ConfigManager.CONFIG_FILE):
			dir.rename(PLAYER_DATA_PATH + ConfigManager.CONFIG_FILE, PLAYER_DATA_PATH + new_profile + "/" + ConfigManager.CONFIG_FILE)
		if dir.dir_exists(PLAYER_DATA_PATH + SCREEN_SHOT_FOLDER + "/"):
			dir.rename(PLAYER_DATA_PATH + SCREEN_SHOT_FOLDER + "/", PLAYER_DATA_PATH + new_profile + "/" + SCREEN_SHOT_FOLDER + "/")
		if dir.dir_exists(PLAYER_DATA_PATH + SAVED_GAMES_FOLDER + "/"):
			dir.rename(PLAYER_DATA_PATH + SAVED_GAMES_FOLDER + "/", PLAYER_DATA_PATH + new_profile + "/" + SAVED_GAMES_FOLDER + "/")
		get_profile_list()
		profile_current = profile_list.find(new_profile)
		save_profile_current()
		profile_created.emit()
		profile_changed.emit()
		return ProfileErrors.OK
	else:
		return ProfileErrors.PROFILE_FOLDER_ERROR

func del_profile(profile_index: int) -> void:
	get_profile_list()
	Helpers.recursive_non_empty_dir_deletion(get_profile_path(profile_index))
	set_profile_current(profile_current)

func save_profile_current() -> void:
	var profile_config_file = ConfigFile.new()
	profile_config_file.set_value("profile", "current", profile_current)
	profile_config_file.save(PROFILE_CONFIG_FILE)

func load_profile_current() -> void:
	var profile_config_file = ConfigFile.new()
	var err = profile_config_file.load(PROFILE_CONFIG_FILE)
	if err == OK:
		profile_current = profile_config_file.get_value("profile", "current", -1)
	elif err == ERR_FILE_NOT_FOUND:
		save_profile_current()

func save_profile() -> bool:
	var profile_file = ConfigFile.new()
	profile_file.set_value("game", "game_current", game_current)
	profile_file.set_value("game", "game_play_time", game_play_time)
	profile_file.set_value("game", "game_data_path", game_data_path)
	var success: bool = OK == profile_file.save(get_profile_file_path_current())
	message.emit("PROFILE SAVED: " + "SUCCESS" if success else "FAIL")
	return success

func load_profile() -> bool:
	var profile_file = ConfigFile.new()
	var err = profile_file.load(get_profile_file_path_current())
	if err == OK:
		game_current = profile_file.get_value("game", "game_current", 0)
		game_play_time = profile_file.get_value("game", "game_play_time", 0)
		game_data_path = profile_file.get_value("game", "game_data_path", "")
		return true
	elif err == ERR_FILE_NOT_FOUND:
		game_current = 0
		game_play_time = 0
		game_data_path = ""
		return save_profile()
	else:
		return false

func new_game(game_data) -> void:
	# New game_current
	var game_index = 0
	while DirAccess.dir_exists_absolute(get_game_save_path(game_index)):
		game_index = game_index + 1
	DirAccess.make_dir_recursive_absolute(get_game_save_path(game_index))
	game_current = game_index
	game_data_path = ""
	save_profile()
	save_game(game_data)

func save_game(game_data) -> void:
	var save_dir_path = get_game_save_path_current()
	var save_file_path = Helpers.date_time_string() + ".save"
	game_data_path = save_dir_path + save_file_path
	var save_dir = DirAccess.open(save_dir_path)
	if not save_dir.dir_exists(save_dir_path):
		save_dir.make_dir_recursive(save_dir_path)
	var save_file = FileAccess.open(game_data_path, FileAccess.WRITE)
	for data in game_data:
		save_file.store_line(JSON.stringify(data))
	save_file.close()
	save_profile()
	message.emit(game_data_path)

func load_game() -> Array:
	var game_data: Array = []
	var save_file = FileAccess.open(game_data_path, FileAccess.READ)
	while not save_file.eof_reached():
		var test_json_conv = JSON.new()
		test_json_conv.parse(save_file.get_line())
		game_data.append(test_json_conv.get_data())
	save_file.close()
	return game_data

func del_game(game_index: int) -> void:
	Helpers.recursive_non_empty_dir_deletion(get_game_save_path(game_index))
	if game_current == game_index:
		get_game_current()
	game_deleted.emit()

func del_save_file(game_index: int, save_file_name: String) -> void:
	var save_file_path: String = ProfileManager.get_game_save_path(game_index)
	Helpers.delete_file(save_file_path, save_file_name)
	save_file_deleted.emit()

func set_profile_current(profile_index: int) -> void:
	get_profile_list()
	profile_index = clamp(profile_index, -1, profile_list.size() - 1)
	profile_current = profile_index
	save_profile_current()
	profile_changed.emit()

func get_profile_current():
	get_profile_list()
	if profile_list.is_empty():
		profile_current = -1
		save_profile_current()
	else:
		load_profile_current()
		var profile_current_checked = clamp(profile_current, -1, profile_list.size() - 1)
		if profile_current != profile_current_checked:
			profile_current = profile_current_checked
			save_profile_current()
			profile_changed.emit()

func set_game_current(new_game_current: int) -> void:
	get_game_list()
	if game_list.is_empty():
		game_current = 0
		save_profile()
	else:
		game_current = new_game_current if String.num(new_game_current) in game_list else int(game_list[-1])
		save_profile()

func get_game_current() -> void:
	get_game_list()
	if game_list.is_empty():
		game_current = 0
		save_profile()
	else:
		load_profile()
		# WHAT THE HELL ???
		#var game_current_checked = clamp(game_current, 0, game_list.size() - 1)
		#if game_current != game_current_checked:
			#game_current = game_current_checked
		game_current = game_current if String.num(game_current) in game_list else int(game_list[-1])
		save_profile()

func get_profile_list():
	if not DirAccess.dir_exists_absolute(PLAYER_DATA_PATH):
		DirAccess.make_dir_recursive_absolute(PLAYER_DATA_PATH)
	var dir = DirAccess.open(PLAYER_DATA_PATH)
	profile_list.clear()
	profile_list = dir.get_directories()
	Helpers.array_difference(profile_list, EXCLUDED_FOLDERS)
	profile_list.reverse()

func get_game_list():
	var profile_saved_games_dir = get_profile_saved_games_path_current()
	if not DirAccess.dir_exists_absolute(profile_saved_games_dir):
		DirAccess.make_dir_recursive_absolute(profile_saved_games_dir)
	var dir = DirAccess.open(profile_saved_games_dir)
	game_list.clear()
	game_list = dir.get_directories()
	game_list.reverse()

func get_game_save_list(game_index: int) -> void:
	var game_save_dir = get_game_save_path(game_index)
	if not DirAccess.dir_exists_absolute(game_save_dir):
		DirAccess.make_dir_recursive_absolute(game_save_dir)
	var dir = DirAccess.open(game_save_dir)
	game_save_list.clear()
	game_save_list = dir.get_files()
	game_save_list.reverse()

func get_game_save_list_current() -> void:
	get_game_current()
	get_game_save_list(game_current)

func get_profile_name(profile_index: int) -> String:
	profile_index = clamp(profile_index, -1, profile_list.size() - 1)
	return "player" if profile_index == - 1 else profile_list[profile_index]

func get_profile_name_current() -> String:
	get_profile_current()
	return get_profile_name(profile_current)

func get_profile_play_time(profile_index: int) -> float:
	var profile_file = ConfigFile.new()
	var err = profile_file.load(get_profile_file_path(profile_index))
	return profile_file.get_value("game", "game_play_time", 0.0) if err == OK else 0.0

func get_profile_play_time_current() -> float:
	return game_play_time

func get_profile_path(profile_index: int) -> String:
	profile_index = clamp(profile_index, -1, profile_list.size() - 1)
	return PLAYER_DATA_PATH if profile_index == - 1 else PLAYER_DATA_PATH + get_profile_name(profile_index) + "/"

func get_profile_path_current() -> String:
	get_profile_current()
	return get_profile_path(profile_current)

func get_profile_file_path(profile_index: int) -> String:
	profile_index = clamp(profile_index, -1, profile_list.size() - 1)
	return get_profile_path(profile_index) + PROFILE_FILE

func get_profile_file_path_current() -> String:
	get_profile_current()
	return get_profile_file_path(profile_current)

func get_profile_screenshot_path(profile_index: int) -> String:
	profile_index = clamp(profile_index, -1, profile_list.size() - 1)
	return get_profile_path(profile_index) + SCREEN_SHOT_FOLDER + "/"

func get_profile_screenshot_path_current() -> String:
	get_profile_current()
	return get_profile_screenshot_path(profile_current)

func get_profile_saved_games_path(profile_index: int) -> String:
	profile_index = clamp(profile_index, -1, profile_list.size() - 1)
	return get_profile_path(profile_index) + SAVED_GAMES_FOLDER + "/"

func get_profile_saved_games_path_current() -> String:
	get_profile_current()
	return get_profile_saved_games_path(profile_current)

func get_game_save_path(game_index: int) -> String:
	return get_profile_saved_games_path_current() + String.num(game_index) + "/"

func get_game_save_path_current() -> String:
	get_game_current()
	return get_game_save_path(game_current)

func profile_has_saved_games_current() -> bool:
	get_game_list()
	return not game_list.is_empty()

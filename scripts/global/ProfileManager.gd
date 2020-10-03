extends Node

const PROFILE_CONFIG_FILE = "user://profile_config.ini"
const PROFILE_FILE = "profile.ini"
const SCREEN_SHOT_FOLDER = "screenshots"
const SAVED_GAMES_FOLDER = "saved_games"

const EXCLUDED_FOLDERS = ['logs', SCREEN_SHOT_FOLDER, SAVED_GAMES_FOLDER]

enum ProfileErrors {
		OK,
		PROFILE_EXISTS,
		PROFILE_FOLDER_ERROR
		}

signal message(message)
signal profile_created
signal profile_changed

# Profile Config

onready var profile_list = []
onready var profile_current = -1

# Player Specific Profile

onready var game_list = []
onready var game_current = -1
onready var game_play_time = 0
onready var game_data_path = ""

func _ready():
	connect("profile_changed", self, "_on_profile_changed")
	yield(get_node("/root/main"), "ready")
	self.pause_mode = Node.PAUSE_MODE_PROCESS

# PROFILE

func save_profile_current():
	var profile_config_file = ConfigFile.new()
	profile_config_file.set_value("profile", "current", profile_current)
	var err = profile_config_file.save(PROFILE_CONFIG_FILE)
	return err == OK

func load_profile_current():
	var profile_config_file = ConfigFile.new()
	var err = profile_config_file.load(PROFILE_CONFIG_FILE)
	if err == OK:
		profile_current = profile_config_file.get_value("profile", "current", -1)
		return true
	elif err == ERR_FILE_NOT_FOUND:
		return save_profile_current()
	else:
		return false

func _on_profile_changed():
	load_profile()

func save_profile():
	var profile_file = ConfigFile.new()
	profile_file.set_value("game", "game_current", game_current)
	profile_file.set_value("game", "game_play_time", game_play_time)
	profile_file.set_value("game", "game_data_path", game_data_path)
	return OK == profile_file.save(get_current_profile_file_path())

func load_profile():
	var profile_file = ConfigFile.new()
	var err = profile_file.load(get_current_profile_file_path())
	if err == OK:
		game_current = profile_file.get_value("game", "game_current", -1)
		game_play_time = profile_file.get_value("game", "game_play_time", 0)
		game_data_path = profile_file.get_value("game", "game_data_path", "")
		return true
	elif err == ERR_FILE_NOT_FOUND:
		return save_profile()
	else:
		return false

func get_profile_list():
	profile_list = []
	var dir = Directory.new()
	dir.open("user://")
	dir.list_dir_begin(true, true)
	var el_name = dir.get_next()
	while el_name != "":
		if dir.current_is_dir() and ( not el_name in EXCLUDED_FOLDERS ) :
			profile_list.append(el_name)
		el_name = dir.get_next()
	dir.list_dir_end()
	profile_list.sort()

func get_current_profile():
	get_profile_list()
	if profile_list.empty():
		profile_current = -1
		save_profile_current()
	else:
		load_profile_current()
		var profile_current_checked = clamp( profile_current, -1, profile_list.size() - 1 )
		if profile_current != profile_current_checked:
			profile_current = profile_current_checked
			save_profile_current()
			emit_signal("profile_changed")

func set_current_profile(profile_index):
	get_profile_list()
	profile_index = clamp( profile_index, -1, profile_list.size() - 1 )
	profile_current = profile_index
	save_profile_current()
	emit_signal("profile_changed")

func get_profile_name(profile_index):
	profile_index = clamp( profile_index, -1, profile_list.size() - 1 )
	return "player" if profile_index == -1 else profile_list[profile_index]

func get_current_profile_name():
	get_current_profile()
	return get_profile_name(profile_current)

func get_profile_path(profile_index):
	profile_index = clamp( profile_index, -1, profile_list.size() - 1 )
	return "user://" if profile_index == -1 else "user://" + get_profile_name(profile_index) + "/"

func get_current_profile_path():
	get_current_profile()
	return get_profile_path(profile_current)

func get_profile_file_path(profile_index):
	profile_index = clamp( profile_index, -1, profile_list.size() - 1 )
	return get_profile_path(profile_index) + PROFILE_FILE

func get_current_profile_file_path():
	get_current_profile()
	return get_profile_file_path(profile_current)

func get_profile_screenshot_path(profile_index):
	profile_index = clamp( profile_index, -1, profile_list.size() - 1 )
	return get_profile_path(profile_index) + SCREEN_SHOT_FOLDER + "/"

func get_current_profile_screenshot_path():
	get_current_profile()
	return get_profile_screenshot_path(profile_current)

func get_profile_saved_games_path(profile_index):
	profile_index = clamp( profile_index, -1, profile_list.size() - 1 )
	return get_profile_path(profile_index) + SAVED_GAMES_FOLDER + "/"

func get_current_profile_saved_games_path():
	get_current_profile()
	return get_profile_saved_games_path(profile_current)

func add_profile(new_profile):
	get_profile_list()
	if new_profile in profile_list:
		return ProfileErrors.PROFILE_EXISTS
	var dir = Directory.new()
	dir.open("user://")
	if dir.make_dir(new_profile) == OK:
		
		if dir.file_exists( "user://" + PROFILE_FILE ):
			dir.rename( "user://" + PROFILE_FILE , "user://" + new_profile + "/" + PROFILE_FILE )
		if dir.file_exists( "user://" + ConfigManager.CONFIG_FILE ):
			dir.rename( "user://" + ConfigManager.CONFIG_FILE , "user://" + new_profile + "/" + ConfigManager.CONFIG_FILE )
		if dir.dir_exists( "user://" + SCREEN_SHOT_FOLDER + "/" ):
			dir.rename( "user://" + SCREEN_SHOT_FOLDER + "/" , "user://" + new_profile + "/" + SCREEN_SHOT_FOLDER + "/")
		if dir.dir_exists( "user://" + SAVED_GAMES_FOLDER + "/" ):
			dir.rename( "user://" + SAVED_GAMES_FOLDER + "/" , "user://" + new_profile + "/" + SAVED_GAMES_FOLDER + "/")
		
		get_profile_list()
		profile_current = profile_list.find(new_profile)
		save_profile_current()
		emit_signal("profile_created")
		emit_signal("profile_changed")
		return ProfileErrors.OK
	else:
		return ProfileErrors.PROFILE_FOLDER_ERROR

func del_profile(profile_index):
	get_profile_list()
	Helpers.recursive_non_empty_dir_deletion(get_profile_path(profile_index))
	set_current_profile(profile_current)

# GAME

func get_game_list():
	game_list = []
	var dir = Directory.new()
	dir.open(get_current_profile_saved_games_path())
	dir.list_dir_begin(true, true)
	var el_name = dir.get_next()
	while el_name != "":
		if dir.current_is_dir() and ( not el_name in EXCLUDED_FOLDERS ) :
			game_list.append(el_name)
		el_name = dir.get_next()
	dir.list_dir_end()
	game_list.sort()

func get_game_save_path():
	return get_current_profile_saved_games_path() + String(game_current) + "/"

func new_game(game_data):
	game_current = 0
	var dir = Directory.new()
	while dir.dir_exists(get_game_save_path()):
		game_current = game_current + 1
	dir.make_dir_recursive(get_game_save_path())
	save_game(game_data)
	save_profile()

func save_game(game_data):
	var dt = OS.get_datetime()
	var save_dir_path = get_game_save_path()
	var save_file_path = String(dt.year) + "_" + String(dt.month) + "_" + String(dt.day) + "_" + String(dt.hour) + "_" + String(dt.minute) + "_" + String(dt.second) + ".save"
	var save_path = save_dir_path + save_file_path
	var save_dir = Directory.new()
	if not save_dir.dir_exists(save_dir_path):
		save_dir.make_dir_recursive(save_dir_path)
	var save_file = File.new()
	save_file.open(save_path ,File.WRITE)
	save_file.store_line(to_json(game_data))
	save_file.close()
	emit_signal("message", save_path)
	game_data_path = save_path

func load_game():
	var save_file = File.new()
	if save_file.open(game_data_path, File.READ) == OK:
		return parse_json(save_file.get_line())

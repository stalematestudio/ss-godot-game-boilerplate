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

onready var profile_list = []
onready var profile_current = -1

onready var game_list = []
onready var game_current = 0

onready var game_save_list = []
onready var game_data_path = ""

onready var game_play_time = 0

func _ready():
	connect("profile_created", self, "_on_profile_created")
	connect("profile_changed", self, "_on_profile_changed")
	
	yield(get_node("/root/main"), "ready")
	self.pause_mode = Node.PAUSE_MODE_PROCESS

func _on_profile_changed():
	load_profile()

func _on_profile_created():
	pass

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
	set_profile_current(profile_current)

func save_profile_current():
	var profile_config_file = ConfigFile.new()
	profile_config_file.set_value("profile", "current", profile_current)
	profile_config_file.save(PROFILE_CONFIG_FILE)

func load_profile_current():
	var profile_config_file = ConfigFile.new()
	var err = profile_config_file.load(PROFILE_CONFIG_FILE)
	if err == OK:
		profile_current = profile_config_file.get_value("profile", "current", -1)
	elif err == ERR_FILE_NOT_FOUND:
		save_profile_current()

func save_profile():
	var profile_file = ConfigFile.new()
	profile_file.set_value("game", "game_current", game_current)
	profile_file.set_value("game", "game_play_time", game_play_time)
	profile_file.set_value("game", "game_data_path", game_data_path)
	emit_signal("message", "PROFILE SAVED: " + "SUCCESS" if OK == profile_file.save( get_profile_file_path_current() ) else "FAIL" ) 

func load_profile():
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

func new_game(game_data):
	# New game_current
	var game_index = 0
	var dir = Directory.new()
	while dir.dir_exists(get_game_save_path(game_index)):
		game_index = game_index + 1
	dir.make_dir_recursive(get_game_save_path(game_index))
	game_current = game_index
	game_data_path = ""
	save_profile()
	save_game(game_data)

func del_game(game_index):
	Helpers.recursive_non_empty_dir_deletion( get_game_save_path( game_index ) )

func save_game(game_data):
	var save_dir_path = get_game_save_path_current()
	var save_file_path = Helpers.date_time_string() + ".save"
	game_data_path = save_dir_path + save_file_path
	var save_dir = Directory.new()
	if not save_dir.dir_exists(save_dir_path):
		save_dir.make_dir_recursive(save_dir_path)
	var save_file = File.new()
	save_file.open(game_data_path ,File.WRITE)
	for data in game_data:
		save_file.store_line(to_json(data))
	save_file.close()
	save_profile()
	emit_signal("message", game_data_path)

func load_game():
	var game_data = []
	var save_file = File.new()
	if OK == save_file.open(game_data_path, File.READ):
		while not save_file.eof_reached():
			game_data.append( parse_json( save_file.get_line() ) )
	save_file.close()
	return game_data

func set_profile_current(profile_index):
	get_profile_list()
	profile_index = clamp( profile_index, -1, profile_list.size() - 1 )
	profile_current = profile_index
	save_profile_current()
	emit_signal("profile_changed")

func get_profile_current():
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

func get_game_current():
	get_game_list()
	if game_list.empty():
		game_current = 0
		save_profile()
	else:
		load_profile()
		var game_current_checked = clamp( game_current, 0, game_list.size() - 1 )
		if game_current != game_current_checked:
			game_current = game_current_checked
			save_profile()

func get_profile_list():
	profile_list.clear()
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

func get_game_list():
	game_list.clear()
	var dir = Directory.new()
	var profile_saved_games_dir = get_profile_saved_games_path_current()
	if not dir.dir_exists(profile_saved_games_dir):
		dir.make_dir(profile_saved_games_dir)
	dir.open(profile_saved_games_dir)
	dir.list_dir_begin(true, true)
	var el_name = dir.get_next()
	while el_name != "":
		if dir.current_is_dir() and ( not el_name in EXCLUDED_FOLDERS ) :
			game_list.append(el_name)
		el_name = dir.get_next()
	dir.list_dir_end()
	game_list.sort()
	game_list.invert()

func get_game_save_list(game_index):
	game_save_list.clear()
	var dir = Directory.new()
	var game_save_dir = get_game_save_path(game_index)
	dir.open(game_save_dir)
	dir.list_dir_begin(true, true)
	var el_name = dir.get_next()
	while el_name != "":
		if not dir.current_is_dir():
			game_save_list.append(el_name)
		el_name = dir.get_next()
	dir.list_dir_end()
	game_save_list.sort()
	game_save_list.invert()

func get_profile_name(profile_index):
	profile_index = clamp( profile_index, -1, profile_list.size() - 1 )
	return "player" if profile_index == -1 else profile_list[profile_index]

func get_profile_name_current():
	get_profile_current()
	return get_profile_name(profile_current)

func get_profile_path(profile_index):
	profile_index = clamp( profile_index, -1, profile_list.size() - 1 )
	return "user://" if profile_index == -1 else "user://" + get_profile_name(profile_index) + "/"

func get_profile_path_current():
	get_profile_current()
	return get_profile_path(profile_current)

func get_profile_file_path(profile_index):
	profile_index = clamp( profile_index, -1, profile_list.size() - 1 )
	return get_profile_path(profile_index) + PROFILE_FILE

func get_profile_file_path_current():
	get_profile_current()
	return get_profile_file_path(profile_current)

func get_profile_screenshot_path(profile_index):
	profile_index = clamp( profile_index, -1, profile_list.size() - 1 )
	return get_profile_path(profile_index) + SCREEN_SHOT_FOLDER + "/"

func get_profile_screenshot_path_current():
	get_profile_current()
	return get_profile_screenshot_path(profile_current)

func get_profile_saved_games_path(profile_index):
	profile_index = clamp( profile_index, -1, profile_list.size() - 1 )
	return get_profile_path(profile_index) + SAVED_GAMES_FOLDER + "/"

func get_profile_saved_games_path_current():
	get_profile_current()
	return get_profile_saved_games_path(profile_current)

func get_game_save_path(game_index):
	return get_profile_saved_games_path_current() + String(game_index) + "/"

func get_game_save_path_current():
	get_game_current()
	return get_game_save_path(game_current)

func profile_has_saved_games_current():
	get_game_list()
	return not game_list.empty()

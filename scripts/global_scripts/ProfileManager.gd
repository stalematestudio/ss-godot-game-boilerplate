extends Node

signal message(message)
signal profile_created
signal profile_changed

var profile_list

enum ProfileErrors {
		OK,
		PROFILE_EXISTS,
		PROFILE_FOLDER_ERROR
		}

onready var profile_current = -1
onready var profile_config_path = "user://profile.ini"

func _ready():
	yield(get_node("/root/main"), "ready") # Wait For Main Scene to be ready.
	self.pause_mode = Node.PAUSE_MODE_PROCESS

func save_profile_current():
	var profile_config_file = ConfigFile.new()
	profile_config_file.set_value("profile", "current", profile_current)
	var err = profile_config_file.save(profile_config_path)
	return err == OK

func load_profile_current():
	var profile_config_file = ConfigFile.new()
	var err = profile_config_file.load(profile_config_path)
	if err == OK:
		profile_current = profile_config_file.get_value("profile", "current", -1)
		return true
	elif err == ERR_FILE_NOT_FOUND:
		return save_profile_current()
	else:
		return false

func get_profile_list():
	profile_list = []
	var dir = Directory.new()
	dir.open("user://")
	dir.list_dir_begin(true, true)
	var el_name = dir.get_next()
	while el_name != "":
		if dir.current_is_dir() and ( not el_name in ['logs', 'screenshots'] ) :
			profile_list.append(el_name)
		el_name = dir.get_next()
	dir.list_dir_end()
	profile_list.sort()

func get_current_profile():
	get_profile_list()
	if profile_list.empty():
		profile_current = -1
		save_profile_current()
		return
	load_profile_current()
	if profile_current > profile_list.size():
		profile_current = 0

func set_current_profile(profile_index):
	get_profile_list()
	profile_index = clamp( profile_index, -1, profile_list.size() - 1 )
	if profile_current != profile_index:
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

func add_profile(new_profile):
	get_profile_list()
	if new_profile in profile_list:
		return ProfileErrors.PROFILE_EXISTS
	var dir = Directory.new()
	dir.open("user://")
	if dir.make_dir(new_profile) == OK:
		if dir.file_exists("user://config.ini"):
			dir.rename("user://config.ini", "user://" + new_profile + "/config.ini")
		if dir.dir_exists("user://screenshots/"):
			dir.rename("user://screenshots/", "user://" + new_profile + "/screenshots/")
		get_profile_list()
		profile_current = profile_list.find(new_profile)
		save_profile_current()
		emit_signal("profile_created")
		emit_signal("profile_changed")
		return ProfileErrors.OK
	else:
		return ProfileErrors.PROFILE_FOLDER_ERROR

func del_profile(profile_index):
	pass

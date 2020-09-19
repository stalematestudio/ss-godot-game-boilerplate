extends Node

var profile_list
var profile_current

func _ready():
	yield(get_node("/root/main"), "ready") # Wait For Main Scene to be ready.
	self.pause_mode = Node.PAUSE_MODE_PROCESS

func get_profile_list():
	profile_list = []
	var dir = Directory.new()
	dir.open("user://")
	dir.list_dir_begin(true, true)
	var el_name = dir.get_next()
	while el_name != "":
		if dir.current_is_dir():
			profile_list.append(el_name)
		el_name = dir.get_next()
	dir.list_dir_end()
	profile_list.sort()

func get_current_profile_index():
	get_profile_list()
	if profile_list.empty():
		profile_current = false
		return
	var profile_config_path = "user://profile.ini"
	var profile_config_file = ConfigFile.new()
	var err = profile_config_file.load(profile_config_path)
	if err == OK:
		profile_current = profile_config_file.get_value("profile", "current", 0)
	elif err == ERR_FILE_NOT_FOUND:
		profile_config_file.set_value("profile", "current", 0)
		profile_config_file.save(profile_config_path)
		profile_current = 0
	if profile_list.size() > profile_current:
		profile_current = false

func get_current_profile():
	if profile_current == false:
		return "player"
	else:
		return profile_list[profile_current]

func get_config_path():
	get_current_profile_index()
	if profile_current == false:
		return "user://config.ini"
	else:
		return "user://" + profile_list[profile_current] + "/config.ini"

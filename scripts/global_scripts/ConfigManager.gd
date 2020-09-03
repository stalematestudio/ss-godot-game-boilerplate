extends Node

onready var config_path = "user://config.ini"
onready var main_scene = get_node("/root/main")
onready var joypad_present = false
onready var joypad_device_id = 0

const resolutions = [
		{"name": "854x480", "value": Vector2(854, 480)},
		{"name": "1024x576", "value": Vector2(1024, 576)},
		{"name": "1280x720", "value": Vector2(1280, 720)},
		{"name": "1366x768", "value": Vector2(1366, 768)},
		{"name": "1600x900", "value": Vector2(1600, 900)},
		{"name": "1920x1080", "value": Vector2(1920, 1080)},
		{"name": "2560x1440", "value": Vector2(2560, 1440)},
		{"name": "3840x2160", "value": Vector2(3840, 2160)},
		]

onready var config_data_default = {
		"game":{
				"debug":false
				},
		"video":{
				"fullscreen": false,
				"borderless": false,
				"resolution_auto": false,
				"resolution_option": 0,
				"vsync": true,
				},
		"audio":{
				"master_enabled":true,
				"master_volume": -12,
				"music_enabled": true,
				"music_volume": -12,
				"fx_enabled": true,
				"fx_volume": -12
				},
		"mouse":{
				"mouse_inverted_x": false,
				"mouse_sensitivity_x": 0.3,
				"mouse_inverted_y": false,
				"mouse_sensitivity_y": 0.3,
				"mouse_inverted_scroll": false,
				"mouse_sensitivity_scroll": 0.3
				},
		"controller":{
				"left_y_sensitivity": 1,
				"left_y_inverted": false,
				"left_x_sensitivity": 1,
				"left_x_inverted": false,
				"right_y_sensitivity": 1,
				"right_y_inverted": false,
				"right_x_sensitivity": 1,
				"right_x_inverted": false,
				},
		"keybinding":{}
		}

onready var config_data

# Called when the node enters the scene tree for the first time.
func _ready():
	# Handle Controllers
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	controller_setup()
	# Get keybinding defaults from globals
	keybind_defaults()
	# Set Config Data to Default
	config_data = config_data_default.duplicate(true)
	# Update From File
	load_config()
	# Apply Config
	apply_config()

func apply_config():
	# Game
	main_scene.set_debug_display()
	# Video
	OS.set_window_fullscreen(config_data.video.fullscreen)
	OS.set_use_vsync(config_data.video.vsync)
	if not OS.is_window_fullscreen():
		OS.set_borderless_window(config_data.video.borderless)
		var screen_size = OS.get_screen_size()
		var config_size = resolutions[config_data.video.resolution_option].value
		if config_data.video.resolution_auto or ( config_size[0] > screen_size[0] ) :
			OS.set_window_size(screen_size)
		else:
			OS.set_window_size(config_size)
		OS.center_window()
	# Audio
	# Master
	AudioServer.set_bus_mute(AudioManager.audio_bus_master, !config_data.audio.master_enabled)
	AudioServer.set_bus_volume_db(AudioManager.audio_bus_master, config_data.audio.master_volume)
	# Music
	AudioServer.set_bus_mute(AudioManager.audio_bus_music, !config_data.audio.music_enabled)
	AudioServer.set_bus_volume_db(AudioManager.audio_bus_music, config_data.audio.music_volume)
	# FX
	AudioServer.set_bus_mute(AudioManager.audio_bus_fx, !config_data.audio.fx_enabled)
	AudioServer.set_bus_volume_db(AudioManager.audio_bus_fx, config_data.audio.fx_volume)
	# Key Binding
	for action in config_data.keybinding:
		InputMap.action_set_deadzone(action, config_data.keybinding[action].deadzone)
		InputMap.action_erase_events(action)
		for event in config_data.keybinding[action].events:
			InputMap.action_add_event(action, event)

func save_config():
	var config_file = ConfigFile.new()
	for section in config_data:
		for setting in config_data[section]:
			config_file.set_value(section, setting, config_data[section][setting])
	var err = config_file.save(config_path)
	if err == OK:
		return true

func load_config():
	var config_file = ConfigFile.new()
	var err = config_file.load(config_path)
	if err == OK:
		for section in config_data:
			for setting in config_data[section]:
				config_data[section][setting] = config_file.get_value(section, setting, config_data[section][setting])
		return true
	elif err == ERR_FILE_NOT_FOUND:
		return save_config()
	else:
		return false

func reset_to_default(section):
	if section == "keybinding":
		InputMap.load_from_globals()
		keybind_defaults()
	config_data[section] = config_data_default[section].duplicate(true)
	save_config()
	apply_config()

func _on_joy_connection_changed(device, connected):
	if connected:
		joypad_present = true
		joypad_device_id = device
	else:
		controller_setup()

func controller_setup():
	var joypads = Input.get_connected_joypads()
	if joypads.empty():
		joypad_present = false
		joypad_device_id = 0
	else:
		joypad_present = true
		joypad_device_id = joypads[0]

func keybind_defaults():
	for action in InputMap.get_actions():
		if not ( action.begins_with('ui_') or action.begins_with('util_') ):
			config_data_default['keybinding'][action] = {
					"deadzone": 0.5,
					"events": []
					}
			config_data_default['keybinding'][action]['events'] = InputMap.get_action_list(action).duplicate(true)

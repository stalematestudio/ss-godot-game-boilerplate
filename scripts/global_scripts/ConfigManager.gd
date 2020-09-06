extends Node

onready var config_path = "user://config.ini"

onready var joypad_in_use = false
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
				"subtitles":false,
				"mouse_mode_confined": false,
				"pause_on_focus_loss": true,
				"resume_on_focus_grab": true,
				"debug":false
				},
		"video":{
				"picture_adjustments": false,
				"picture_brightnes": 1,
				"picture_contrast": 1,
				"picture_saturation": 1,
				"fullscreen": false,
				"borderless": false,
				"resolution_auto": false,
				"resolution_option": 0,
				"vsync": true,
				},
		"audio":{
				"Master": {
					"mute": false,
					"volume": 50
					},
				"Music": {
					"mute": false,
					"volume": 50
					},
				"Voice": {
					"mute": false,
					"volume": 50
					},
				"FX": {
					"mute": false,
					"volume": 50
					},
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
				"vibration": true,
				"weak_magnitude": 1,
				"strong_magnitude": 1,
				"left_y_sensitivity": 1,
				"left_y_inverted": false,
				"left_x_sensitivity": 1,
				"left_x_inverted": false,
				"right_y_sensitivity": 1,
				"right_y_inverted": false,
				"right_x_sensitivity": 1,
				"right_x_inverted": false,
				},
		"keybind": {}
		}

onready var config_data

# Called when the node enters the scene tree for the first time.
func _ready():
	# Handle Controllers
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	controller_setup()
	# Get keybinding defaults from globals
	config_data_default.keybind = keybind_defaults().duplicate(true)
	# Set Config Data to Default
	config_data = config_data_default.duplicate(true)
	# Update From File
	load_config()

func apply_config():
	# Game
	GameManager.apply_config()
	# Video
	VideoManager.apply_config()
	# Audio
	AudioManager.apply_config()
	# Input
	InputManager.apply_config()

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
	if section == "keybind":
		InputMap.load_from_globals()
		keybind_defaults()
	config_data[section] = config_data_default[section].duplicate(true)
	save_config()
	match section:
		"game":
			GameManager.apply_config()
		"video":
			VideoManager.apply_config()
		"audio":
			AudioManager.apply_config()
		"mouse":
			pass
		"controller":
			pass
		"keybind":
			pass
		

func _on_joy_connection_changed(device, connected):
	print( "Config Manager " + String(connected) + String(device) )
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
	var config_data_default_keybind = {}
	InputMap.load_from_globals()
	for action in InputMap.get_actions():
		if not ( action.begins_with('ui_') or action.begins_with('util_') ):
			config_data_default_keybind[action] = {
					"deadzone": 0.5,
					"events": InputMap.get_action_list(action).duplicate(true)
					}
	return config_data_default_keybind

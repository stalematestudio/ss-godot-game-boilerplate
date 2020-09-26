extends Node

const CONFIG_FILE = "config.ini"

signal message(message)
signal config_update

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

onready var config_path = ProfileManager.get_current_profile_path() + CONFIG_FILE
onready var config_data_default = {
		"game":{
				"subtitles":false,
				"mouse_mode_confined": false,
				"pause_on_focus_loss": true,
				"resume_on_focus_grab": true,
				"low_processor_usage_mode": false,
				"low_processor_usage_mode_sleep_usec": 6900,
				"iterations_per_second": 60,
				"physics_jitter_fix": 0.5,
				"target_fps": 0,
				"time_scale": 1,
				"debug":false
				},
		"video":{
				"fov": 70,
				"picture_adjustments": false,
				"picture_brightnes": 1,
				"picture_contrast": 1,
				"picture_saturation": 1,
				"use_screen": 0,
				"keep_screen_on": true,
				"vsync": true,
				"fullscreen": false,
				"center_window":false,
				"borderless": false,
				"resolution_auto": false,
				"resolution_option": 0
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
		"keybind": keybind_defaults()
		}
onready var config_data = config_data_default.duplicate(true)

func _ready():
	yield(get_node("/root/main"), "ready") # Wait For Main Scene to be ready.
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	GameManager.connect("game_state_changed", self, "apply_config")
	ProfileManager.connect("profile_changed", self, "_on_profile_changed")
	ProfileManager.connect("profile_created", self, "_on_profile_created")
	load_config()

func apply_config():
	emit_signal("config_update")

func save_config():
	var config_file = ConfigFile.new()
	for section in config_data:
		for setting in config_data[section]:
			config_file.set_value(section, setting, config_data[section][setting])
	var err = config_file.save(config_path)
	if err == OK:
		emit_signal("config_update")
		return true

func load_config():
	var config_file = ConfigFile.new()
	var err = config_file.load(config_path)
	if err == OK:
		for section in config_data:
			for setting in config_data[section]:
				config_data[section][setting] = config_file.get_value(section, setting, config_data[section][setting])
		emit_signal("config_update")
		return true
	elif err == ERR_FILE_NOT_FOUND:
		return save_config()
	else:
		return false

func reset_to_default(section):
	match section:
		"game":
			config_data.game = config_data_default.game.duplicate(true)
			GameManager.apply_config()
		"video":
			config_data.video = config_data_default.video.duplicate(true)
			VideoManager.apply_config()
		"audio":
			config_data.audio = config_data_default.audio.duplicate(true)
			AudioManager.apply_config()
		"mouse":
			config_data.mouse = config_data_default.mouse.duplicate(true)
		"controller":
			config_data.controller = config_data_default.controller.duplicate(true)
		"keybind":
			InputMap.load_from_globals()
			keybind_defaults()
			config_data.keybind = config_data_default.keybind.duplicate(true)
			InputManager.apply_config_keybind()
	save_config()

func keybind_defaults():
	var config_data_default_keybind = {}
	for action in InputMap.get_actions():
		if not ( action.begins_with('ui_') or action.begins_with('util_') ):
			config_data_default_keybind[action] = {
					"deadzone": 0.5,
					"events": InputMap.get_action_list(action).duplicate(true)
					}
	return config_data_default_keybind.duplicate(true)

func _on_profile_changed():
	config_path = ProfileManager.get_current_profile_path() + CONFIG_FILE
	load_config()

func _on_profile_created():
	config_path = ProfileManager.get_current_profile_path() + CONFIG_FILE
	save_config()

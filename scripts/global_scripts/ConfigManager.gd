extends Node

onready var config_path = "user://config.ini"
onready var audio_manager = get_node("/root/AudioManager")

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

var config_data = {
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
				"master_volume": -40,
				"music_enabled": true,
				"music_volume": -40,
				"fx_enabled": true,
				"fx_volume": -40
				}
		}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_config()
	apply_config()

func apply_config():
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
	AudioServer.set_bus_mute(audio_manager.audio_bus_master, !config_data.audio.master_enabled)
	AudioServer.set_bus_volume_db(audio_manager.audio_bus_master, config_data.audio.master_volume)
	# Music
	AudioServer.set_bus_mute(audio_manager.audio_bus_music, !config_data.audio.music_enabled)
	AudioServer.set_bus_volume_db(audio_manager.audio_bus_music, config_data.audio.music_volume)
	# FX
	AudioServer.set_bus_mute(audio_manager.audio_bus_fx, !config_data.audio.fx_enabled)
	AudioServer.set_bus_volume_db(audio_manager.audio_bus_fx, config_data.audio.fx_volume)

func save_config():
	var config = ConfigFile.new()
	for section in config_data:
		for setting in config_data[section]:
			config.set_value(section, setting, config_data[section][setting])
	var err = config.save(config_path)
	if err == OK:
		return true
	
func load_config():
	var config = ConfigFile.new()
	var err = config.load(config_path)
	if err == OK:
		for section in config_data:
			for setting in config_data[section]:
				config_data[section][setting] = config.get_value(section, setting, config_data[section][setting])
		return true
	elif err == ERR_FILE_NOT_FOUND:
		return save_config()
	else:
		return false

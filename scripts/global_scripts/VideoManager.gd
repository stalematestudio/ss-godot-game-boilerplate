extends Node

onready var main_environment = get_node("/root/main/WorldEnvironment").get_environment()

func _ready():
	apply_config()

func apply_config():
	picture_adjust()
	OS.set_window_fullscreen(ConfigManager.config_data.video.fullscreen)
	OS.set_use_vsync(ConfigManager.config_data.video.vsync)
	if not OS.is_window_fullscreen():
		OS.set_borderless_window(ConfigManager.config_data.video.borderless)
		var screen_size = OS.get_screen_size()
		var config_size = ConfigManager.resolutions[ConfigManager.config_data.video.resolution_option].value
		if ConfigManager.config_data.video.resolution_auto or ( config_size[0] > screen_size[0] ) :
			OS.set_window_size(screen_size)
		else:
			OS.set_window_size(config_size)
		OS.center_window()

func picture_adjust():
	main_environment.set_adjustment_enable(ConfigManager.config_data.video.picture_adjustments)
	if ConfigManager.config_data.video.picture_adjustments:
		main_environment.set_adjustment_brightness(ConfigManager.config_data.video.picture_brightnes)
		main_environment.set_adjustment_contrast(ConfigManager.config_data.video.picture_contrast)
		main_environment.set_adjustment_saturation(ConfigManager.config_data.video.picture_saturation)
	else:
		main_environment.set_adjustment_brightness(1)
		main_environment.set_adjustment_contrast(1)
		main_environment.set_adjustment_saturation(1)
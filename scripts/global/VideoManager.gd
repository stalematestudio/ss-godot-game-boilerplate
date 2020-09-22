extends Node

signal message(message)
signal camera_config_changed

func _ready():
	yield(get_node("/root/main"), "ready") # Wait For Main Scene to be ready.
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	ConfigManager.connect("config_update", self, "apply_config")

func apply_config():
	picture_adjust()
	screen_adjust()
	emit_signal("camera_config_changed")

	OS.set_keep_screen_on(ConfigManager.config_data.video.keep_screen_on)
	OS.set_use_vsync(ConfigManager.config_data.video.vsync)

func picture_adjust():
	var main_environment = get_node("/root/main/WorldEnvironment").get_environment()
	main_environment.set_adjustment_enable(ConfigManager.config_data.video.picture_adjustments)
	if ConfigManager.config_data.video.picture_adjustments:
		main_environment.set_adjustment_brightness(ConfigManager.config_data.video.picture_brightnes)
		main_environment.set_adjustment_contrast(ConfigManager.config_data.video.picture_contrast)
		main_environment.set_adjustment_saturation(ConfigManager.config_data.video.picture_saturation)
	else:
		main_environment.set_adjustment_brightness(1)
		main_environment.set_adjustment_contrast(1)
		main_environment.set_adjustment_saturation(1)

func screen_adjust():
	OS.set_window_fullscreen(ConfigManager.config_data.video.fullscreen)

	var config_res = ConfigManager.resolutions[ConfigManager.config_data.video.resolution_option].value
	var screen_res = OS.get_screen_size()
	var resolution = Vector2()

	if ConfigManager.config_data.video.resolution_auto:
		resolution = screen_res
	else:
		resolution = screen_res if ( config_res[0] > screen_res[0] ) else config_res
	
	get_viewport().set_size(resolution)

	if OS.is_window_fullscreen():
		OS.set_current_screen(ConfigManager.config_data.video.use_screen)
	else:
		OS.set_window_size(resolution)
		OS.set_borderless_window(ConfigManager.config_data.video.borderless)
		if ConfigManager.config_data.video.center_window:
			OS.center_window()

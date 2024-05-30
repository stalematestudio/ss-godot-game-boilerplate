extends Node

signal message(message)
signal camera_config_changed

func _ready():
	await get_node("/root/main").ready # Wait For Main Scene to be ready.
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	ConfigManager.connect("config_update", Callable(self, "apply_config"))

func apply_config():
	picture_adjust()
	screen_adjust()
	emit_signal("camera_config_changed")

	DisplayServer.screen_set_keep_on(ConfigManager.config_data.video.keep_screen_on)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (ConfigManager.config_data.video.vsync) else DisplayServer.VSYNC_DISABLED)

func picture_adjust():
	var main_environment = get_node("/root/main/WorldEnvironment").get_environment()
	main_environment.set_adjustment_enabled(ConfigManager.config_data.video.picture_adjustments)
	if ConfigManager.config_data.video.picture_adjustments:
		main_environment.set_adjustment_brightness(ConfigManager.config_data.video.picture_brightnes)
		main_environment.set_adjustment_contrast(ConfigManager.config_data.video.picture_contrast)
		main_environment.set_adjustment_saturation(ConfigManager.config_data.video.picture_saturation)
	else:
		main_environment.set_adjustment_brightness(1)
		main_environment.set_adjustment_contrast(1)
		main_environment.set_adjustment_saturation(1)

func screen_adjust():
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (ConfigManager.config_data.video.fullscreen) else Window.MODE_WINDOWED

	var config_res = ConfigManager.resolutions[ConfigManager.config_data.video.resolution_option].value
	var screen_res = DisplayServer.screen_get_size()
	var resolution = Vector2()

	if ConfigManager.config_data.video.resolution_auto:
		resolution = screen_res
	else:
		resolution = screen_res if (config_res[0] > screen_res[0]) else config_res
	
	get_viewport().set_size(resolution)

	if ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)):
		get_window().set_current_screen(ConfigManager.config_data.video.use_screen)
	else:
		get_window().set_size(resolution)
		get_window().borderless = (ConfigManager.config_data.video.borderless)
		if ConfigManager.config_data.video.center_window:
			get_window().move_to_center()

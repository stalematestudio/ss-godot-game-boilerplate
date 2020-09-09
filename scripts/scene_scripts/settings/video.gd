extends Tabs

onready var gui_picture_adjustments = $Settings_Scroll/Settings_VBC/Adjustments_CheckButton

onready var gui_brightnes_label = $Settings_Scroll/Settings_VBC/Brightnes_HBC/Brightnes_Label
onready var gui_brightnes_slider = $Settings_Scroll/Settings_VBC/Brightnes_HBC/Brightnes_Slider
onready var gui_brightnes_display = $Settings_Scroll/Settings_VBC/Brightnes_HBC/Brightnes_Value

onready var gui_contrast_label = $Settings_Scroll/Settings_VBC/Contrast_HBC/Contrast_Label
onready var gui_contrast_slider = $Settings_Scroll/Settings_VBC/Contrast_HBC/Contrast_Slider
onready var gui_contrast_display = $Settings_Scroll/Settings_VBC/Contrast_HBC/Contrast_Value

onready var gui_saturation_label = $Settings_Scroll/Settings_VBC/Saturation_HBC/Saturation_Label
onready var gui_saturation_slider = $Settings_Scroll/Settings_VBC/Saturation_HBC/Saturation_Slider
onready var gui_saturation_display = $Settings_Scroll/Settings_VBC/Saturation_HBC/Saturation_Value

onready var gui_keep_screen_on = $Settings_Scroll/Settings_VBC/KeepScreenOn_CheckButton
onready var gui_vsync = $Settings_Scroll/Settings_VBC/VSync_CheckButton

onready var gui_fullscreen = $Settings_Scroll/Settings_VBC/FullScreen_CheckButton

onready var gui_screen_label = $Settings_Scroll/Settings_VBC/ScreenSelect_HBC/ScreenSelect_Label
onready var gui_screen_option = $Settings_Scroll/Settings_VBC/ScreenSelect_HBC/ScreenSelect_Option

onready var gui_borderless = $Settings_Scroll/Settings_VBC/Borderless_CheckButton
onready var gui_centered = $Settings_Scroll/Settings_VBC/Centered_CheckButton
onready var gui_resolution_auto = $Settings_Scroll/Settings_VBC/ResolutionAuto_CheckButton
onready var gui_resolution_label = $Settings_Scroll/Settings_VBC/Resolution_HBC/Resolution_Label
onready var gui_resolution_option = $Settings_Scroll/Settings_VBC/Resolution_HBC/Resolution_Option

func _ready():
	gui_picture_adjustments.connect("pressed", self, "picture_adjust")
	gui_brightnes_slider.connect("value_changed", self, "brightnes_adjust")
	gui_contrast_slider.connect("value_changed", self, "contrast_adjust")
	gui_saturation_slider.connect("value_changed", self, "saturation_adjust")
	
	gui_keep_screen_on.connect("pressed", self, "keep_screen_on_adjust")
	gui_vsync.connect("pressed", self, "vsync_adjust")
	
	gui_fullscreen.connect("pressed", self, "fullscreen_adjust")

	for screen in range(OS.get_screen_count()):
		gui_screen_option.add_item("Screen : " + String(screen), screen)
	gui_screen_option.connect("item_selected", self, "screen_option_adjust")

	gui_borderless.connect("pressed", self, "borderless_adjust")
	gui_centered.connect("pressed", self, "centered_adjust")
	gui_resolution_auto.connect("pressed", self, "resolution_auto_adjust")
	
	for resolution in ConfigManager.resolutions:
		if resolution.value[0] <= OS.get_screen_size()[0]:
			gui_resolution_option.add_item(resolution.name)
	gui_resolution_option.connect("item_selected", self, "resolution_option_adjust")

func set_form_values():
	gui_picture_adjustments.set_pressed(ConfigManager.config_data.video.picture_adjustments)
	gui_brightnes_slider.set_value(ConfigManager.config_data.video.picture_brightnes)
	gui_contrast_slider.set_value(ConfigManager.config_data.video.picture_contrast)
	gui_saturation_slider.set_value(ConfigManager.config_data.video.picture_saturation)
	
	gui_keep_screen_on.set_pressed(ConfigManager.config_data.video.keep_screen_on)
	gui_vsync.set_pressed(ConfigManager.config_data.video.vsync)
	
	gui_fullscreen.set_pressed(ConfigManager.config_data.video.fullscreen)

	gui_screen_option.select(ConfigManager.config_data.video.use_screen)

	gui_borderless.set_pressed(ConfigManager.config_data.video.borderless)
	gui_centered.set_pressed(ConfigManager.config_data.video.center_window)
	gui_resolution_auto.set_pressed(ConfigManager.config_data.video.resolution_auto)
	if ( gui_resolution_option.get_item_count() - 1 ) < ConfigManager.config_data.video.resolution_option:
		gui_resolution_option.select( gui_resolution_option.get_item_count() - 1 )
	else:
		gui_resolution_option.select(ConfigManager.config_data.video.resolution_option)
	
	set_elements_disabled()

func set_elements_disabled():
	if gui_picture_adjustments.is_pressed():
		gui_brightnes_label.set_self_modulate(Color("#ffffffff"))
		gui_brightnes_slider.set_editable(true)
		gui_brightnes_display.set_self_modulate(Color("#ffffffff"))

		gui_contrast_label.set_self_modulate(Color("#ffffffff"))
		gui_contrast_slider.set_editable(true)
		gui_contrast_display.set_self_modulate(Color("#ffffffff"))

		gui_saturation_label.set_self_modulate(Color("#ffffffff"))
		gui_saturation_slider.set_editable(true)
		gui_saturation_display.set_self_modulate(Color("#ffffffff"))
	else:
		gui_brightnes_label.set_self_modulate(Color("#40ffffff"))
		gui_brightnes_slider.set_editable(false)
		gui_brightnes_display.set_self_modulate(Color("#40ffffff"))

		gui_contrast_label.set_self_modulate(Color("#40ffffff"))
		gui_contrast_slider.set_editable(false)
		gui_contrast_display.set_self_modulate(Color("#40ffffff"))

		gui_saturation_label.set_self_modulate(Color("#40ffffff"))
		gui_saturation_slider.set_editable(false)
		gui_saturation_display.set_self_modulate(Color("#40ffffff"))
	
	var disabled_by_fullscreen = gui_fullscreen.is_pressed()
	var disabled_by_resolution_auto = gui_resolution_auto.is_pressed()
	
	if (disabled_by_fullscreen):
		gui_screen_label.set_self_modulate(Color("#ffffffff"))
		gui_screen_option.set_disabled(false)
	else:
		gui_screen_label.set_self_modulate(Color("#40ffffff"))
		gui_screen_option.set_disabled(true)

	gui_borderless.set_disabled(disabled_by_fullscreen)
	gui_centered.set_disabled(disabled_by_fullscreen)
	gui_resolution_auto.set_disabled(disabled_by_fullscreen)
	gui_resolution_option.set_disabled( disabled_by_fullscreen or disabled_by_resolution_auto )
	
	if ( disabled_by_fullscreen or disabled_by_resolution_auto ):
		gui_resolution_label.set_self_modulate(Color("#40ffffff"))
	else:
		gui_resolution_label.set_self_modulate(Color("#ffffffff"))

func picture_adjust():
	ConfigManager.config_data.video.picture_adjustments = gui_picture_adjustments.is_pressed()
	VideoManager.picture_adjust()
	set_elements_disabled()

func brightnes_adjust(new_val):
	ConfigManager.config_data.video.picture_brightnes = new_val
	VideoManager.picture_adjust()
	gui_brightnes_display.set_text(String(new_val))

func contrast_adjust(new_val):
	ConfigManager.config_data.video.picture_contrast = new_val
	VideoManager.picture_adjust()
	gui_contrast_display.set_text(String(new_val))

func saturation_adjust(new_val):
	ConfigManager.config_data.video.picture_saturation = new_val
	VideoManager.picture_adjust()
	gui_saturation_display.set_text(String(new_val))

func keep_screen_on_adjust():
	ConfigManager.config_data.video.keep_screen_on = gui_keep_screen_on.is_pressed()

func vsync_adjust():
	ConfigManager.config_data.video.vsync = gui_vsync.is_pressed()

func screen_option_adjust(new_val):
	ConfigManager.config_data.video.use_screen = new_val

func fullscreen_adjust():
	ConfigManager.config_data.video.fullscreen = gui_fullscreen.is_pressed()
	set_elements_disabled()

func borderless_adjust():
	ConfigManager.config_data.video.borderless = gui_borderless.is_pressed()

func centered_adjust():
	ConfigManager.config_data.video.center_window = gui_centered.is_pressed()

func resolution_auto_adjust():
	ConfigManager.config_data.video.resolution_auto = gui_resolution_auto.is_pressed()
	set_elements_disabled()

func resolution_option_adjust(new_val):
	ConfigManager.config_data.video.resolution_option = new_val

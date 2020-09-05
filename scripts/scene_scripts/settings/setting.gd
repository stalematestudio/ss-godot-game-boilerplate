extends Node

export (PackedScene) var keybind_action

# Set gui elements
onready var gui_tabs = $VBC/Settings_Tabs
onready var gui_game_tab = $VBC/Tab_Buttons/Game_Tab_Button
onready var gui_video_tab = $VBC/Tab_Buttons/Video_Tab_Button
onready var gui_audio_tab = $VBC/Tab_Buttons/Audio_Tab_Button
onready var gui_mouse_tab = $VBC/Tab_Buttons/Mouse_Tab_Button
onready var gui_controller_tab = $VBC/Tab_Buttons/Controller_Tab_Button
onready var gui_key_binding_tab = $VBC/Tab_Buttons/Keybinding_Tab_Button

onready var gui_apply = $VBC/Apply
onready var gui_cancel = $VBC/Cancel

# Return focus
var return_focus_target

# Game
onready var gui_subtitles = $VBC/Settings_Tabs/Game_Tab/Settings_Scroll/Settings_VBC/SubTitles_CheckButton
onready var gui_debug = $VBC/Settings_Tabs/Game_Tab/Settings_Scroll/Settings_VBC/Debug_CheckButton
onready var gui_game_reset = $VBC/Settings_Tabs/Game_Tab/Settings_Scroll/Settings_VBC/Reset_Button

# Video
onready var gui_picture_adjustments = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/Adjustments_CheckButton

onready var gui_brightnes_label = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/Brightnes_HBC/Brightnes_Label
onready var gui_brightnes_slider = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/Brightnes_HBC/Brightnes_Slider
onready var gui_brightnes_display = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/Brightnes_HBC/Brightnes_Value

onready var gui_contrast_label = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/Contrast_HBC/Contrast_Label
onready var gui_contrast_slider = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/Contrast_HBC/Contrast_Slider
onready var gui_contrast_display = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/Contrast_HBC/Contrast_Value

onready var gui_saturation_label = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/Saturation_HBC/Saturation_Label
onready var gui_saturation_slider = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/Saturation_HBC/Saturation_Slider
onready var gui_saturation_display = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/Saturation_HBC/Saturation_Value

onready var gui_fullscreen = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/FullScreen_CheckButton
onready var gui_vsync = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/VSync_CheckButton
onready var gui_borderless = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/Borderless_CheckButton
onready var gui_resolution_auto = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/ResolutionAuto_CheckButton
onready var gui_resolution_label = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/Resolution_HBC/Resolution_Label
onready var gui_resolution_option = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/Resolution_HBC/Resolution_Option
onready var gui_video_reset = $VBC/Settings_Tabs/Video_Tab/Settings_Scroll/Settings_VBC/Reset_Button

# Audio
onready var gui_master = $VBC/Settings_Tabs/Audio_Tab/Settings_Scroll/Settings_VBC/Master_CheckButton
onready var gui_master_slider = $VBC/Settings_Tabs/Audio_Tab/Settings_Scroll/Settings_VBC/Master_HBC/Master_Slider
onready var gui_master_display = $VBC/Settings_Tabs/Audio_Tab/Settings_Scroll/Settings_VBC/Master_HBC/Master_Value

onready var gui_music = $VBC/Settings_Tabs/Audio_Tab/Settings_Scroll/Settings_VBC/Music_CheckButton
onready var gui_music_slider = $VBC/Settings_Tabs/Audio_Tab/Settings_Scroll/Settings_VBC/Music_HBC/Music_Slider
onready var gui_music_display = $VBC/Settings_Tabs/Audio_Tab/Settings_Scroll/Settings_VBC/Music_HBC/Music_Value

onready var gui_voice = $VBC/Settings_Tabs/Audio_Tab/Settings_Scroll/Settings_VBC/Voice_CheckButton
onready var gui_voice_slider = $VBC/Settings_Tabs/Audio_Tab/Settings_Scroll/Settings_VBC/Voice_HBC/Voice_Slider
onready var gui_voice_display = $VBC/Settings_Tabs/Audio_Tab/Settings_Scroll/Settings_VBC/Voice_HBC/Voice_Value

onready var gui_fx = $VBC/Settings_Tabs/Audio_Tab/Settings_Scroll/Settings_VBC/FX_CheckButton
onready var gui_fx_slider = $VBC/Settings_Tabs/Audio_Tab/Settings_Scroll/Settings_VBC/FX_HBC/FX_Slider
onready var gui_fx_display = $VBC/Settings_Tabs/Audio_Tab/Settings_Scroll/Settings_VBC/FX_HBC/FX_Value

onready var gui_audio_reset = $VBC/Settings_Tabs/Audio_Tab/Settings_Scroll/Settings_VBC/Reset_Button

# Mouse
onready var gui_mouse_horizontal_invert = $VBC/Settings_Tabs/Mouse_Tab/Settings_Scroll/Settings_VBC/Horizontal_CheckButton
onready var gui_mouse_horizontal_sensitivity_slider = $VBC/Settings_Tabs/Mouse_Tab/Settings_Scroll/Settings_VBC/Horizontal_HBC/Horizontal_Slider
onready var gui_mouse_horizontal_sensitivity_display = $VBC/Settings_Tabs/Mouse_Tab/Settings_Scroll/Settings_VBC/Horizontal_HBC/Horizontal_Value

onready var gui_mouse_vertical_invert = $VBC/Settings_Tabs/Mouse_Tab/Settings_Scroll/Settings_VBC/Vertical_CheckButton
onready var gui_mouse_vertical_sensitivity_slider = $VBC/Settings_Tabs/Mouse_Tab/Settings_Scroll/Settings_VBC/Vertical_HBC/Vertical_Slider
onready var gui_mouse_vertical_sensitivity_display = $VBC/Settings_Tabs/Mouse_Tab/Settings_Scroll/Settings_VBC/Vertical_HBC/Vertical_Value

onready var gui_mouse_scroll_invert = $VBC/Settings_Tabs/Mouse_Tab/Settings_Scroll/Settings_VBC/Scroll_CheckButton
onready var gui_mouse_scroll_sensitivity_slider = $VBC/Settings_Tabs/Mouse_Tab/Settings_Scroll/Settings_VBC/Scroll_HBC/Scroll_Slider
onready var gui_mouse_scroll_sensitivity_display = $VBC/Settings_Tabs/Mouse_Tab/Settings_Scroll/Settings_VBC/Scroll_HBC/Scroll_Value

onready var gui_mouse_reset = $VBC/Settings_Tabs/Mouse_Tab/Settings_Scroll/Settings_VBC/Reset_Button

# Controller
onready var gui_controller_label = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/Controller_HBC/Controller_Label
onready var gui_controller_option = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/Controller_HBC/Controller_OptionButton
onready var gui_controller_refresh_button = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/Controller_HBC/Controller_Refresh_Button

onready var gui_vibration = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/Vibration_CheckButton

onready var gui_weak_magnitude_label = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/WM_HBC/WM_Label
onready var gui_weak_magnitude_slider = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/WM_HBC/WM_Slider
onready var gui_weak_magnitude_display = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/WM_HBC/WM_Value

onready var gui_strong_magnitude_label = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/SM_HBC/SM_Label
onready var gui_strong_magnitude_slider = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/SM_HBC/SM_Slider
onready var gui_strong_magnitude_display = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/SM_HBC/SM_Value

onready var gui_weak_magnitude_test = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/TM_HBC/WM_Button
onready var gui_strong_magnitude_test = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/TM_HBC/SM_Button
onready var gui_magnitude_test = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/TM_HBC/CM_Button

onready var gui_controller_left_y_invert = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/LY_CheckButton
onready var gui_controller_left_y_sensitivity_slider = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/LY_HBC/LY_Slider
onready var gui_controller_left_y_sensitivity_display = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/LY_HBC/LY_Value

onready var gui_controller_left_x_invert = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/LX_CheckButton
onready var gui_controller_left_x_sensitivity_slider = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/LX_HBC/LX_Slider
onready var gui_controller_left_x_sensitivity_display = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/LX_HBC/LX_Value

onready var gui_controller_right_y_invert = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/RY_CheckButton
onready var gui_controller_right_y_sensitivity_slider = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/RY_HBC/RY_Slider
onready var gui_controller_right_y_sensitivity_display = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/RY_HBC/RY_Value

onready var gui_controller_right_x_invert = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/RX_CheckButton
onready var gui_controller_right_x_sensitivity_slider = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/RX_HBC/RX_Slider
onready var gui_controller_right_x_sensitivity_display = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/RX_HBC/RX_Value

onready var gui_controllers_reset = $VBC/Settings_Tabs/Controller_Tab/Settings_Scroll/Settings_VBC/Reset_Button

# Key Binding 
onready var gui_key_binding_vbc = $VBC/Settings_Tabs/Keybinding_Tab/Settings_Scroll/Settings_VBC/Key_Bind_VBC
onready var gui_key_binding_reset = $VBC/Settings_Tabs/Keybinding_Tab/Settings_Scroll/Settings_VBC/Reset_Button

func _ready():
	.connect("tree_exiting", self, "_on_tree_exiting")
	gui_game_tab.grab_focus()
	# Set Settings Menu
	gui_game_tab.connect("pressed", self, "settings_menu_tab_switch", [0])
	gui_video_tab.connect("pressed", self, "settings_menu_tab_switch", [1])
	gui_audio_tab.connect("pressed", self, "settings_menu_tab_switch", [2])
	gui_mouse_tab.connect("pressed", self, "settings_menu_tab_switch", [3])
	gui_controller_tab.connect("pressed", self, "settings_menu_tab_switch", [4])
	gui_key_binding_tab.connect("pressed", self, "settings_menu_tab_switch", [5])
	
	# Apply cancel
	gui_apply.connect("pressed", self, "settings_menu_apply_cancel", ["apply"])
	gui_cancel.connect("pressed", self, "settings_menu_apply_cancel", ["cancel"])
	
	# Game
	gui_subtitles.connect("pressed", self, "subtitle_adjust")
	gui_debug.connect("pressed", self, "debug_adjust")
	gui_game_reset.connect("pressed", self, "reset_to_default", ["game"])
	
	# Video
	gui_picture_adjustments.connect("pressed", self, "picture_adjust")
	gui_brightnes_slider.connect("value_changed", self, "brightnes_adjust")
	gui_contrast_slider.connect("value_changed", self, "contrast_adjust")
	gui_saturation_slider.connect("value_changed", self, "saturation_adjust")

	gui_fullscreen.connect("pressed", self, "fullscreen_adjust")
	gui_vsync.connect("pressed", self, "vsync_adjust")
	gui_borderless.connect("pressed", self, "borderless_adjust")
	gui_resolution_auto.connect("pressed", self, "resolution_auto_adjust")
	
	for resolution in ConfigManager.resolutions:
		if resolution.value[0] <= OS.get_screen_size()[0]:
			gui_resolution_option.add_item(resolution.name)
	gui_resolution_option.connect("item_selected", self, "resolution_option_adjust")
	
	gui_video_reset.connect("pressed", self, "reset_to_default", ["video"])
	
	# Audio
	gui_master.connect("pressed", self, "master_adjust")
	gui_master_slider.connect("value_changed", self, "master_volume_adjust")
	
	gui_music.connect("pressed", self, "music_adjust")
	gui_music_slider.connect("value_changed", self, "music_volume_adjust")

	gui_voice.connect("pressed", self, "voice_adjust")
	gui_voice_slider.connect("value_changed", self, "voice_volume_adjust")

	gui_fx.connect("pressed", self, "fx_adjust")
	gui_fx_slider.connect("value_changed", self, "fx_volume_adjust")
	
	gui_audio_reset.connect("pressed", self, "reset_to_default", ["audio"])
	
	# Mouse
	gui_mouse_horizontal_invert.connect("pressed", self, "mouse_horizontal_invert_adjust")
	gui_mouse_horizontal_sensitivity_slider.connect("value_changed", self, "mouse_horizontal_sensitivity_adjust")
	
	gui_mouse_vertical_invert.connect("pressed", self, "mouse_vertical_invert_adjust")
	gui_mouse_vertical_sensitivity_slider.connect("value_changed", self, "mouse_vertical_sensitivity_adjust")
	
	gui_mouse_scroll_invert.connect("pressed", self, "mouse_scroll_invert_adjust")
	gui_mouse_scroll_sensitivity_slider.connect("value_changed", self, "mouse_scroll_sensitivity_adjust")
	
	gui_mouse_reset.connect("pressed", self, "reset_to_default", ["mouse"])
	
	# Controller
	controllers_list()
	gui_controller_option.connect("item_selected", self, "controller_select")
	gui_controller_refresh_button.connect("pressed", self, "controllers_list")
	Input.connect("joy_connection_changed", self, "controllers_list_changed")

	gui_vibration.connect("pressed", self, "vibration_adjust")

	gui_weak_magnitude_slider.connect("value_changed", self, "weak_magnitude_adjust")
	gui_strong_magnitude_slider.connect("value_changed", self, "strong_magnitude_adjust")
	
	gui_weak_magnitude_test.connect("pressed", self, "weak_magnitude_test")
	gui_strong_magnitude_test.connect("pressed", self, "strong_magnitude_test")
	gui_magnitude_test.connect("pressed", self, "vibration_magnitude_test")

	gui_controller_left_y_invert.connect("pressed", self, "left_y_invert_adjust")
	gui_controller_left_y_sensitivity_slider.connect("value_changed", self, "left_y_sensitivity_adjust")
	
	gui_controller_left_x_invert.connect("pressed", self, "left_x_invert_adjust")
	gui_controller_left_x_sensitivity_slider.connect("value_changed", self, "left_x_sensitivity_adjust")
	
	gui_controller_right_y_invert.connect("pressed", self, "right_y_invert_adjust")
	gui_controller_right_y_sensitivity_slider.connect("value_changed", self, "right_y_sensitivity_adjust")
	
	gui_controller_right_x_invert.connect("pressed", self, "right_x_invert_adjust")
	gui_controller_right_x_sensitivity_slider.connect("value_changed", self, "right_x_sensitivity_adjust")
	
	gui_controllers_reset.connect("pressed", self, "reset_to_default", ["controller"])
	
	# Key Binding
	gui_key_binding_reset.connect("pressed", self, "reset_to_default", ["keybinding"])

	set_form_values()

func _on_tree_exiting():
	if is_instance_valid(return_focus_target):
		return_focus_target.grab_focus()

func set_form_values():
	# Set Settings Values
	ConfigManager.load_config()
	
	# Game
	gui_subtitles.set_pressed(ConfigManager.config_data.game.subtitles)
	gui_debug.set_pressed(ConfigManager.config_data.game.debug)
	
	# Video
	gui_picture_adjustments.set_pressed(ConfigManager.config_data.video.picture_adjustments)
	gui_brightnes_slider.set_value(ConfigManager.config_data.video.picture_brightnes)
	gui_contrast_slider.set_value(ConfigManager.config_data.video.picture_contrast)
	gui_saturation_slider.set_value(ConfigManager.config_data.video.picture_saturation)

	gui_fullscreen.set_pressed(ConfigManager.config_data.video.fullscreen)
	gui_vsync.set_pressed(ConfigManager.config_data.video.vsync)
	gui_borderless.set_pressed(ConfigManager.config_data.video.borderless)
	gui_resolution_auto.set_pressed(ConfigManager.config_data.video.resolution_auto)
	if ( gui_resolution_option.get_item_count() - 1 ) < ConfigManager.config_data.video.resolution_option:
		gui_resolution_option.select( gui_resolution_option.get_item_count() - 1 )
	else:
		gui_resolution_option.select(ConfigManager.config_data.video.resolution_option)
	
	# Audio
	gui_master.set_pressed(ConfigManager.config_data.audio.master_enabled)
	gui_master_slider.set_value(ConfigManager.config_data.audio.master_volume)
	master_volume_adjust(ConfigManager.config_data.audio.master_volume)
	
	gui_music.set_pressed(ConfigManager.config_data.audio.music_enabled)
	gui_music_slider.set_value(ConfigManager.config_data.audio.music_volume)
	music_volume_adjust(ConfigManager.config_data.audio.music_volume)
	
	gui_voice.set_pressed(ConfigManager.config_data.audio.voice_enabled)
	gui_voice_slider.set_value(ConfigManager.config_data.audio.voice_volume)
	voice_volume_adjust(ConfigManager.config_data.audio.voice_volume)

	gui_fx.set_pressed(ConfigManager.config_data.audio.fx_enabled)
	gui_fx_slider.set_value(ConfigManager.config_data.audio.fx_volume)
	fx_volume_adjust(ConfigManager.config_data.audio.fx_volume)
	
	# Mouse
	gui_mouse_horizontal_invert.set_pressed(ConfigManager.config_data.mouse.mouse_inverted_x)
	gui_mouse_horizontal_sensitivity_slider.set_value(ConfigManager.config_data.mouse.mouse_sensitivity_x)
	
	gui_mouse_vertical_invert.set_pressed(ConfigManager.config_data.mouse.mouse_inverted_y)
	gui_mouse_vertical_sensitivity_slider.set_value(ConfigManager.config_data.mouse.mouse_sensitivity_y)
	
	gui_mouse_scroll_invert.set_pressed(ConfigManager.config_data.mouse.mouse_inverted_scroll)
	gui_mouse_scroll_sensitivity_slider.set_value(ConfigManager.config_data.mouse.mouse_sensitivity_scroll)
	
	# Controller
	gui_vibration.set_pressed(ConfigManager.config_data.controller.vibration)
	gui_weak_magnitude_slider.set_value(ConfigManager.config_data.controller.weak_magnitude)
	gui_strong_magnitude_slider.set_value(ConfigManager.config_data.controller.strong_magnitude)

	gui_controller_left_y_invert.set_pressed(ConfigManager.config_data.controller.left_y_inverted)
	gui_controller_left_y_sensitivity_slider.set_value(ConfigManager.config_data.controller.left_y_sensitivity)
	
	gui_controller_left_x_invert.set_pressed(ConfigManager.config_data.controller.left_y_inverted)
	gui_controller_left_x_sensitivity_slider.set_value(ConfigManager.config_data.controller.left_y_sensitivity)
	
	gui_controller_right_y_invert.set_pressed(ConfigManager.config_data.controller.right_y_inverted)
	gui_controller_right_y_sensitivity_slider.set_value(ConfigManager.config_data.controller.right_y_sensitivity)
	
	gui_controller_right_x_invert.set_pressed(ConfigManager.config_data.controller.right_x_inverted)
	gui_controller_right_x_sensitivity_slider.set_value(ConfigManager.config_data.controller.right_x_sensitivity)
	
	# Key Binding
	set_key_binding_form()

	# Set inactive / disabled elements
	set_elements_disabled()

func set_key_binding_form():
	Helpers.RemoveChildren(gui_key_binding_vbc)
	for action in ConfigManager.config_data.keybinding:
		var action_element = keybind_action.instance()
		action_element.name = action
		action_element.action = action
		gui_key_binding_vbc.add_child(action_element)

func set_elements_disabled():
	# Video
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
	
	gui_borderless.set_disabled(disabled_by_fullscreen)
	gui_resolution_auto.set_disabled(disabled_by_fullscreen)
	gui_resolution_option.set_disabled( disabled_by_fullscreen or disabled_by_resolution_auto )
	
	if ( disabled_by_fullscreen or disabled_by_resolution_auto ):
		gui_resolution_label.set_self_modulate(Color("#40ffffff"))
	else:
		gui_resolution_label.set_self_modulate(Color("#ffffffff"))
	
	# Audio
	if gui_master.is_pressed():
		gui_master_slider.set_editable(true)
		gui_master_display.set_self_modulate(Color("#ffffffff"))
	else:
		gui_master_slider.set_editable(false)
		gui_master_display.set_self_modulate(Color("#40ffffff"))
	
	if gui_music.is_pressed():
		gui_music_slider.set_editable(true)
		gui_music_display.set_self_modulate(Color("#ffffffff"))
	else:
		gui_music_slider.set_editable(false)
		gui_music_display.set_self_modulate(Color("#40ffffff"))

	if gui_voice.is_pressed():
		gui_voice_slider.set_editable(true)
		gui_voice_display.set_self_modulate(Color("#ffffffff"))
	else:
		gui_voice_slider.set_editable(false)
		gui_voice_display.set_self_modulate(Color("#40ffffff"))

	if gui_fx.is_pressed():
		gui_fx_slider.set_editable(true)
		gui_fx_display.set_self_modulate(Color("#ffffffff"))
	else:
		gui_fx_slider.set_editable(false)
		gui_fx_display.set_self_modulate(Color("#40ffffff"))

	# Controller
	if ConfigManager.joypad_present:
		gui_controller_label.set_self_modulate(Color("#ffffffff"))
		gui_controller_option.set_disabled(false)
		gui_controller_refresh_button.set_disabled(false)
		gui_vibration.set_disabled(false)
	else:
		gui_controller_label.set_self_modulate(Color("#40ffffff"))
		gui_controller_option.set_disabled(true)
		gui_controller_refresh_button.set_disabled(true)
		gui_vibration.set_disabled(true)

	if gui_vibration.is_pressed() and ConfigManager.joypad_present:
		gui_weak_magnitude_label.set_self_modulate(Color("#ffffffff"))
		gui_weak_magnitude_slider.set_editable(true)
		gui_weak_magnitude_display.set_self_modulate(Color("#ffffffff"))
				
		gui_strong_magnitude_label.set_self_modulate(Color("#ffffffff"))
		gui_strong_magnitude_slider.set_editable(true)
		gui_strong_magnitude_display.set_self_modulate(Color("#ffffffff"))
		
		gui_weak_magnitude_test.set_disabled(false)
		gui_strong_magnitude_test.set_disabled(false)
		gui_magnitude_test.set_disabled(false)
	else:
		gui_weak_magnitude_label.set_self_modulate(Color("#40ffffff"))
		gui_weak_magnitude_slider.set_editable(false)
		gui_weak_magnitude_display.set_self_modulate(Color("#40ffffff"))
		
		gui_strong_magnitude_label.set_self_modulate(Color("#40ffffff"))
		gui_strong_magnitude_slider.set_editable(false)
		gui_strong_magnitude_display.set_self_modulate(Color("#40ffffff"))

		gui_weak_magnitude_test.set_disabled(true)
		gui_strong_magnitude_test.set_disabled(true)
		gui_magnitude_test.set_disabled(true)

# Game
func subtitle_adjust():
	ConfigManager.config_data.game.subtitles = gui_subtitles.is_pressed()

func debug_adjust():
	ConfigManager.config_data.game.debug = gui_debug.is_pressed()

# Video
func picture_adjust():
	ConfigManager.config_data.video.picture_adjustments = gui_picture_adjustments.is_pressed()
	ConfigManager.picture_adjust()
	set_elements_disabled()

func brightnes_adjust(new_val):
	ConfigManager.config_data.video.picture_brightnes = new_val
	ConfigManager.picture_adjust()
	gui_brightnes_display.set_text(String(new_val))

func contrast_adjust(new_val):
	ConfigManager.config_data.video.picture_contrast = new_val
	ConfigManager.picture_adjust()
	gui_contrast_display.set_text(String(new_val))

func saturation_adjust(new_val):
	ConfigManager.config_data.video.picture_saturation = new_val
	ConfigManager.picture_adjust()
	gui_saturation_display.set_text(String(new_val))

func fullscreen_adjust():
	ConfigManager.config_data.video.fullscreen = gui_fullscreen.is_pressed()
	set_elements_disabled()

func vsync_adjust():
	ConfigManager.config_data.video.vsync = gui_vsync.is_pressed()

func borderless_adjust():
	ConfigManager.config_data.video.borderless = gui_borderless.is_pressed()

func resolution_auto_adjust():
	ConfigManager.config_data.video.resolution_auto = gui_resolution_auto.is_pressed()
	set_elements_disabled()

func resolution_option_adjust(new_val):
	ConfigManager.config_data.video.resolution_option = new_val

# Audio
func master_adjust():
	ConfigManager.config_data.audio.master_enabled = gui_master.is_pressed()
	AudioServer.set_bus_mute(AudioManager.audio_bus_master, !ConfigManager.config_data.audio.master_enabled)
	set_elements_disabled()

func master_volume_adjust(new_val):
	ConfigManager.config_data.audio.master_volume = new_val
	AudioServer.set_bus_volume_db(AudioManager.audio_bus_master, ConfigManager.config_data.audio.master_volume)
	gui_master_display.text = String(ConfigManager.config_data.audio.master_volume)+"dB"

func music_adjust():
	ConfigManager.config_data.audio.music_enabled = gui_music.is_pressed()
	AudioServer.set_bus_mute(AudioManager.audio_bus_music, !ConfigManager.config_data.audio.music_enabled)
	set_elements_disabled()

func music_volume_adjust(new_val):
	ConfigManager.config_data.audio.music_volume = new_val
	AudioServer.set_bus_volume_db(AudioManager.audio_bus_music, ConfigManager.config_data.audio.music_volume)
	gui_music_display.text = String(ConfigManager.config_data.audio.music_volume)+"dB"

func voice_adjust():
	ConfigManager.config_data.audio.voice_enabled = gui_voice.is_pressed()
	AudioServer.set_bus_mute(AudioManager.audio_bus_voice, !ConfigManager.config_data.audio.voice_enabled)
	set_elements_disabled()

func voice_volume_adjust(new_val):
	ConfigManager.config_data.audio.voice_volume = new_val
	AudioServer.set_bus_volume_db(AudioManager.audio_bus_voice, ConfigManager.config_data.audio.voice_volume)
	gui_voice_display.text = String(ConfigManager.config_data.audio.voice_volume)+"dB"

func fx_adjust():
	ConfigManager.config_data.audio.fx_enabled = gui_fx.is_pressed()
	AudioServer.set_bus_mute(AudioManager.audio_bus_fx, !ConfigManager.config_data.audio.fx_enabled)
	set_elements_disabled()

func fx_volume_adjust(new_val):
	ConfigManager.config_data.audio.fx_volume = new_val
	AudioServer.set_bus_volume_db(AudioManager.audio_bus_fx, ConfigManager.config_data.audio.fx_volume)
	gui_fx_display.text = String(ConfigManager.config_data.audio.fx_volume)+"dB"

# Mouse
func mouse_horizontal_invert_adjust():
	ConfigManager.config_data.mouse.mouse_inverted_x = gui_mouse_horizontal_invert.is_pressed()

func mouse_horizontal_sensitivity_adjust(new_val):
	ConfigManager.config_data.mouse.mouse_sensitivity_x = new_val
	gui_mouse_horizontal_sensitivity_display.text = String(ConfigManager.config_data.mouse.mouse_sensitivity_x)

func mouse_vertical_invert_adjust():
	ConfigManager.config_data.mouse.mouse_inverted_y = gui_mouse_vertical_invert.is_pressed()

func mouse_vertical_sensitivity_adjust(new_val):
	ConfigManager.config_data.mouse.mouse_sensitivity_y = new_val
	gui_mouse_vertical_sensitivity_display.text = String(ConfigManager.config_data.mouse.mouse_sensitivity_y)

func mouse_scroll_invert_adjust():
	ConfigManager.config_data.mouse.mouse_inverted_scroll = gui_mouse_scroll_invert.is_pressed()

func mouse_scroll_sensitivity_adjust(new_val):
	ConfigManager.config_data.mouse.mouse_sensitivity_scroll = new_val
	gui_mouse_scroll_sensitivity_display.text = String(ConfigManager.config_data.mouse.mouse_sensitivity_scroll)

# Controller
func controller_select(new_val):
	ConfigManager.joypad_device_id = new_val
	set_key_binding_form()

func controllers_list():
	gui_controller_option.clear()
	if ConfigManager.joypad_present:
		for j_pad in Input.get_connected_joypads():
			gui_controller_option.add_item(String(j_pad) + " : " + Input.get_joy_name( j_pad ), j_pad )
		gui_controller_option.select(ConfigManager.joypad_device_id)

func controllers_list_changed(device, connected):
	if connected:
		controllers_list()
	else:
		gui_controller_option.remove_item(device)
		if ConfigManager.joypad_present:
			gui_controller_option.select(ConfigManager.joypad_device_id)
	set_key_binding_form()
	set_elements_disabled()

# Vibration
func vibration_adjust():
	ConfigManager.config_data.controller.vibration = gui_vibration.is_pressed()
	set_elements_disabled()

func weak_magnitude_adjust(new_val):
	ConfigManager.config_data.controller.weak_magnitude = new_val
	gui_weak_magnitude_display.set_text(String(ConfigManager.config_data.controller.weak_magnitude))

func strong_magnitude_adjust(new_val):
	ConfigManager.config_data.controller.strong_magnitude = new_val
	gui_strong_magnitude_display.set_text(String(ConfigManager.config_data.controller.strong_magnitude))

func weak_magnitude_test():
	Input.start_joy_vibration(ConfigManager.joypad_device_id, ConfigManager.config_data.controller.weak_magnitude, 0, 1)
	
func strong_magnitude_test():
	Input.start_joy_vibration(ConfigManager.joypad_device_id, 0, ConfigManager.config_data.controller.strong_magnitude, 1)

func vibration_magnitude_test():
	Input.start_joy_vibration(ConfigManager.joypad_device_id, ConfigManager.config_data.controller.weak_magnitude, ConfigManager.config_data.controller.strong_magnitude, 1)

# Left Y
func left_y_invert_adjust():
	ConfigManager.config_data.controller.left_y_inverted = gui_controller_left_y_invert.is_pressed()
func left_y_sensitivity_adjust(new_val):
	ConfigManager.config_data.controller.left_y_sensitivity = new_val
	gui_controller_left_y_sensitivity_display.text = String(ConfigManager.config_data.controller.left_y_sensitivity)
# Left X
func left_x_invert_adjust():
	ConfigManager.config_data.controller.left_x_inverted = gui_controller_left_x_invert.is_pressed()
func left_x_sensitivity_adjust(new_val):
	ConfigManager.config_data.controller.left_x_sensitivity = new_val
	gui_controller_left_x_sensitivity_display.text = String(ConfigManager.config_data.controller.left_x_sensitivity)
# Right Y
func right_y_invert_adjust():
	ConfigManager.config_data.controller.right_y_inverted = gui_controller_right_y_invert.is_pressed()
func right_y_sensitivity_adjust(new_val):
	ConfigManager.config_data.controller.right_y_sensitivity = new_val
	gui_controller_right_y_sensitivity_display.text = String(ConfigManager.config_data.controller.right_y_sensitivity)
# Right X
func right_x_invert_adjust():
	ConfigManager.config_data.controller.right_x_inverted = gui_controller_right_x_invert.is_pressed()
func right_x_sensitivity_adjust(new_val):
	ConfigManager.config_data.controller.right_x_sensitivity = new_val
	gui_controller_right_x_sensitivity_display.text = String(ConfigManager.config_data.controller.right_x_sensitivity)

# Tabs Switching
func settings_menu_tab_switch(tab_index):
	gui_tabs.set_current_tab(tab_index)

# Reset to default
func reset_to_default(section):
	ConfigManager.reset_to_default(section)
	set_form_values()

# Apply and Cancel
func settings_menu_apply_cancel(button_name):
	match button_name:
		"apply":
			ConfigManager.save_config()
			ConfigManager.apply_config()
		"cancel":
			ConfigManager.load_config()
	self.queue_free()

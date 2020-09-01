extends Node

export (PackedScene) var setting_keybind_action_scene

# Set gui elements
onready var gui_tabs = $VBC/Settings_Tabs
onready var gui_setting_tab = $VBC/Tab_Buttons/Settings_Tab_Button
onready var gui_video_tab = $VBC/Tab_Buttons/Video_Tab_Button
onready var gui_audio_tab = $VBC/Tab_Buttons/Audio_Tab_Button
onready var gui_mouse_tab = $VBC/Tab_Buttons/Mouse_Tab_Button
onready var gui_joy_sticks_tab = $VBC/Tab_Buttons/Joysticks_Tab_Button
onready var gui_key_binding_tab = $VBC/Tab_Buttons/Keybinding_Tab_Button

onready var gui_apply = $VBC/Apply
onready var gui_cancel = $VBC/Cancel

# Return focus
var return_focus_target

# Game
onready var gui_debug = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/Debug_CheckButton
onready var gui_game_reset = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/Reset_Button

# Video
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

# Joy Sticks
onready var gui_joy_stick_move_fb_invert = $VBC/Settings_Tabs/Joysticks_Tab/Settings_Scroll/Settings_VBC/MFB_CheckButton
onready var gui_joy_stick_move_fb_sensitivity_slider = $VBC/Settings_Tabs/Joysticks_Tab/Settings_Scroll/Settings_VBC/MFB_HBC/MFB_Slider
onready var gui_joy_stick_move_fb_sensitivity_display = $VBC/Settings_Tabs/Joysticks_Tab/Settings_Scroll/Settings_VBC/MFB_HBC/MFB_Value

onready var gui_joy_stick_move_lr_invert = $VBC/Settings_Tabs/Joysticks_Tab/Settings_Scroll/Settings_VBC/MLR_CheckButton
onready var gui_joy_stick_move_lr_sensitivity_slider = $VBC/Settings_Tabs/Joysticks_Tab/Settings_Scroll/Settings_VBC/MLR_HBC/MLR_Slider
onready var gui_joy_stick_move_lr_sensitivity_display = $VBC/Settings_Tabs/Joysticks_Tab/Settings_Scroll/Settings_VBC/MLR_HBC/MLR_Value

onready var gui_joy_stick_look_ud_invert = $VBC/Settings_Tabs/Joysticks_Tab/Settings_Scroll/Settings_VBC/LUD_CheckButton
onready var gui_joy_stick_look_ud_sensitivity_slider = $VBC/Settings_Tabs/Joysticks_Tab/Settings_Scroll/Settings_VBC/LUD_HBC/LUD_Slider
onready var gui_joy_stick_look_ud_sensitivity_display = $VBC/Settings_Tabs/Joysticks_Tab/Settings_Scroll/Settings_VBC/LUD_HBC/LUD_Value

onready var gui_joy_stick_look_lr_invert = $VBC/Settings_Tabs/Joysticks_Tab/Settings_Scroll/Settings_VBC/LLR_CheckButton
onready var gui_joy_stick_look_lr_sensitivity_slider = $VBC/Settings_Tabs/Joysticks_Tab/Settings_Scroll/Settings_VBC/LLR_HBC/LLR_Slider
onready var gui_joy_stick_look_lr_sensitivity_display = $VBC/Settings_Tabs/Joysticks_Tab/Settings_Scroll/Settings_VBC/LLR_HBC/LLR_Value

onready var gui_joy_sticks_reset = $VBC/Settings_Tabs/Joysticks_Tab/Settings_Scroll/Settings_VBC/Reset_Button

# Key Binding 
onready var gui_key_binding_vbc = $VBC/Settings_Tabs/Keybinding_Tab/Settings_Scroll/Settings_VBC/Key_Bind_VBC
onready var gui_key_binding_reset = $VBC/Settings_Tabs/Keybinding_Tab/Settings_Scroll/Settings_VBC/Reset_Button

func _ready():
	.connect("tree_exiting", self, "_on_tree_exiting")
	gui_setting_tab.grab_focus()
	# Set Settings Menu
	gui_setting_tab.connect("pressed", self, "settings_menu_tab_switch", [0])
	gui_video_tab.connect("pressed", self, "settings_menu_tab_switch", [1])
	gui_audio_tab.connect("pressed", self, "settings_menu_tab_switch", [2])
	gui_mouse_tab.connect("pressed", self, "settings_menu_tab_switch", [3])
	gui_joy_sticks_tab.connect("pressed", self, "settings_menu_tab_switch", [4])
	gui_key_binding_tab.connect("pressed", self, "settings_menu_tab_switch", [5])
	
	# Apply cancel
	gui_apply.connect("pressed", self, "settings_menu_apply_cancel", ["apply"])
	gui_cancel.connect("pressed", self, "settings_menu_apply_cancel", ["cancel"])
	
	# Game
	gui_debug.connect("pressed", self, "debug_adjust")
	gui_game_reset.connect("pressed", self, "reset_to_default", ["game"])
	
	# Video
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
	
	# Joy Sticks
	gui_joy_stick_move_fb_invert.connect("pressed", self, "move_fb_invert_adjust")
	gui_joy_stick_move_fb_sensitivity_slider.connect("value_changed", self, "move_fb_sensitivity_adjust")
	
	gui_joy_stick_move_lr_invert.connect("pressed", self, "move_lr_invert_adjust")
	gui_joy_stick_move_lr_sensitivity_slider.connect("value_changed", self, "move_lr_sensitivity_adjust")
	
	gui_joy_stick_look_ud_invert.connect("pressed", self, "look_ud_invert_adjust")
	gui_joy_stick_look_ud_sensitivity_slider.connect("value_changed", self, "look_ud_sensitivity_adjust")
	
	gui_joy_stick_look_lr_invert.connect("pressed", self, "look_lr_invert_adjust")
	gui_joy_stick_look_lr_sensitivity_slider.connect("value_changed", self, "look_lr_sensitivity_adjust")
	
	gui_joy_sticks_reset.connect("pressed", self, "reset_to_default", ["joysticks"])
	
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
	gui_debug.set_pressed(ConfigManager.config_data.game.debug)
	
	# Video
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
	
	# Joy Sticks
	gui_joy_stick_move_fb_invert.set_pressed(ConfigManager.config_data.joysticks.joystick_inverted_move_fb)
	gui_joy_stick_move_fb_sensitivity_slider.set_value(ConfigManager.config_data.joysticks.joystick_sensitivity_move_fb)
	
	gui_joy_stick_move_lr_invert.set_pressed(ConfigManager.config_data.joysticks.joystick_inverted_move_lr)
	gui_joy_stick_move_lr_sensitivity_slider.set_value(ConfigManager.config_data.joysticks.joystick_sensitivity_move_lr)
	
	gui_joy_stick_look_ud_invert.set_pressed(ConfigManager.config_data.joysticks.joystick_inverted_look_ud)
	gui_joy_stick_look_ud_sensitivity_slider.set_value(ConfigManager.config_data.joysticks.joystick_sensitivity_look_ud)
	
	gui_joy_stick_look_lr_invert.set_pressed(ConfigManager.config_data.joysticks.joystick_inverted_look_lr)
	gui_joy_stick_look_lr_sensitivity_slider.set_value(ConfigManager.config_data.joysticks.joystick_sensitivity_look_lr)
	
	# Key Binding
	Helpers.RemoveChildren(gui_key_binding_vbc)
	for action in ConfigManager.config_data.keybinding:
		var action_element = setting_keybind_action_scene.instance()
		gui_key_binding_vbc.add_child(action_element)
		action_element.action = action
		action_element.action_data = ConfigManager.config_data.keybinding[action].duplicate(true)
		action_element.element_setup()

	set_elements_disabled()

func set_elements_disabled():
	# Video
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
	
	if gui_fx.is_pressed():
		gui_fx_slider.set_editable(true)
		gui_fx_display.set_self_modulate(Color("#ffffffff"))
	else:
		gui_fx_slider.set_editable(false)
		gui_fx_display.set_self_modulate(Color("#40ffffff"))

# Game
func debug_adjust():
	ConfigManager.config_data.game.debug = gui_debug.is_pressed()

# Video
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

# Joy Sticks
func move_fb_invert_adjust():
	ConfigManager.config_data.joysticks.joystick_inverted_move_fb = gui_joy_stick_move_fb_invert.is_pressed()

func move_fb_sensitivity_adjust(new_val):
	ConfigManager.config_data.joysticks.joystick_sensitivity_move_fb = new_val
	gui_joy_stick_move_fb_sensitivity_display.text = String(ConfigManager.config_data.joysticks.joystick_sensitivity_move_fb)

func move_lr_invert_adjust():
	ConfigManager.config_data.joysticks.joystick_inverted_move_lr = gui_joy_stick_move_lr_invert.is_pressed()

func move_lr_sensitivity_adjust(new_val):
	ConfigManager.config_data.joysticks.joystick_sensitivity_move_lr = new_val
	gui_joy_stick_move_lr_sensitivity_display.text = String(ConfigManager.config_data.joysticks.joystick_sensitivity_move_lr)

func look_ud_invert_adjust():
	ConfigManager.config_data.joysticks.joystick_inverted_look_ud = gui_joy_stick_look_ud_invert.is_pressed()

func look_ud_sensitivity_adjust(new_val):
	ConfigManager.config_data.joysticks.joystick_sensitivity_look_ud = new_val
	gui_joy_stick_look_ud_sensitivity_display.text = String(ConfigManager.config_data.joysticks.joystick_sensitivity_look_ud)

func look_lr_invert_adjust():
	ConfigManager.config_data.joysticks.joystick_inverted_look_lr = gui_joy_stick_look_lr_invert.is_pressed()

func look_lr_sensitivity_adjust(new_val):
	ConfigManager.config_data.joysticks.joystick_sensitivity_look_lr = new_val
	gui_joy_stick_look_lr_sensitivity_display.text = String(ConfigManager.config_data.joysticks.joystick_sensitivity_look_lr)

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

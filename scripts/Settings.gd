extends Node

var return_focus_target

# Get ConfigManager
onready var config_manager = get_node("/root/ConfigManager")

# Set gui elements
onready var gui_tabs = $VBC/Settings_Tabs
onready var gui_av_tab = $VBC/Tab_Buttons/Settings_Tab_Button
onready var gui_controls_tab = $VBC/Tab_Buttons/Controls_Tab_Button

onready var gui_apply = $VBC/Apply
onready var gui_cancel = $VBC/Cancel

# Video
onready var gui_fullscreen = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/FullScreen_CheckButton
onready var gui_vsync = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/VSync_CheckButton
onready var gui_borderless = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/Borderless_CheckButton
onready var gui_resolution_auto = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/ResolutionAuto_CheckButton
onready var gui_resolution_label = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/Resolution_HBC/Resolution_Label
onready var gui_resolution_option = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/Resolution_HBC/Resolution_Option

# Audio
onready var audio_bus_master = AudioServer.get_bus_index("Master")
onready var gui_master = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/Master_HBC/Master_CheckButton
onready var gui_master_slider = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/Master_HBC/Master_Slider
onready var gui_master_display = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/Master_HBC/Master_Value

onready var audio_bus_music = AudioServer.get_bus_index("Music")
onready var gui_music = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/Music_HBC/Music_CheckButton
onready var gui_music_slider = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/Music_HBC/Music_Slider
onready var gui_music_display = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/Music_HBC/Music_Value

onready var audio_bus_fx = AudioServer.get_bus_index("FX")
onready var gui_fx = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/FX_HBC/FX_CheckButton
onready var gui_fx_slider = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/FX_HBC/FX_Slider
onready var gui_fx_display = $VBC/Settings_Tabs/Settings_Tab/Settings_Scroll/Settings_VBC/FX_HBC/FX_Value

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set Settings Menu
	gui_av_tab.connect("pressed", self, "settings_menu_tab_switch", [0])
	gui_controls_tab.connect("pressed", self, "settings_menu_tab_switch", [1])
	gui_apply.connect("pressed", self, "settings_menu_apply_cancel", ["apply"])
	gui_cancel.connect("pressed", self, "settings_menu_apply_cancel", ["cancel"])
	
	# Video
	gui_fullscreen.connect("pressed", self, "fullscreen_adjust")
	gui_vsync.connect("pressed", self, "vsync_adjust")
	gui_borderless.connect("pressed", self, "borderless_adjust")
	gui_resolution_auto.connect("pressed", self, "resolution_auto_adjust")
	
	for resolution in config_manager.resolutions:
		if resolution.value[0] <= OS.get_screen_size()[0]:
			gui_resolution_option.add_item(resolution.name)
	gui_resolution_option.connect("item_selected", self, "resolution_option_adjust")
	
	# Audio
	gui_master.connect("pressed", self, "master_adjust")
	gui_master_slider.connect("value_changed", self, "master_volume_adjust")
	
	gui_music.connect("pressed", self, "music_adjust")
	gui_music_slider.connect("value_changed", self, "music_volume_adjust")
	
	gui_fx.connect("pressed", self, "fx_adjust")
	gui_fx_slider.connect("value_changed", self, "fx_volume_adjust")
	
	# Set Settings Values
	config_manager.load_config()
	
	# Game
	
	# Video
	gui_fullscreen.set_pressed(config_manager.config_data.video.fullscreen)
	gui_vsync.set_pressed(config_manager.config_data.video.vsync)
	gui_borderless.set_pressed(config_manager.config_data.video.borderless)
	gui_resolution_auto.set_pressed(config_manager.config_data.video.resolution_auto)
	gui_resolution_option.select(config_manager.config_data.video.resolution_option)
	
	# Audio
	gui_master.set_pressed(config_manager.config_data.audio.master_enabled)
	gui_master_slider.set_value(config_manager.config_data.audio.master_volume)
	master_volume_adjust(config_manager.config_data.audio.master_volume)
	
	gui_music.set_pressed(config_manager.config_data.audio.music_enabled)
	gui_music_slider.set_value(config_manager.config_data.audio.music_volume)
	music_volume_adjust(config_manager.config_data.audio.music_volume)
	
	gui_fx.set_pressed(config_manager.config_data.audio.fx_enabled)
	gui_fx_slider.set_value(config_manager.config_data.audio.fx_volume)
	fx_volume_adjust(config_manager.config_data.audio.fx_volume)
	
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

# Video
func fullscreen_adjust():
	config_manager.config_data.video.fullscreen = gui_fullscreen.is_pressed()
	set_elements_disabled()

func vsync_adjust():
	config_manager.config_data.video.vsync = gui_vsync.is_pressed()

func borderless_adjust():
	config_manager.config_data.video.borderless = gui_borderless.is_pressed()

func resolution_auto_adjust():
	config_manager.config_data.video.resolution_auto = gui_resolution_auto.is_pressed()
	set_elements_disabled()

func resolution_option_adjust(new_val):
	config_manager.config_data.video.resolution_option = new_val

# Audio
func master_adjust():
	config_manager.config_data.audio.master_enabled = gui_master.is_pressed()
	AudioServer.set_bus_mute(audio_bus_master, !config_manager.config_data.audio.master_enabled)
	set_elements_disabled()

func master_volume_adjust(new_val):
	config_manager.config_data.audio.master_volume = new_val
	AudioServer.set_bus_volume_db(audio_bus_master, config_manager.config_data.audio.master_volume)
	gui_master_display.text = String(config_manager.config_data.audio.master_volume)+"dB"

func music_adjust():
	config_manager.config_data.audio.music_enabled = gui_music.is_pressed()
	AudioServer.set_bus_mute(audio_bus_music, !config_manager.config_data.audio.music_enabled)
	set_elements_disabled()

func music_volume_adjust(new_val):
	config_manager.config_data.audio.music_volume = new_val
	AudioServer.set_bus_volume_db(audio_bus_music, config_manager.config_data.audio.music_volume)
	gui_music_display.text = String(config_manager.config_data.audio.music_volume)+"dB"

func fx_adjust():
	config_manager.config_data.audio.fx_enabled = gui_fx.is_pressed()
	AudioServer.set_bus_mute(audio_bus_fx, !config_manager.config_data.audio.fx_enabled)
	set_elements_disabled()

func fx_volume_adjust(new_val):
	config_manager.config_data.audio.fx_volume = new_val
	AudioServer.set_bus_volume_db(audio_bus_fx, config_manager.config_data.audio.fx_volume)
	gui_fx_display.text = String(config_manager.config_data.audio.fx_volume)+"dB"

# Tabs Switching
func settings_menu_tab_switch(tab_index):
	gui_tabs.set_current_tab(tab_index)

# Apply and Cancel
func settings_menu_apply_cancel(button_name):
	match button_name:
		"apply":
			config_manager.save_config()
			config_manager.apply_config()
		"cancel":
			config_manager.load_config()
	# Unset Settings Menu
	if is_instance_valid(return_focus_target):
		return_focus_target.grab_focus()
	self.queue_free()

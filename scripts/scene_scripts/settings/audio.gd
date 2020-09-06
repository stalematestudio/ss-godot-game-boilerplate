extends Tabs

onready var gui_master = $Settings_Scroll/Settings_VBC/Master_CheckButton
onready var gui_master_slider = $Settings_Scroll/Settings_VBC/Master_HBC/Master_Slider
onready var gui_master_display = $Settings_Scroll/Settings_VBC/Master_HBC/Master_Value

onready var gui_music = $Settings_Scroll/Settings_VBC/Music_CheckButton
onready var gui_music_slider = $Settings_Scroll/Settings_VBC/Music_HBC/Music_Slider
onready var gui_music_display = $Settings_Scroll/Settings_VBC/Music_HBC/Music_Value

onready var gui_voice = $Settings_Scroll/Settings_VBC/Voice_CheckButton
onready var gui_voice_slider = $Settings_Scroll/Settings_VBC/Voice_HBC/Voice_Slider
onready var gui_voice_display = $Settings_Scroll/Settings_VBC/Voice_HBC/Voice_Value

onready var gui_fx = $Settings_Scroll/Settings_VBC/FX_CheckButton
onready var gui_fx_slider = $Settings_Scroll/Settings_VBC/FX_HBC/FX_Slider
onready var gui_fx_display = $Settings_Scroll/Settings_VBC/FX_HBC/FX_Value

func _ready():
	gui_master.connect("pressed", self, "master_adjust")
	gui_master_slider.connect("value_changed", self, "master_volume_adjust")
	
	gui_music.connect("pressed", self, "music_adjust")
	gui_music_slider.connect("value_changed", self, "music_volume_adjust")

	gui_voice.connect("pressed", self, "voice_adjust")
	gui_voice_slider.connect("value_changed", self, "voice_volume_adjust")

	gui_fx.connect("pressed", self, "fx_adjust")
	gui_fx_slider.connect("value_changed", self, "fx_volume_adjust")

func set_form_values():
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

	set_elements_disabled()

func set_elements_disabled():
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

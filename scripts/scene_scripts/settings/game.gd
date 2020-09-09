extends Tabs

onready var gui_subtitles = $Settings_Scroll/Settings_VBC/SubTitles_CheckButton
onready var gui_mouse_mode_confined = $Settings_Scroll/Settings_VBC/MouseConfined_CheckButton
onready var gui_flp = $Settings_Scroll/Settings_VBC/FocusLossPause_CheckButton
onready var gui_fgr = $Settings_Scroll/Settings_VBC/FocusGrabResume_CheckButton
onready var gui_debug = $Settings_Scroll/Settings_VBC/Debug_CheckButton

onready var gui_low_cpu_check = $Settings_Scroll/Settings_VBC/LowCPU_CheckButton
onready var gui_low_cpu_label = $Settings_Scroll/Settings_VBC/LowCPU_HBC/Label
onready var gui_low_cpu_spin = $Settings_Scroll/Settings_VBC/LowCPU_HBC/SpinBox

func _ready():
	gui_subtitles.connect("pressed", self, "subtitle_adjust")
	gui_mouse_mode_confined.connect("pressed", self, "mouse_mode_confined_adjust")
	gui_flp.connect("pressed", self, "flp_adjust")
	gui_fgr.connect("pressed", self, "fgr_adjust")
	gui_debug.connect("pressed", self, "debug_adjust")

	gui_low_cpu_check.connect("pressed", self, "low_cpu_adjust")
	gui_low_cpu_spin.connect("value_changed", self, "low_cpu_sleep_adjust")

func set_form_values():
	gui_subtitles.set_pressed(ConfigManager.config_data.game.subtitles)
	gui_mouse_mode_confined.set_pressed(ConfigManager.config_data.game.mouse_mode_confined)
	gui_flp.set_pressed(ConfigManager.config_data.game.pause_on_focus_loss)
	gui_fgr.set_pressed(ConfigManager.config_data.game.resume_on_focus_grab)
	gui_debug.set_pressed(ConfigManager.config_data.game.debug)

	gui_low_cpu_check.set_pressed(ConfigManager.config_data.game.low_processor_usage_mode)
	gui_low_cpu_spin.set_value(ConfigManager.config_data.game.low_processor_usage_mode_sleep_usec)

	set_elements_disabled()

func set_elements_disabled():
	if gui_low_cpu_check.is_pressed():
		gui_low_cpu_label.set_self_modulate(Color("#ffffffff"))
		gui_low_cpu_spin.set_editable(true)
	else:
		gui_low_cpu_label.set_self_modulate(Color("#40ffffff"))
		gui_low_cpu_spin.set_editable(false)

func subtitle_adjust():
	ConfigManager.config_data.game.subtitles = gui_subtitles.is_pressed()

func mouse_mode_confined_adjust():
	ConfigManager.config_data.game.mouse_mode_confined = gui_mouse_mode_confined.is_pressed()

func flp_adjust():
	ConfigManager.config_data.game.pause_on_focus_loss = gui_flp.is_pressed()

func fgr_adjust():
	ConfigManager.config_data.game.resume_on_focus_grab = gui_fgr.is_pressed()			

func debug_adjust():
	ConfigManager.config_data.game.debug = gui_debug.is_pressed()

func low_cpu_adjust():
	ConfigManager.config_data.game.low_processor_usage_mode = gui_low_cpu_check.is_pressed()
	set_elements_disabled()

func low_cpu_sleep_adjust(new_val):
	ConfigManager.config_data.game.low_processor_usage_mode_sleep_usec = new_val

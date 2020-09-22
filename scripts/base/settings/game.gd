extends Tabs

onready var gui_subtitles = $Settings_Scroll/Settings_VBC/SubTitles_CheckButton
onready var gui_mouse_mode_confined = $Settings_Scroll/Settings_VBC/MouseConfined_CheckButton
onready var gui_flp = $Settings_Scroll/Settings_VBC/FocusLossPause_CheckButton
onready var gui_fgr = $Settings_Scroll/Settings_VBC/FocusGrabResume_CheckButton
onready var gui_debug = $Settings_Scroll/Settings_VBC/Debug_CheckButton

onready var gui_low_cpu_check = $Settings_Scroll/Settings_VBC/LowCPU_CheckButton
onready var gui_low_cpu_label = $Settings_Scroll/Settings_VBC/LowCPU_HBC/Label
onready var gui_low_cpu_spin_plus = $Settings_Scroll/Settings_VBC/LowCPU_HBC/Plus_Button
onready var gui_low_cpu_spin_minus = $Settings_Scroll/Settings_VBC/LowCPU_HBC/Minus_Button
onready var gui_low_cpu_spin = $Settings_Scroll/Settings_VBC/LowCPU_HBC/SpinBox

onready var gui_ips_spin_plus = $Settings_Scroll/Settings_VBC/IPS_HBC/Plus_Button
onready var gui_ips_spin_minus = $Settings_Scroll/Settings_VBC/IPS_HBC/Minus_Button
onready var gui_ips_spin = $Settings_Scroll/Settings_VBC/IPS_HBC/SpinBox

onready var gui_pjf_spin_plus = $Settings_Scroll/Settings_VBC/PJF_HBC/Plus_Button
onready var gui_pjf_spin_minus = $Settings_Scroll/Settings_VBC/PJF_HBC/Minus_Button
onready var gui_pjf_spin = $Settings_Scroll/Settings_VBC/PJF_HBC/SpinBox

onready var gui_tfps_spin_plus = $Settings_Scroll/Settings_VBC/TFPS_HBC/Plus_Button
onready var gui_tfps_spin_minus = $Settings_Scroll/Settings_VBC/TFPS_HBC/Minus_Button
onready var gui_tfps_spin = $Settings_Scroll/Settings_VBC/TFPS_HBC/SpinBox

onready var gui_ts_spin_plus = $Settings_Scroll/Settings_VBC/TS_HBC/Plus_Button
onready var gui_ts_spin_minus = $Settings_Scroll/Settings_VBC/TS_HBC/Minus_Button
onready var gui_ts_spin = $Settings_Scroll/Settings_VBC/TS_HBC/SpinBox

func _ready():
	gui_subtitles.connect("pressed", self, "subtitle_adjust")
	gui_mouse_mode_confined.connect("pressed", self, "mouse_mode_confined_adjust")
	gui_flp.connect("pressed", self, "flp_adjust")
	gui_fgr.connect("pressed", self, "fgr_adjust")
	gui_debug.connect("pressed", self, "debug_adjust")
	
	gui_low_cpu_check.connect("pressed", self, "low_cpu_adjust")
	gui_low_cpu_spin_plus.connect("pressed", self, "low_cpu_sleep_plus_adjust")
	gui_low_cpu_spin_minus.connect("pressed", self, "low_cpu_sleep_minus_adjust")
	gui_low_cpu_spin.connect("value_changed", self, "low_cpu_sleep_adjust")
	
	gui_ips_spin_plus.connect("pressed", self, "ips_plus_adjust")
	gui_ips_spin_minus.connect("pressed", self, "ips_minus_adjust")
	gui_ips_spin.connect("value_changed", self, "ips_adjust")
	
	gui_pjf_spin_plus.connect("pressed", self, "pjf_plus_adjust")
	gui_pjf_spin_minus.connect("pressed", self, "pjf_minus_adjust")
	gui_pjf_spin.connect("value_changed", self, "pjf_adjust")
	
	gui_tfps_spin_plus.connect("pressed", self, "tfps_plus_adjust")
	gui_tfps_spin_minus.connect("pressed", self, "tfps_minus_adjust")
	gui_tfps_spin.connect("value_changed", self, "tfps_adjust")
	
	gui_ts_spin_plus.connect("pressed", self, "ts_plus_adjust")
	gui_ts_spin_minus.connect("pressed", self, "ts_minus_adjust")
	gui_ts_spin.connect("value_changed", self, "ts_adjust")

func set_form_values():
	gui_subtitles.set_pressed(ConfigManager.config_data.game.subtitles)
	gui_mouse_mode_confined.set_pressed(ConfigManager.config_data.game.mouse_mode_confined)
	gui_flp.set_pressed(ConfigManager.config_data.game.pause_on_focus_loss)
	gui_fgr.set_pressed(ConfigManager.config_data.game.resume_on_focus_grab)
	gui_debug.set_pressed(ConfigManager.config_data.game.debug)

	gui_low_cpu_check.set_pressed(ConfigManager.config_data.game.low_processor_usage_mode)
	gui_low_cpu_spin.set_value(ConfigManager.config_data.game.low_processor_usage_mode_sleep_usec)

	gui_ips_spin.set_value(ConfigManager.config_data.game.iterations_per_second)
	gui_pjf_spin.set_value(ConfigManager.config_data.game.physics_jitter_fix)
	gui_tfps_spin.set_value(ConfigManager.config_data.game.target_fps)
	gui_ts_spin.set_value(ConfigManager.config_data.game.time_scale)

	set_elements_disabled()

func set_elements_disabled():
	if gui_low_cpu_check.is_pressed():
		gui_low_cpu_label.set_self_modulate(Color("#ffffffff"))
		gui_low_cpu_spin_plus.set_disabled(false)
		gui_low_cpu_spin_minus.set_disabled(false)
		gui_low_cpu_spin.set_editable(true)
	else:
		gui_low_cpu_label.set_self_modulate(Color("#40ffffff"))
		gui_low_cpu_spin_plus.set_disabled(true)
		gui_low_cpu_spin_minus.set_disabled(true)
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

func low_cpu_sleep_plus_adjust():
	gui_low_cpu_spin.set_value(gui_low_cpu_spin.get_value() + gui_low_cpu_spin.step)

func low_cpu_sleep_minus_adjust():
	gui_low_cpu_spin.set_value(gui_low_cpu_spin.get_value() - gui_low_cpu_spin.step)

func low_cpu_sleep_adjust(new_val):
	ConfigManager.config_data.game.low_processor_usage_mode_sleep_usec = new_val

func ips_plus_adjust():
	gui_ips_spin.set_value(gui_ips_spin.get_value() + gui_ips_spin.step)

func ips_minus_adjust():
	gui_ips_spin.set_value(gui_ips_spin.get_value() - gui_ips_spin.step)

func ips_adjust(new_val):
	ConfigManager.config_data.game.iterations_per_second = new_val

func pjf_plus_adjust():
	gui_pjf_spin.set_value(gui_pjf_spin.get_value() + gui_pjf_spin.step)

func pjf_minus_adjust():
	gui_pjf_spin.set_value(gui_pjf_spin.get_value() - gui_pjf_spin.step)

func pjf_adjust(new_val):
	ConfigManager.config_data.game.physics_jitter_fix = new_val

func tfps_plus_adjust():
	gui_tfps_spin.set_value(gui_tfps_spin.get_value() + gui_tfps_spin.step)

func tfps_minus_adjust():
	gui_tfps_spin.set_value(gui_tfps_spin.get_value() - gui_tfps_spin.step)

func tfps_adjust(new_val):
	ConfigManager.config_data.game.target_fps = new_val

func ts_plus_adjust():
	gui_ts_spin.set_value(gui_ts_spin.get_value() + gui_ts_spin.step)

func ts_minus_adjust():
	gui_ts_spin.set_value(gui_ts_spin.get_value() - gui_ts_spin.step)

func ts_adjust(new_val):
	ConfigManager.config_data.game.time_scale = new_val

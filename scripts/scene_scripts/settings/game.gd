extends Tabs

onready var gui_subtitles = $Settings_Scroll/Settings_VBC/SubTitles_CheckButton
onready var gui_flp = $Settings_Scroll/Settings_VBC/FocusLossPause_CheckButton
onready var gui_fgr = $Settings_Scroll/Settings_VBC/FocusGrabResume_CheckButton
onready var gui_debug = $Settings_Scroll/Settings_VBC/Debug_CheckButton

func _ready():
	gui_subtitles.connect("pressed", self, "subtitle_adjust")
	gui_flp.connect("pressed", self, "flp_adjust")
	gui_fgr.connect("pressed", self, "fgr_adjust")
	gui_debug.connect("pressed", self, "debug_adjust")

func set_form_values():
	gui_subtitles.set_pressed(ConfigManager.config_data.game.subtitles)
	gui_flp.set_pressed(ConfigManager.config_data.game.pause_on_focus_loss)
	gui_fgr.set_pressed(ConfigManager.config_data.game.resume_on_focus_grab)
	gui_debug.set_pressed(ConfigManager.config_data.game.debug)

func subtitle_adjust():
	ConfigManager.config_data.game.subtitles = gui_subtitles.is_pressed()

func flp_adjust():
	ConfigManager.config_data.game.pause_on_focus_loss = gui_flp.is_pressed()

func fgr_adjust():
	ConfigManager.config_data.game.resume_on_focus_grab = gui_fgr.is_pressed()			

func debug_adjust():
	ConfigManager.config_data.game.debug = gui_debug.is_pressed()

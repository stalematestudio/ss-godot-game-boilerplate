extends Node

onready var sections = {
		0: $VBC/Settings_Tabs/game,
		1: $VBC/Settings_Tabs/video,
		2: $VBC/Settings_Tabs/audio,
		3: $VBC/Settings_Tabs/mouse,
		4: $VBC/Settings_Tabs/controller,
		5: $VBC/Settings_Tabs/keybind
		}

# Settings Tabs Switching
onready var gui_tabs = $VBC/Settings_Tabs
onready var gui_game_tab_switch = $VBC/Tab_Buttons/Game_Tab_Button
onready var gui_video_tab_switch = $VBC/Tab_Buttons/Video_Tab_Button
onready var gui_audio_tab_switch = $VBC/Tab_Buttons/Audio_Tab_Button
onready var gui_mouse_tab_switch = $VBC/Tab_Buttons/Mouse_Tab_Button
onready var gui_controller_tab_switch = $VBC/Tab_Buttons/Controller_Tab_Button
onready var gui_keybind_tab_switch = $VBC/Tab_Buttons/Keybind_Tab_Button

# Reset Apply Cancel
onready var gui_reset = $VBC/Reset
onready var gui_apply = $VBC/Apply
onready var gui_cancel = $VBC/Cancel

# Return focus
var return_focus_target

func _ready():
	connect("tree_exiting", self, "_on_tree_exiting")
	gui_game_tab_switch.grab_focus()
	
	# Settings Tabs Switching
	gui_game_tab_switch.connect("pressed", self, "settings_menu_tab_switch", [0])
	gui_video_tab_switch.connect("pressed", self, "settings_menu_tab_switch", [1])
	gui_audio_tab_switch.connect("pressed", self, "settings_menu_tab_switch", [2])
	gui_mouse_tab_switch.connect("pressed", self, "settings_menu_tab_switch", [3])
	gui_controller_tab_switch.connect("pressed", self, "settings_menu_tab_switch", [4])
	gui_keybind_tab_switch.connect("pressed", self, "settings_menu_tab_switch", [5])
	
	# Reset Apply Cancel
	gui_reset.connect("pressed", self, "settings_menu_apply_cancel", ["reset"])
	gui_apply.connect("pressed", self, "settings_menu_apply_cancel", ["apply"])
	gui_cancel.connect("pressed", self, "settings_menu_apply_cancel", ["cancel"])

	set_form_values()

func _on_tree_exiting():
	if is_instance_valid(return_focus_target):
		return_focus_target.grab_focus()

func _input(event):
	if event.is_action_released("ui_cancel"):
		get_tree().set_input_as_handled()
		settings_menu_apply_cancel("cancel")

func set_form_values():
	ConfigManager.load_config()
	for section in sections.values():
		section.set_form_values()

# Tabs Switching
func settings_menu_tab_switch(tab_index):
	gui_tabs.set_current_tab(tab_index)

# Apply and Cancel
func settings_menu_apply_cancel(button_name):
	match button_name:
		"reset":
			ConfigManager.reset_to_default(sections[gui_tabs.get_current_tab()].name)
			set_form_values()
		"apply":
			ConfigManager.save_config()
			self.queue_free()
		"cancel":
			ConfigManager.load_config()
			self.queue_free()

extends Control

# Get Globals
onready var root = get_node("/root")
onready var audio_manager = get_node("/root/AudioManager")

# Set element references
onready var game_title = $Start_Menu/VBC/Game_Title
onready var continue_button = $Start_Menu/VBC/Continue
onready var new_game_button = $Start_Menu/VBC/New_Game
onready var settings_button = $Start_Menu/VBC/Settings
onready var credits_button = $Start_Menu/VBC/Credits
onready var quit_button = $Start_Menu/VBC/Quit
onready var web_link = $Start_Menu/VBC/Developer_LinkButton

# State
onready var joypad_control = true
onready var profiles_exist = false # This will be changed when the save load functionality is ready

export (String) var web_link_url

func _ready():
	root.connect("gui_focus_changed", audio_manager, "ui_navigate_audio_effect")
	.connect("tree_exiting", self, "_on_tree_exiting")

	game_title.text = ProjectSettings.get_setting("application/config/name")
	if profiles_exist:
		continue_button.grab_focus()
		continue_button.connect("pressed", self, "start_menu_button_pressed", ["continue"])
	else:
		continue_button.set_disabled(true)
		new_game_button.grab_focus()
	new_game_button.connect("pressed", self, "start_menu_button_pressed", ["new"])
	settings_button.connect("pressed", self, "start_menu_button_pressed", ["settings"])
	credits_button.connect("pressed", self, "start_menu_button_pressed", ["credits"])
	quit_button.connect("pressed", self, "start_menu_button_pressed", ["quit"])
	web_link.connect("pressed", self, "start_menu_button_pressed", ["website"])

func _on_tree_exiting():
	root.disconnect("gui_focus_changed", audio_manager, "ui_navigate_audio_effect")

func _input(event):
	if ( event is InputEventJoypadButton ) or ( event is InputEventJoypadMotion ):
		if not joypad_control:
			joypad_control = true
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	elif ( event is InputEventMouseButton ) or ( event is InputEventMouseMotion ) :
		if joypad_control:
			joypad_control = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
		audio_manager.ui_accept_audio_effect()
	elif event.is_action_pressed("ui_cancel"):
		audio_manager.ui_cancel_audio_effect()

# Called every time a button in the start menu is pressed
func start_menu_button_pressed(button_name):
	match button_name:
		"continue":
			pass
		"new":
			get_parent().change_current_scene("game_scene")
		"settings":
			get_parent().set_settings_display(settings_button)
		"credits":
			get_parent().change_current_scene("credits_scene")
		"quit":
			get_tree().quit()
		"website":
			OS.shell_open(web_link_url)

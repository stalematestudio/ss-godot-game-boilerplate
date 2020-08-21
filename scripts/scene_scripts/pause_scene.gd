extends Control

# Get Globals
onready var root = get_node("/root")
onready var audio_manager = get_node("/root/AudioManager")
onready var game_manager = get_node("/root/GameManager")

# Set element references
onready var game_title = $Pause_Menu/VBC/Game_Title
onready var settings_button = $Pause_Menu/VBC/Settings
onready var quit_to_title_button = $Pause_Menu/VBC/Quit_To_Title
onready var quit_game_button = $Pause_Menu/VBC/Quit_Game
onready var web_link = $Pause_Menu/VBC/Developer_LinkButton

# State
onready var joypad_control = true

export (String) var web_link_url

func _ready():
	root.connect("gui_focus_changed", audio_manager, "ui_navigate_audio_effect")
	.connect("tree_exiting", self, "_on_tree_exiting")
	
	game_title.text = ProjectSettings.get_setting("application/config/name")
	settings_button.connect("pressed", self, "pause_menu_button_pressed", ["settings"])
	quit_to_title_button.connect("pressed", self, "pause_menu_button_pressed", ["quit_to_title"])
	quit_game_button.connect("pressed", self, "pause_menu_button_pressed", ["quit_game"])
	web_link.connect("pressed", self, "pause_menu_button_pressed", ["website"])

func _on_tree_exiting():
	root.disconnect("gui_focus_changed", audio_manager, "ui_navigate_audio_effect")

func _input(event):
	# Pause game
	if Input.is_action_just_released("ui_cancel"):
		game_manager.pause_game()
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
func pause_menu_button_pressed(button_name):
	match button_name:
		"settings":
			get_parent().set_settings_display(settings_button)
		"quit_to_title":
			game_manager.change_state("TITLE")
		"quit_game":
			get_tree().quit()
		"website":
			OS.shell_open(web_link_url)

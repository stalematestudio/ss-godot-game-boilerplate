extends Control

# Get Globals
onready var globals = get_node("/root/Globals")
onready var config_manager = get_node("/root/ConfigManager")
onready var audio_manager = get_node("/root/AudioManager")


# Set element references
onready var game_title = $Start_Menu/VBC/Game_Title
onready var continue_button = $Start_Menu/VBC/Continue
onready var new_game_button = $Start_Menu/VBC/New_Game
onready var settings_button = $Start_Menu/VBC/Settings
onready var quit_button = $Start_Menu/VBC/Quit

var profiles_exist = false

var settings_menu_instance
export (PackedScene) var settings_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set Mouse Mode
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Set Start Menu
	game_title.text = ProjectSettings.get_setting("application/config/name")
	if profiles_exist:
		continue_button.grab_focus()
		continue_button.connect("pressed", self, "start_menu_button_pressed", ["continue"])
		continue_button.connect("focus_entered", audio_manager, "ui_focus_entered_audio_effect")
	else:
		continue_button.set_disabled(true)
		new_game_button.grab_focus()
	
	new_game_button.connect("pressed", self, "start_menu_button_pressed", ["new"])
	new_game_button.connect("focus_entered", audio_manager, "ui_focus_entered_audio_effect")
	settings_button.connect("pressed", self, "start_menu_button_pressed", ["settings"])
	settings_button.connect("focus_entered", audio_manager, "ui_focus_entered_audio_effect")
	quit_button.connect("pressed", self, "start_menu_button_pressed", ["quit"])
	quit_button.connect("focus_entered", audio_manager, "ui_focus_entered_audio_effect")

func _input(event):
	if ( event is InputEventJoypadButton ) or ( event is InputEventJoypadMotion ):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
#
# Called every time a button in the start menu is pressed
func start_menu_button_pressed(button_name):
	audio_manager.ui_pressed_audio_effect()
	match button_name:
		"new":
			get_tree().change_scene("scenes/demo/Demo.tscn")
		"continue":
			# Open profile select menu
			pass
		"settings":
			if is_instance_valid(settings_menu_instance):
				settings_menu_instance.queue_free()
			else:
				settings_menu_instance = settings_menu.instance()
				settings_menu_instance.return_focus_target = settings_button
				add_child(settings_menu_instance)
		"quit":
			get_tree().quit()

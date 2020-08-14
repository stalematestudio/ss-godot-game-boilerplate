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
onready var credits_button = $Start_Menu/VBC/Credits
onready var quit_button = $Start_Menu/VBC/Quit
onready var web_link = $Start_Menu/VBC/Developer_LinkButton

var profiles_exist = false

export (String) var web_link_url

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
	else:
		continue_button.set_disabled(true)
		new_game_button.grab_focus()
	
	new_game_button.connect("pressed", self, "start_menu_button_pressed", ["new"])
	settings_button.connect("pressed", self, "start_menu_button_pressed", ["settings"])
	credits_button.connect("pressed", self, "start_menu_button_pressed", ["credits"])
	quit_button.connect("pressed", self, "start_menu_button_pressed", ["quit"])
	web_link.connect("pressed", self, "start_menu_button_pressed", ["website"])

func _input(event):
	if ( event is InputEventJoypadButton ) or ( event is InputEventJoypadMotion ):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
#
# Called every time a button in the start menu is pressed
func start_menu_button_pressed(button_name):
	audio_manager.ui_pressed_audio_effect()
	match button_name:
		"new":
			get_parent().change_current_scene("demo_scene")
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
		"credits":
			pass
		"quit":
			get_tree().quit()
		"website":
			OS.shell_open(web_link_url)

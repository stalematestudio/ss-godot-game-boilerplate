extends Control

onready var game_title = $Start_Menu/VBC/Game_Title
onready var profile_button = $Start_Menu/VBC/HBoxContainer/Profile
onready var continue_button = $Start_Menu/VBC/Continue
onready var new_game_button = $Start_Menu/VBC/New_Game
onready var settings_button = $Start_Menu/VBC/Settings
onready var credits_button = $Start_Menu/VBC/Credits
onready var quit_button = $Start_Menu/VBC/Quit
onready var web_link = $Start_Menu/VBC/Developer_LinkButton

onready var player_profile = ProfileManager.get_current_profile()
onready var profiles_exist = false # This will be changed when the save load functionality is ready

export (String) var web_link_url

func _ready():
	game_title.set_text(ProjectSettings.get_setting("application/config/name"))
	if player_profile:
		profile_button.set_text(ProfileManager.get_current_profile().capitalize())
	else:
		profile_button.set_text("Player")
	profile_button.connect("pressed", self, "start_menu_button_pressed", ["profile"])
	if profiles_exist:
		continue_button.connect("pressed", self, "start_menu_button_pressed", ["continue"])
		continue_button.grab_focus()
	else:
		continue_button.set_disabled(true)
		new_game_button.grab_focus()
	new_game_button.connect("pressed", self, "start_menu_button_pressed", ["new"])
	settings_button.connect("pressed", self, "start_menu_button_pressed", ["settings"])
	credits_button.connect("pressed", self, "start_menu_button_pressed", ["credits"])
	quit_button.connect("pressed", self, "start_menu_button_pressed", ["quit"])
	web_link.connect("pressed", self, "start_menu_button_pressed", ["website"])

func start_menu_button_pressed(button_name):
	match button_name:
		"profile":
			pass
		"continue":
			pass
		"new":
			GameManager.game_state_change("IN_GAME")
		"settings":
			get_parent().set_settings_display(settings_button)
		"credits":
			GameManager.game_state_change("CREDITS")
		"quit":
			get_tree().quit()
		"website":
			OS.shell_open(web_link_url)

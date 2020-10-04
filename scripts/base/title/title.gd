extends Control

onready var game_title = $Start_Menu/VBC/Game_Title
onready var profile_button = $Start_Menu/VBC/HBoxContainer/Profile
onready var continue_button = $Start_Menu/VBC/Continue
onready var new_button = $Start_Menu/VBC/New_Game
onready var settings_button = $Start_Menu/VBC/Settings
onready var credits_button = $Start_Menu/VBC/Credits
onready var quit_button = $Start_Menu/VBC/Quit
onready var web_link = $Start_Menu/VBC/Developer_LinkButton

onready var profile_manage_popup = $profile
onready var new_popup = $new
onready var continue_popup = $continue

export (String) var web_link_url

func _ready():
	game_title.set_text(ProjectSettings.get_setting("application/config/name"))
	
	profile_button.set_text(ProfileManager.get_current_profile_name().capitalize())
	profile_button.connect("pressed", self, "start_menu_button_pressed", ["profile"])

	if ProfileManager.current_profile_has_saved_games():
		continue_button.connect("pressed", self, "start_menu_button_pressed", ["continue"])
		continue_button.grab_focus()
	else:
		continue_button.set_disabled(true)
		new_button.grab_focus()
	
	new_button.connect("pressed", self, "start_menu_button_pressed", ["new"])
	settings_button.connect("pressed", self, "start_menu_button_pressed", ["settings"])
	credits_button.connect("pressed", self, "start_menu_button_pressed", ["credits"])
	quit_button.connect("pressed", self, "start_menu_button_pressed", ["quit"])
	web_link.connect("pressed", self, "start_menu_button_pressed", ["website"])

	profile_manage_popup.connect("popup_hide", self, "_on_popup_hide")
	new_popup.connect("popup_hide", self, "_on_popup_hide")
	continue_popup.connect("popup_hide", self, "_on_popup_hide")

	ProfileManager.connect("profile_changed", self, "_on_profile_changed")

func _on_profile_changed():
	profile_button.set_text(ProfileManager.get_current_profile_name().capitalize())

func _on_popup_hide():
	if ProfileManager.current_profile_has_saved_games():
		continue_button.grab_focus()
	else:
		new_button.grab_focus()

func start_menu_button_pressed(button_name):
	match button_name:
		"profile":
			profile_manage_popup.popup_centered_ratio(0.3)
			#profile_manage_popup.set_as_minsize()
			#profile_manage_popup.popup_centered()
		"continue":
			continue_popup.popup_centered_ratio(0.3)
			#continue_popup.set_as_minsize()
			#continue_popup.popup_centered()
		"new":
			new_popup.popup_centered_ratio(0.3)
			#new_popup.set_as_minsize()
			#new_popup.popup_centered()
		"settings":
			get_parent().set_settings_display(settings_button)
		"credits":
			GameManager.game_state_change("CREDITS")
		"quit":
			get_tree().quit()
		"website":
			OS.shell_open(web_link_url)

extends Control

@onready var game_title = $Start_Menu/VBC/Game_Title
@onready var profile_button = $Start_Menu/VBC/HBoxContainer/Profile
@onready var continue_button = $Start_Menu/VBC/Continue
@onready var new_button = $Start_Menu/VBC/New_Game
@onready var settings_button = $Start_Menu/VBC/Settings
@onready var credits_button = $Start_Menu/VBC/Credits
@onready var quit_button = $Start_Menu/VBC/Quit
@onready var web_link = $Start_Menu/VBC/Developer_LinkButton

@onready var profile_manage_popup = $profile
@onready var new_popup = $new
@onready var continue_popup = $continue

@export var web_link_url: String

func _ready():
	game_title.set_text(ProjectSettings.get_setting("application/config/name"))
	
	profile_button.set_text(ProfileManager.get_profile_name_current().capitalize())
	profile_button.connect("pressed", Callable(self, "start_menu_button_pressed").bind("profile"))

	if ProfileManager.profile_has_saved_games_current():
		continue_button.connect("pressed", Callable(self, "start_menu_button_pressed").bind("continue"))
		continue_button.grab_focus()
	else:
		continue_button.set_disabled(true)
		new_button.grab_focus()
	
	new_button.connect("pressed", Callable(self, "start_menu_button_pressed").bind("new"))
	settings_button.connect("pressed", Callable(self, "start_menu_button_pressed").bind("settings"))
	credits_button.connect("pressed", Callable(self, "start_menu_button_pressed").bind("credits"))
	quit_button.connect("pressed", Callable(self, "start_menu_button_pressed").bind("quit"))
	web_link.connect("pressed", Callable(self, "start_menu_button_pressed").bind("website"))

	profile_manage_popup.connect("close_requested", Callable(self, "_close_requested"))
	new_popup.connect("close_requested", Callable(self, "_close_requested"))
	continue_popup.connect("close_requested", Callable(self, "_close_requested"))

	profile_manage_popup.set_wrap_controls(true)
	new_popup.set_wrap_controls(true)
	continue_popup.set_wrap_controls(true)

	ProfileManager.connect("profile_changed", Callable(self, "_on_profile_changed"))

func _on_profile_changed():
	profile_button.set_text(ProfileManager.get_profile_name_current().capitalize())

func _close_requested():
	profile_manage_popup.hide()
	continue_popup.hide()
	new_popup.hide()
	if ProfileManager.profile_has_saved_games_current():
		continue_button.grab_focus()
	else:
		continue_button.set_disabled(true)
		new_button.grab_focus()

func start_menu_button_pressed(button_name):
	match button_name:
		"profile":
			# profile_manage_popup.popup_centered_ratio(0.3)
			# profile_manage_popup.set_as_minsize()
			profile_manage_popup.popup_centered()
		"continue":
			# continue_popup.popup_centered_ratio(0.6)
			# continue_popup.set_as_minsize()
			continue_popup.popup_centered()
		"new":
			# new_popup.popup_centered_ratio(0.25)
			# new_popup.set_as_minsize()
			new_popup.popup_centered()
		"settings":
			get_parent().set_settings_display(settings_button)
		"credits":
			GameManager.game_state_change("CREDITS")
		"quit":
			get_tree().quit()
		"website":
			OS.shell_open(web_link_url)

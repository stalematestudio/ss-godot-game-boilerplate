class_name TitleControl extends Control

@export var profile_list_scene: PackedScene = preload("res://utils/profile_list/profile_list.tscn")
@onready var profile_list_window: ProfileListWindow

@onready var game_title = $Start_Menu/VBC/Game_Title
@onready var profile_button = $Start_Menu/VBC/HBoxContainer/Profile
@onready var continue_button = $Start_Menu/VBC/Continue
@onready var new_button = $Start_Menu/VBC/New_Game
@onready var settings_button = $Start_Menu/VBC/Settings
@onready var credits_button = $Start_Menu/VBC/Credits
@onready var quit_button = $Start_Menu/VBC/Quit
@onready var web_link = $Start_Menu/VBC/Developer_LinkButton

@onready var new_popup = $new
@onready var continue_popup = $continue

@export var web_link_url: String

func _ready() -> void:
	game_title.set_text(ProjectSettings.get_setting("application/config/name"))
	
	profile_button.set_text(ProfileManager.get_profile_name_current().capitalize())
	profile_button.pressed.connect(start_menu_button_pressed.bind("profile"))

	if ProfileManager.profile_has_saved_games_current():
		continue_button.pressed.connect(start_menu_button_pressed.bind("continue"))
		continue_button.grab_focus()
	else:
		continue_button.set_disabled(true)
		new_button.grab_focus()
	
	new_button.pressed.connect(start_menu_button_pressed.bind("new"))
	settings_button.pressed.connect(start_menu_button_pressed.bind("settings"))
	credits_button.pressed.connect(start_menu_button_pressed.bind("credits"))
	quit_button.pressed.connect(start_menu_button_pressed.bind("quit"))
	web_link.pressed.connect(start_menu_button_pressed.bind("website"))

	new_popup.connect("close_requested", Callable(self, "_close_requested"))
	continue_popup.connect("close_requested", Callable(self, "_close_requested"))

	new_popup.set_wrap_controls(true)
	continue_popup.set_wrap_controls(true)

	ProfileManager.connect("profile_changed", Callable(self, "_on_profile_changed"))

func _on_profile_changed():
	profile_button.set_text(ProfileManager.get_profile_name_current().capitalize())

func _close_requested():
	if is_instance_valid(profile_list_window):
		profile_list_window.queue_free()
	continue_popup.hide()
	new_popup.hide()
	if ProfileManager.profile_has_saved_games_current():
		continue_button.grab_focus()
	else:
		continue_button.set_disabled(true)
		new_button.grab_focus()

func start_menu_button_pressed(button_name) -> void:
	match button_name:
		"profile":
			profile_list_window = profile_list_scene.instantiate()
			profile_list_window.close_requested.connect(_close_requested)
			add_child(profile_list_window)
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

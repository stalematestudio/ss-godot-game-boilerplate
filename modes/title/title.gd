class_name TitleControl extends Control

@export var profile_list_scene: PackedScene = preload("res://utils/profile_list/profile_list.tscn")
@onready var profile_list_window: ProfileListWindow

@export var load_game_scene: PackedScene = preload("res://utils/load_game/load_game.tscn")
@onready var load_game_window: LoadGameWindow

@onready var game_title = $Start_Menu/VBC/Game_Title
@onready var profile_button = $Start_Menu/VBC/HBoxContainer/Profile
@onready var new_game_button = $Start_Menu/VBC/New_Game
@onready var load_game_button = $Start_Menu/VBC/Load_Game
@onready var settings_button = $Start_Menu/VBC/Settings
@onready var credits_button = $Start_Menu/VBC/Credits
@onready var quit_button = $Start_Menu/VBC/Quit
@onready var web_link = $Start_Menu/VBC/Developer_LinkButton

@onready var new_popup = $new

@export var web_link_url: String

func _ready() -> void:
	ProfileManager.profile_changed.connect(_on_profile_changed)
	
	game_title.set_text(ProjectSettings.get_setting("application/config/name"))

	profile_button.pressed.connect(start_menu_button_pressed.bind("profile"))
	new_game_button.pressed.connect(start_menu_button_pressed.bind("new_game"))
	load_game_button.pressed.connect(start_menu_button_pressed.bind("load_game"))
	settings_button.pressed.connect(start_menu_button_pressed.bind("settings"))
	credits_button.pressed.connect(start_menu_button_pressed.bind("credits"))
	quit_button.pressed.connect(start_menu_button_pressed.bind("quit"))
	web_link.pressed.connect(start_menu_button_pressed.bind("website"))

	_on_profile_changed()

	new_popup.close_requested.connect(_on_close_requested)
	new_popup.set_wrap_controls(true)

func _on_profile_changed():
	profile_button.set_text(ProfileManager.get_profile_name_current().capitalize())
	if ProfileManager.profile_has_saved_games_current():
		load_game_button.set_disabled(false)
		load_game_button.grab_focus()
	else:
		load_game_button.set_disabled(true)
		new_game_button.grab_focus()

func _on_close_requested() -> void:
	if is_instance_valid(profile_list_window):
		profile_list_window.queue_free()
	if is_instance_valid(load_game_window):
		load_game_window.queue_free()
	
	new_popup.hide()
	
	_on_profile_changed()

func start_menu_button_pressed(button_name: String) -> void:
	match button_name:
		"profile":
			profile_list_window = profile_list_scene.instantiate()
			profile_list_window.close_requested.connect(_on_close_requested)
			add_child(profile_list_window)
		"load_game":
			load_game_window = load_game_scene.instantiate()
			load_game_window.close_requested.connect(_on_close_requested)
			add_child(load_game_window)
		"new_game":
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

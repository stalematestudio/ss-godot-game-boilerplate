class_name TitleControl extends Control

@export var new_game_scene: PackedScene = preload("res://utils/new_game/new_game.tscn")
@onready var new_game_window: NewGameWindow

@export var load_game_scene: PackedScene = preload("res://utils/load_game/load_game.tscn")
@onready var load_game_window: LoadGameWindow

@onready var game_title = $Start_Menu/VBC/Game_Title
@onready var new_game_button = $Start_Menu/VBC/New_Game
@onready var load_game_button = $Start_Menu/VBC/Load_Game
@onready var settings_button = $Start_Menu/VBC/Settings
@onready var credits_button = $Start_Menu/VBC/Credits
@onready var quit_button = $Start_Menu/VBC/Quit
@onready var web_link = $Start_Menu/VBC/Developer_LinkButton

@export var web_link_url: String

func _ready() -> void:
	game_title.set_text(ProjectSettings.get_setting("application/config/name"))

	new_game_button.pressed.connect(start_menu_button_pressed.bind("new_game"))
	load_game_button.pressed.connect(start_menu_button_pressed.bind("load_game"))
	settings_button.pressed.connect(start_menu_button_pressed.bind("settings"))
	credits_button.pressed.connect(start_menu_button_pressed.bind("credits"))
	quit_button.pressed.connect(start_menu_button_pressed.bind("quit"))
	web_link.pressed.connect(start_menu_button_pressed.bind("website"))

func _on_close_requested() -> void:
	if is_instance_valid(new_game_window):
		new_game_window.queue_free()
	if is_instance_valid(load_game_window):
		load_game_window.queue_free()	

func start_menu_button_pressed(button_name: String) -> void:
	_on_close_requested()
	match button_name:
		"new_game":
			new_game_window = new_game_scene.instantiate()
			new_game_window.close_requested.connect(_on_close_requested)
			add_child(new_game_window)
		"load_game":
			load_game_window = load_game_scene.instantiate()
			load_game_window.close_requested.connect(_on_close_requested)
			add_child(load_game_window)
		"settings":
			get_parent().set_settings_display(settings_button)
		"credits":
			GameManager.game_state_change("CREDITS")
		"quit":
			get_tree().quit()
		"website":
			OS.shell_open(web_link_url)

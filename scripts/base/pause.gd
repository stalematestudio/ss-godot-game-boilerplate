extends Control

@onready var game_title = $Pause_Menu/VBC/Game_Title
@onready var resume_game = $Pause_Menu/VBC/Resume
@onready var settings_button = $Pause_Menu/VBC/Settings
@onready var quit_to_title_button = $Pause_Menu/VBC/Quit_To_Title
@onready var quit_game_button = $Pause_Menu/VBC/Quit_Game
@onready var web_link = $Pause_Menu/VBC/Developer_LinkButton

@export var web_link_url: String

func _ready():
	game_title.text = ProjectSettings.get_setting("application/config/name")
	resume_game.connect("pressed", Callable(self, "pause_menu_button_pressed").bind("resume"))
	resume_game.grab_focus()
	settings_button.connect("pressed", Callable(self, "pause_menu_button_pressed").bind("settings"))
	quit_to_title_button.connect("pressed", Callable(self, "pause_menu_button_pressed").bind("quit_to_title"))
	quit_game_button.connect("pressed", Callable(self, "pause_menu_button_pressed").bind("quit_game"))
	web_link.connect("pressed", Callable(self, "pause_menu_button_pressed").bind("website"))

func pause_menu_button_pressed(button_name):
	match button_name:
		"resume":
			GameManager.emit_signal("resume_game")
		"settings":
			get_parent().set_settings_display(settings_button)
		"quit_to_title":
			GameManager.game_state_change("TITLE")
		"quit_game":
			get_tree().quit()
		"website":
			OS.shell_open(web_link_url)

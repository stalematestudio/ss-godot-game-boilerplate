class_name NewGameWindow extends Window

@onready var easy_button: AdvancedButton = $h_box_container/BUTTON_VBOX/EASY
@onready var normal_button: AdvancedButton = $h_box_container/BUTTON_VBOX/NORMAL
@onready var hard_button: AdvancedButton = $h_box_container/BUTTON_VBOX/HARD
@onready var start_button: Button = $h_box_container/BUTTON_VBOX/START
@onready var difficulty_label: Label = $h_box_container/label

var difficulty: String = "normal"

const EASY_INFO: String = """
For the weak.

A casual experience.
"""

const NORMAL_INFO: String = """
For nobody.

Plain vanila.
Balanced with medium challenge.
"""

const HARD_INFO: String = """
GIGACHADS

Shove your own thumbs in your
own eye sockets and self combust.
"""

func _ready() -> void:
	easy_button.pressed.connect(difficulty_button_pressed.bind("easy"))
	easy_button.double_pressed.connect(difficulty_button_double_pressed.bind("easy"))
	normal_button.pressed.connect(difficulty_button_pressed.bind("normal"))
	normal_button.double_pressed.connect(difficulty_button_double_pressed.bind("normal"))
	normal_button.grab_focus()
	hard_button.pressed.connect(difficulty_button_pressed.bind("hard"))
	hard_button.double_pressed.connect(difficulty_button_double_pressed.bind("hard"))
	start_button.pressed.connect(start_button_pressed)
	difficulty_label.set_text(NORMAL_INFO)

	focus_exited.connect(close_requested.emit)

func difficulty_button_pressed(difficulty_selected: String) -> void:
	difficulty = difficulty_selected
	match difficulty:
		"easy":
			difficulty_label.set_text(EASY_INFO)
		"normal":
			difficulty_label.set_text(NORMAL_INFO)
		"hard":
			difficulty_label.set_text(HARD_INFO)

func difficulty_button_double_pressed(difficulty_selected: String) -> void:
	difficulty_button_pressed(difficulty_selected)
	start_button_pressed()

func start_button_pressed() -> void:
	ProfileManager.save_game([{
			"game_time": 0,
			"game_difficulty": difficulty,
			"game_level_loaded": '',
			}])
	GameManager.game_state_change("IN_GAME")

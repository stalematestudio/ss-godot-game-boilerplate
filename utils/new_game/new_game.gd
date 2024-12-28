extends Window

# @onready var close_button = get_close_button()

@onready var easy_button = $BUTTON_VBOX/EASY
@onready var normal_button = $BUTTON_VBOX/NORMAL
@onready var hard_button = $BUTTON_VBOX/HARD
@onready var start_button = $BUTTON_VBOX/START

var difficulty = "normal"

func _ready():

	# close_button.set_focus_neighbor(MARGIN_BOTTOM, easy_button.get_path())

	easy_button.connect("pressed", Callable(self, "difficulty_button_pressed").bind("easy"))
	normal_button.connect("pressed", Callable(self, "difficulty_button_pressed").bind("normal"))
	hard_button.connect("pressed", Callable(self, "difficulty_button_pressed").bind("hard"))
	start_button.connect("pressed", Callable(self, "start_button_pressed"))

func difficulty_button_pressed(button):
	difficulty = button

func start_button_pressed():
	ProfileManager.new_game([{
			"game_time": 0,
			"game_difficulty": difficulty,
			"game_level_loaded": '',
			}])
	GameManager.game_state_change("IN_GAME")

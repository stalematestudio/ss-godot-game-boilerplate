extends WindowDialog

onready var close_button = get_close_button()
onready var easy_button = $BUTTON_VBOX/EASY
onready var normal_button = $BUTTON_VBOX/NORMAL
onready var hard_button = $BUTTON_VBOX/HARD

func _ready():
	close_button.set_focus_neighbour(MARGIN_BOTTOM, easy_button.get_path())
	easy_button.connect("pressed", self, "difficulty_button_pressed", ["easy"])
	normal_button.connect("pressed", self, "difficulty_button_pressed", ["normal"])
	hard_button.connect("pressed", self, "difficulty_button_pressed", ["hard"])

func difficulty_button_pressed(button):
	print(button)
	#GameManager.game_state_change("IN_GAME")

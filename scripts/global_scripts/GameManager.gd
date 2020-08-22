extends Node

onready var OS_NAME = OS.get_name()
onready var main_scene = get_node("/root/main")
onready var game_state
onready var game_states = {
		"INTRO":{
			"scene": "intro_scene",
			"in_game": false
		},
		"TITLE":{
			"scene": "title_scene",
			"in_game": false
		},
		"CREDITS":{
			"scene": "credits_scene",
			"in_game": false
		},
		"IN_GAME":{
			"scene": "game_scene",
			"in_game": true
		}
		}

onready var game_paused = false

func _ready():
	change_state("INTRO")

func pause_game():
	game_paused = true
	get_tree().paused = game_paused
	main_scene.set_pause_display(game_paused)

func resume_game():
	game_paused = false
	get_tree().paused = game_paused
	main_scene.set_pause_display(game_paused)

func change_state(state):
	game_state = game_states[state].duplicate(true)
	if game_state.in_game:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		resume_game()
	main_scene.change_current_scene(game_state.scene)

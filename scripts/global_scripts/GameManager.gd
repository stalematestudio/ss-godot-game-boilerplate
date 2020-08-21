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

func _ready():
	change_state("INTRO")

func pause_game():
	get_tree().paused = !get_tree().paused
	main_scene.set_pause_display(get_tree().paused)

func change_state(state):
	game_state = game_states[state].duplicate(true)
	main_scene.change_current_scene(game_state.scene)

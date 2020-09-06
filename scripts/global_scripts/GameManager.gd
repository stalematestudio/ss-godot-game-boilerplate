extends Node

onready var OS_NAME = OS.get_name()
onready var main_scene = get_node("/root/main")
onready var game_state = false
onready var game_states = {
		"INTRO":{
			"scene": "intro_scene",
			"in_game": false,
			"mouse_mode": funcref(self, "mouse_mode_game")
		},
		"TITLE":{
			"scene": "title_scene",
			"in_game": false,
			"mouse_mode": funcref(self, "mouse_mode_ui")
		},
		"CREDITS":{
			"scene": "credits_scene",
			"in_game": false,
			"mouse_mode": funcref(self, "mouse_mode_game")
		},
		"IN_GAME":{
			"scene": "game_scene",
			"in_game": true,
			"mouse_mode": funcref(self, "mouse_mode_game")
		}
		}

onready var game_paused = false

func _notification(what):
	if game_state:
		match what:
			NOTIFICATION_WM_FOCUS_IN:
				if game_state.in_game and ConfigManager.config_data.game.resume_on_focus_grab:
					resume_game()
			NOTIFICATION_WM_FOCUS_OUT:
				if game_state.in_game and ConfigManager.config_data.game.pause_on_focus_loss:
					pause_game()

func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	apply_config()
	change_state("INTRO")

func apply_config():
	main_scene.set_debug_display(ConfigManager.config_data.game.debug)

func _process(delta):
	# Pause game
	if Input.is_action_just_released("util_pause") and game_state.in_game:
		if game_paused:
			GameManager.resume_game()
		else:
			GameManager.pause_game()

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
	if not game_state.in_game:
		resume_game()
	game_state.mouse_mode.call_func()
	main_scene.change_current_scene(game_state.scene)

func mouse_mode_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func mouse_mode_ui():
	if ConfigManager.config_data.game.mouse_mode_confined:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

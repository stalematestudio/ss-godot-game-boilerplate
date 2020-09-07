extends Node

signal game_state_changed
signal pause_game
signal resume_game

onready var main_scene = get_node("/root/main")

onready var game_paused = false
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

func _ready():
	yield(main_scene, "ready") # Wait For Main Scene to be ready.
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	self.connect("resume_game", self, "_on_resume_game")
	self.connect("pause_game", self, "_on_pause_game")
	InputManager.connect("joypad_active", self, "_on_joypad_active")
	InputManager.connect("joypad_inactive", self, "_on_joypad_inactive")
	apply_config()
	game_state_change("INTRO")

func apply_config():
	main_scene.set_debug_display(ConfigManager.config_data.game.debug)
	if game_state:
		game_state.mouse_mode.call_func()

func _notification(what):
	if game_state:
		match what:
			NOTIFICATION_WM_FOCUS_IN:
				if game_state.in_game and ConfigManager.config_data.game.resume_on_focus_grab:
					emit_signal("resume_game")
			NOTIFICATION_WM_FOCUS_OUT:
				if game_state.in_game and ConfigManager.config_data.game.pause_on_focus_loss:
					emit_signal("pause_game")

func _input(event):
	if event.is_action_released("util_pause") and game_state.in_game:
		if game_paused:
			emit_signal("resume_game")
		else:
			emit_signal("pause_game")

func _on_pause_game():
	game_paused = true
	game_state.mouse_mode.call_func()
	get_tree().paused = game_paused

func _on_resume_game():
	game_paused = false
	game_state.mouse_mode.call_func()
	get_tree().paused = game_paused

func game_state_change(state):
	game_state = game_states[state].duplicate(true)
	game_state.mouse_mode.call_func()
	if not game_state.in_game:
		emit_signal("resume_game")
	emit_signal("game_state_changed")

func mouse_mode_game():
	if game_paused:
		mouse_mode_ui()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func mouse_mode_ui():
	if ConfigManager.config_data.game.mouse_mode_confined:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_joypad_active():
	if ( Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED ) or ( Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE ):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_joypad_inactive():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_HIDDEN:
		mouse_mode_ui()

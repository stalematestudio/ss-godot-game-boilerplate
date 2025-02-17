extends Node

signal message(message)
signal game_state_changed
signal debug_state_changed
signal pause_game
signal resume_game
signal load_game(load_type)
signal save_game(save_type)

@onready var game_paused: bool = false
@onready var game_state: Dictionary = {}
@onready var game_states: Dictionary = {
		"INTRO":{
			"scene": "intro_scene",
			"in_game": false,
			"mouse_mode": mouse_mode_game
		},
		"TITLE":{
			"scene": "title_scene",
			"in_game": false,
			"mouse_mode": mouse_mode_ui
		},
		"CREDITS":{
			"scene": "credits_scene",
			"in_game": false,
			"mouse_mode": mouse_mode_game
		},
		"IN_GAME":{
			"scene": "game_scene",
			"in_game": true,
			"mouse_mode": mouse_mode_game
		}
		}

func _ready():
	await get_node("/root/main").ready # Wait For Main Scene to be ready.
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	ConfigManager.connect("config_update", Callable(self, "apply_config"))
	self.connect("pause_game", Callable(self, "_on_pause_game"))
	self.connect("resume_game", Callable(self, "_on_resume_game"))
	InputManager.connect("joypad_active", Callable(self, "_on_joypad_active"))
	InputManager.connect("joypad_inactive", Callable(self, "_on_joypad_inactive"))
	game_state_change("INTRO")

func apply_config():
	debug_state_changed.emit()
	if game_state:
		game_state.mouse_mode.call()
	OS.set_low_processor_usage_mode(ConfigManager.config_data.game.low_processor_usage_mode)
	if OS.is_in_low_processor_usage_mode():
		OS.set_low_processor_usage_mode_sleep_usec(ConfigManager.config_data.game.low_processor_usage_mode_sleep_usec)
	Engine.set_physics_ticks_per_second(ConfigManager.config_data.game.physics_ticks_per_second)
	Engine.set_physics_jitter_fix(ConfigManager.config_data.game.physics_jitter_fix)
	Engine.max_fps = ConfigManager.config_data.game.max_fps
	Engine.set_time_scale(ConfigManager.config_data.game.time_scale)

func _notification(what):
	if game_state:
		match what:
			NOTIFICATION_APPLICATION_FOCUS_IN:
				if game_state.in_game and ConfigManager.config_data.game.resume_on_focus_grab:
					resume_game.emit()
			NOTIFICATION_APPLICATION_FOCUS_OUT:
				if game_state.in_game and ConfigManager.config_data.game.pause_on_focus_loss:
					pause_game.emit()

func _input(event):
	if event.is_action_released("util_pause") and game_state.in_game:
		get_viewport().set_input_as_handled()
		if game_paused:
			resume_game.emit()
		else:
			pause_game.emit()
	elif event.is_action_released("util_screenshot"):
		ProfileManager.screenshot()
	elif event.is_action_released("util_quick_load") and game_state.in_game:
		load_game.emit()
	elif event.is_action_released("util_quick_save") and game_state.in_game:
		save_game.emit()

func _on_pause_game():
	game_paused = true
	game_state.mouse_mode.call()
	get_tree().paused = game_paused

func _on_resume_game():
	game_paused = false
	game_state.mouse_mode.call()
	get_tree().paused = game_paused

func game_state_change(state):
	game_state = game_states[state].duplicate(true)
	game_state.mouse_mode.call()
	if not game_state.in_game:
		resume_game.emit()
	game_state_changed.emit()
	message.emit("True" if game_state else "False")

func mouse_mode_hidden():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

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
	if (Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED) or (Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_joypad_inactive():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_HIDDEN:
		mouse_mode_ui()

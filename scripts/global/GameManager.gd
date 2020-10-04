extends Node

signal message(message)
signal game_state_changed
signal debug_state_changed
signal pause_game
signal resume_game
signal load_game(load_type)
signal save_game(save_type)

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
	yield(get_node("/root/main"), "ready") # Wait For Main Scene to be ready.
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	ConfigManager.connect("config_update", self, "apply_config")
	self.connect("pause_game", self, "_on_pause_game")
	self.connect("resume_game", self, "_on_resume_game")
	InputManager.connect("joypad_active", self, "_on_joypad_active")
	InputManager.connect("joypad_inactive", self, "_on_joypad_inactive")
	game_state_change("INTRO")

func apply_config():
	emit_signal("debug_state_changed")
	if game_state:
		game_state.mouse_mode.call_func()
	OS.set_low_processor_usage_mode(ConfigManager.config_data.game.low_processor_usage_mode)
	if OS.is_in_low_processor_usage_mode():
		OS.set_low_processor_usage_mode_sleep_usec(ConfigManager.config_data.game.low_processor_usage_mode_sleep_usec)
	Engine.set_iterations_per_second(ConfigManager.config_data.game.iterations_per_second)
	Engine.set_physics_jitter_fix(ConfigManager.config_data.game.physics_jitter_fix)
	Engine.set_target_fps(ConfigManager.config_data.game.target_fps)
	Engine.set_time_scale(ConfigManager.config_data.game.time_scale)

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
		get_tree().set_input_as_handled()
		if game_paused:
			emit_signal("resume_game")
		else:
			emit_signal("pause_game")
	elif event.is_action_released("util_screenshot"):
		screenshot()
	elif event.is_action_released("util_quick_load") and game_state.in_game:
		emit_signal("load_game")
	elif event.is_action_released("util_quick_save") and game_state.in_game:
		emit_signal("save_game")

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
	emit_signal("message", String( game_state ))

func screenshot():
	# Check if path exists
	var dir_path = ProfileManager.get_current_profile_screenshot_path()
	var dir = Directory.new()
	if not dir.dir_exists(dir_path):
		dir.make_dir_recursive(dir_path)

	var img = get_viewport().get_texture().get_data()
	img.flip_y()

	var img_path = dir_path + Helpers.date_time_string() + ".png"
	var err = img.save_png(img_path)
	if err == OK:
		emit_signal("message", "Screenshot saved: " + img_path)
	else:
		emit_signal("message", "Screenshot save error: " + String(err))

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
	if ( Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED ) or ( Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE ):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_joypad_inactive():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_HIDDEN:
		mouse_mode_ui()

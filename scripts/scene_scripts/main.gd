extends Node

# Scenes
export (PackedScene) var intro_scene
export (PackedScene) var title_scene
export (PackedScene) var credits_scene
export (PackedScene) var game_scene

# Sub Scenes
export (PackedScene) var debug_scene
export (PackedScene) var settings_scene
export (PackedScene) var pause_scene

# Scene Instances
var current_scene_instance
var debug_scene_instance
var settings_scene_instance
var pause_scene_instance

func _ready():
	GameManager.connect("pause_game", self, "set_pause_display", [true])
	GameManager.connect("resume_game", self, "set_pause_display", [false])
	GameManager.connect("game_state_changed", self, "_on_game_state_changed")

func _on_game_state_changed():
	if is_instance_valid(settings_scene_instance):
		settings_scene_instance.queue_free()
	if is_instance_valid(current_scene_instance):
		current_scene_instance.queue_free()
	match GameManager.game_state.scene:
		"intro_scene":
			current_scene_instance = intro_scene.instance()
		"title_scene":
			current_scene_instance = title_scene.instance()
		"credits_scene":
			current_scene_instance = credits_scene.instance()
		"game_scene":
			current_scene_instance = game_scene.instance()
	add_child(current_scene_instance)

func set_debug_display(debug_enabled):
	if debug_enabled:
		if not is_instance_valid(debug_scene_instance):
			debug_scene_instance = debug_scene.instance()
			add_child(debug_scene_instance)
	else:
		if is_instance_valid(debug_scene_instance):
			debug_scene_instance.queue_free()

func set_settings_display(return_focus_target):
	if is_instance_valid(settings_scene_instance):
		settings_scene_instance.queue_free()
	else:
		settings_scene_instance = settings_scene.instance()
		settings_scene_instance.return_focus_target = return_focus_target
		add_child(settings_scene_instance)

func set_pause_display(set_paused):
	if set_paused:
		if not is_instance_valid(pause_scene_instance):
			pause_scene_instance = pause_scene.instance()
			add_child(pause_scene_instance)
	else:
		if is_instance_valid(settings_scene_instance):
			settings_scene_instance.queue_free()
		if is_instance_valid(pause_scene_instance):
			pause_scene_instance.queue_free()

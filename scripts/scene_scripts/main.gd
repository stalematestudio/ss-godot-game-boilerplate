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

onready var ui_target
onready var root = get_node("/root")

func _ready():
	root.connect("gui_focus_changed", self, "_on_gui_focus_changed")
	GameManager.connect("game_state_changed", self, "_on_game_state_changed")
	GameManager.connect("debug_state_changed", self, "_on_debug_state_changed")
	GameManager.connect("pause_game", self, "_on_pause_game")
	GameManager.connect("resume_game", self, "_on_resume_game")
	
func ui_target_disconnect():
	if ( ui_target is Button ) and ui_target.is_connected("pressed", AudioManager, "ui_accept_audio_effect"):
		ui_target.disconnect("pressed", AudioManager, "ui_accept_audio_effect")
	elif ( ui_target is Slider ) and ui_target.is_connected("value_changed", AudioManager, "ui_navigate_audio_effect") and ( ui_target.is_editable() ):
		ui_target.disconnect("value_changed", AudioManager, "ui_navigate_audio_effect")

func ui_target_connect():
	if ( ui_target is Button ) and ( not ui_target.is_connected("pressed", AudioManager, "ui_accept_audio_effect") ):
		ui_target.connect("pressed", AudioManager, "ui_accept_audio_effect")
	elif ( ui_target is Slider ) and ( not ui_target.is_connected("value_changed", AudioManager, "ui_navigate_audio_effect") ) and ( ui_target.is_editable() ):
		ui_target.connect("value_changed", AudioManager, "ui_navigate_audio_effect")

func _on_gui_focus_changed(target):
	if ( target is Button ) or ( target is Slider ):
		ui_target_disconnect()
		ui_target = target
		ui_target_connect()
		if not AudioManager.FX_Player.is_playing():
			AudioManager.ui_navigate_audio_effect()

func _on_game_state_changed():
	ui_target_disconnect()
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

func _on_debug_state_changed():
	if ConfigManager.config_data.game.debug:
		if not is_instance_valid(debug_scene_instance):
			debug_scene_instance = debug_scene.instance()
			add_child(debug_scene_instance)
	else:
		if is_instance_valid(debug_scene_instance):
			debug_scene_instance.queue_free()

func _on_pause_game():
	if not is_instance_valid(pause_scene_instance):
		pause_scene_instance = pause_scene.instance()
		add_child(pause_scene_instance)

func _on_resume_game():
	ui_target_disconnect()
	if is_instance_valid(settings_scene_instance):
		settings_scene_instance.queue_free()
	if is_instance_valid(pause_scene_instance):
		pause_scene_instance.queue_free()

func set_settings_display(return_focus_target):
	if is_instance_valid(settings_scene_instance):
		settings_scene_instance.queue_free()
	else:
		settings_scene_instance = settings_scene.instance()
		settings_scene_instance.return_focus_target = return_focus_target
		add_child(settings_scene_instance)
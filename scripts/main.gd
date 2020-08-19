extends Node

# Get Globals
onready var globals = get_node("/root/Globals")
onready var config_manager = get_node("/root/ConfigManager")
onready var audio_manager = get_node("/root/AudioManager")

# Scenes
export (PackedScene) var intro_scene 
export (PackedScene) var title_scene
export (PackedScene) var settings_scene
export (PackedScene) var debug_scene
export (PackedScene) var game_scene

var current_scene_instance
var debug_scene_instance

func _ready():
	set_debug_display()
	change_current_scene("intro_scene")

func set_debug_display():
	if is_instance_valid(audio_manager):
		if config_manager.config_data.game.debug:
			if not is_instance_valid(debug_scene_instance):
				debug_scene_instance = debug_scene.instance()
				add_child(debug_scene_instance)
		else:
			if is_instance_valid(debug_scene_instance):
				debug_scene_instance.queue_free()

func change_current_scene(new_scene):
	if is_instance_valid(current_scene_instance):
		current_scene_instance.queue_free()
	match new_scene:
		"intro_scene":
			current_scene_instance = intro_scene.instance()
		"title_scene":
			current_scene_instance = title_scene.instance()
		"game_scene":
			current_scene_instance = game_scene.instance()
	add_child(current_scene_instance)

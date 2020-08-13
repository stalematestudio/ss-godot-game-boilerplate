extends Node

# Get Globals
onready var globals = get_node("/root/Globals")
onready var config_manager = get_node("/root/ConfigManager")
onready var audio_manager = get_node("/root/AudioManager")

# Scenes
export (PackedScene) var intro_scene 
export (PackedScene) var title_scene
export (PackedScene) var demo_scene

var current_scene

func _ready():
	change_current_scene("intro_scene")

func change_current_scene(new_scene):
	if is_instance_valid(current_scene):
		current_scene.queue_free()
	match new_scene:
		"intro_scene":
			current_scene = intro_scene.instance()
		"title_scene":
			current_scene = title_scene.instance()
		"demo_scene":
			current_scene = demo_scene.instance()
	add_child(current_scene)

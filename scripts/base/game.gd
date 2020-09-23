extends Node

onready var game_time = 0

func _ready():
	if is_inside_tree() and not is_in_group("game_save_objects"):
		add_to_group("game_save_objects", true)

func  _process(delta):
	game_time += delta

extends Node

onready var game_time = 0

func _ready():
	GameManager.connect("save_game", self, "_on_save_game")
	GameManager.connect("load_game", self, "_on_load_game")

func  _process(delta):
	game_time += delta

func _on_save_game():
	var game_data = {}
	for gs_obj in get_tree().get_nodes_in_group("game_save_objects"):
		print("Name : " + gs_obj.name)
		print("FileName : " + gs_obj.get_filename())
		print("Path : " + gs_obj.get_parent().get_path())
	ProfileManager.save_game(game_data)
	
func _on_load_game():
	ProfileManager.load_game()

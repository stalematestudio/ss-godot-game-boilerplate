class_name NPCManager extends Node

@onready var game: GameplayManager = get_parent()

func _ready() -> void:
	if is_inside_tree() and not is_in_group("game_managers"):
		add_to_group("game_managers", true)

func save_data() -> Dictionary:
	return {"npcs": {}}

func load_data(_npcs: Dictionary = Dictionary()) -> void:
	pass

class_name WorldManager extends Node

@onready var game: GameplayManager = get_parent()
@onready var world: WorldEnvironment = get_node("/root/main/WorldEnvironment")
@onready var sun: DirectionalLight3D = get_node("/root/main/sun")
@onready var day_cycle_animation_player: AnimationPlayer = get_node("/root/main/day_cycle_animation_player")

func save_data() -> Dictionary:
	return {"world": {}}

func load_data(_world: Dictionary = Dictionary()) -> void:
	pass

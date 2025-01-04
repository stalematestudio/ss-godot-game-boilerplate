class_name WorldManager extends Node

@onready var world: WorldEnvironment = get_node("/root/main/WorldEnvironment")
@onready var sun: DirectionalLight3D = get_node("/root/main/sun")
@onready var animation_player: AnimationPlayer = get_node("/root/main/animation_player")

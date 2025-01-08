class_name PlayArea extends Area3D

@onready var maps_manager: MapsManager = get_parent()
@onready var props_parent: Node3D = find_child("Props", false)

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		maps_manager.level_active = name

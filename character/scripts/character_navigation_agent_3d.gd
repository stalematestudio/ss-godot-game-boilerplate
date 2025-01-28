class_name CharacterNavigationAgent3D extends NavigationAgent3D

@onready var character: Character = get_parent()
@onready var home_possition: Vector3 = character.global_position

func _ready() -> void:
	target_reached.connect(on_target_reached)
	navigation_finished.connect(on_navigation_finished)

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	get_next_path_position()

func on_target_reached() -> void:
	pass

func on_navigation_finished() -> void:
	pass

class_name CharacterCamera3D extends Camera3D

# Camera positions
@export var camera_position: Array[Vector3] = [
	Vector3(),Vector3(0,0,-1),Vector3(0,0.5,-2)
]

var _camera_position_selected: int = 0
var camera_position_selected: int:
	get:
		return _camera_position_selected
	set(new_camera_position_selected):
		if new_camera_position_selected == _camera_position_selected:
			return
		_camera_position_selected = _camera_position_selected + 1 if _camera_position_selected < camera_position.size() - 1 else 0
		position = camera_position[_camera_position_selected]

@onready var character_instance: Character = get_parent().get_parent()

func _ready() -> void:
	VideoManager.camera_config_changed.connect(_on_camera_config_changed)
	_on_camera_config_changed()

func _process(_delta: float) -> void:
	set_current(character_instance.is_player_controlled)

func _on_camera_config_changed() -> void:
	set_fov(ConfigManager.config_data.video.fov)

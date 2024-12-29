class_name PlayerCamera extends Camera3D

# Camera positions
@export var camera_position: Array[Vector3] = [
	Vector3(),Vector3(0,0,-1),Vector3(0,.5,-2)
]
@onready var camera_position_selected = 0

func _ready():
	VideoManager.camera_config_changed.connect(_on_camera_config_changed)
	_on_camera_config_changed()

func _on_camera_config_changed():
	set_fov(ConfigManager.config_data.video.fov)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("util_camera_switch"):
		camera_position_selected = camera_position_selected + 1 if camera_position_selected < camera_position.size() - 1 else 0
		position = camera_position[camera_position_selected]
	if event.is_action_pressed("zoom_in"):
		set_fov(fov-1)
	if event.is_action_pressed("zoom_out"):
		set_fov(fov+1)
	if event.is_action_pressed("zoom_reset"):
		set_fov(ConfigManager.config_data.video.fov)

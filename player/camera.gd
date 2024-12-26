extends Camera3D

func _ready():
	VideoManager.camera_config_changed.connect(_on_camera_config_changed)
	_on_camera_config_changed()

func _on_camera_config_changed():
	set_fov(ConfigManager.config_data.video.fov)

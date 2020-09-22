extends Camera

func _ready():
	VideoManager.connect("camera_config_changed", self ,"_on_camera_config_changed")
	_on_camera_config_changed()

func _on_camera_config_changed():
	set_fov(ConfigManager.config_data.video.fov)

extends Container

onready var fps_display = $HBoxContainer/FPS_Display

func _process(delta):
	fps_display.text = String(Engine.get_frames_per_second())

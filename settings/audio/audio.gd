extends TabBar

@export var bus: PackedScene

@onready var gui_audio_vbc = $Settings_Scroll/Settings_VBC/Audio_Bus_Volume_VBC
@onready var gui_playback = $Settings_Scroll/Settings_VBC/Audio_Playback_Device/OptionButton
@onready var gui_capture = $Settings_Scroll/Settings_VBC/Audio_Capture_Device/OptionButton

@onready var audio_devices = AudioServer.get_output_device_list()

func _ready():
	gui_playback.connect("item_selected", Callable(self, "set_playback_device"))

func set_form_values():
	Helpers.RemoveChildren(gui_audio_vbc)
	for key in ConfigManager.config_data.audio.keys():
		var audio_bus = bus.instantiate()
		audio_bus.name = key
		gui_audio_vbc.add_child(audio_bus)

	for audio_device in audio_devices:
		gui_playback.add_item(audio_device)

func set_playback_device(new_val):
	AudioServer.set_output_device(audio_devices[new_val])

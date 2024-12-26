extends HBoxContainer

@onready var bus = AudioManager.audio_bus[self.name]
@onready var label = $Label
@onready var slider = $VBC/HBC/Slider
@onready var display = $VBC/HBC/Display
@onready var mute = $VBC/Mute

func _ready():
	label.set_text(self.name)

	slider.connect("value_changed", Callable(self, "volume_adjust"))
	mute.connect("pressed", Callable(self, "mute_adjust"))

	slider.set_value(ConfigManager.config_data.audio[self.name].volume)
	mute.set_pressed(ConfigManager.config_data.audio[self.name].mute)

	set_elements_disabled()

func set_elements_disabled():
	if mute.is_pressed():
		slider.set_editable(false)
		display.set_self_modulate(Color("#ffffff40"))
	else:
		slider.set_editable(true)
		display.set_self_modulate(Color("#ffffffff"))

func volume_adjust(new_val):
	ConfigManager.config_data.audio[self.name].volume = new_val
	AudioManager.set_audio(bus, ConfigManager.config_data.audio[self.name].mute, ConfigManager.config_data.audio[self.name].volume)
	display.text = String.num(ConfigManager.config_data.audio[self.name].volume)

func mute_adjust():
	ConfigManager.config_data.audio[self.name].mute = mute.is_pressed()
	AudioManager.set_audio(bus, ConfigManager.config_data.audio[self.name].mute, ConfigManager.config_data.audio[self.name].volume)
	set_elements_disabled()

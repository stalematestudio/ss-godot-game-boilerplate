extends Node

signal message(message)
signal joypad_active
signal joypad_inactive

onready var joypad_present = false
onready var joypad_device_id = 0

func _ready():
	yield(get_node("/root/main"), "ready") # Wait For Main Scene to be ready.
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	ConfigManager.connect("config_update", self, "apply_config")
	
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")

func apply_config():
	controller_setup()
	apply_config_keybind()

func _input(event):
	if ( event is InputEventJoypadButton ) or ( event is InputEventJoypadMotion ):
		emit_signal("joypad_active")
	elif ( event is InputEventMouseButton ) or ( event is InputEventMouseMotion ) :
		emit_signal("joypad_inactive")

func apply_config_keybind():
	for action in ConfigManager.config_data.keybind:
		InputMap.action_set_deadzone(action, ConfigManager.config_data.keybind[action].deadzone)
		InputMap.action_erase_events(action)
		for event in ConfigManager.config_data.keybind[action].events:
			InputMap.action_add_event(action, event)

func _on_joy_connection_changed(device, connected):
	if connected:
		joypad_present = true
		joypad_device_id = device
	else:
		controller_setup()

func controller_setup():
	var joypads = Input.get_connected_joypads()
	if joypads.empty():
		joypad_present = false
		joypad_device_id = 0
	else:
		joypad_present = true
		joypad_device_id = joypads[0]

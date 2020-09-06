extends Node

func _ready():
	apply_config()

func apply_config():
	# Key Binding
	for action in ConfigManager.config_data.keybind:
		InputMap.action_set_deadzone(action, ConfigManager.config_data.keybind[action].deadzone)
		InputMap.action_erase_events(action)
		for event in ConfigManager.config_data.keybind[action].events:
			InputMap.action_add_event(action, event)
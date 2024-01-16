extends TabBar

@export (PackedScene) var keybind_action

@onready var gui_key_binding_vbc = $Settings_Scroll/Settings_VBC/Key_Bind_VBC

func set_form_values():
	Helpers.RemoveChildren(gui_key_binding_vbc)
	for action in ConfigManager.config_data.keybind:
		var action_element = keybind_action.instantiate()
		action_element.name = action
		action_element.action = action
		gui_key_binding_vbc.add_child(action_element)

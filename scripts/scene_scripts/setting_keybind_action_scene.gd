extends VBoxContainer

export (PackedScene) var setting_keybind_event_scene
export (PackedScene) var setting_keybind_input_scene

var action
var action_data
onready var action_label = $Action_HBC/Action_Label
onready var dead_zone_slider = $Action_HBC/Deadzone_Slider
onready var dead_zone_display = $Action_HBC/Deadzone_Display
onready var events_vbc = $Events_VBC
onready var add_event = $Event_Add

func element_setup():
	self.name = action
	action_label.set_text(action.replace('_', ' ').to_upper())
	dead_zone_slider.set_value(action_data['deadzone'])
	dead_zone_slider.connect("value_changed", self, "deadzone_adjust")
	dead_zone_display.set_text(String(action_data['deadzone']))
	for event in action_data['events']:
		var event_node = setting_keybind_event_scene.instance()
		events_vbc.add_child(event_node)
		event_node.action = action
		event_node.event = event
		event_node.element_setup()
		
func deadzone_adjust(new_val):
	ConfigManager.config_data.keybinding[action].deadzone = new_val
	dead_zone_display.set_text(String(ConfigManager.config_data.keybinding[action].deadzone))

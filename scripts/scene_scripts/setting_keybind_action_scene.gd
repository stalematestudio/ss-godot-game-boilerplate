extends VBoxContainer

export (PackedScene) var setting_keybind_event_scene
export (PackedScene) var setting_keybind_input_scene

# ConfigManager.config_data.keybinding[action].deadzone
# ConfigManager.config_data.keybinding[action].events

var action
onready var action_label = $Action_HBC/Action_Label
onready var dead_zone_slider = $Action_HBC/Deadzone_Slider
onready var dead_zone_display = $Action_HBC/Deadzone_Display
onready var events_vbc = $Events_VBC
onready var add_event = $Event_Add

func _ready():
	add_event.connect("pressed", self, "add_event")

func element_setup():
	self.name = action
	action_label.set_text(action.replace('_', ' ').to_upper())
	dead_zone_slider.set_value(ConfigManager.config_data.keybinding[action].deadzone)
	dead_zone_slider.connect("value_changed", self, "deadzone_adjust")
	dead_zone_display.set_text(String(ConfigManager.config_data.keybinding[action].deadzone))
	display_events()

func display_events():
	Helpers.RemoveChildren(events_vbc)
	for event in ConfigManager.config_data.keybinding[action].events:
		var event_node = setting_keybind_event_scene.instance()
		events_vbc.add_child(event_node)
		event_node.action = action
		event_node.event = event
		event_node.element_setup()

func deadzone_adjust(new_val):
	ConfigManager.config_data.keybinding[action].deadzone = new_val
	dead_zone_display.set_text(String(ConfigManager.config_data.keybinding[action].deadzone))

func add_event():
	var add_event_node = setting_keybind_input_scene.instance()
	.add_child(add_event_node)
	add_event_node.action = action
	add_event_node.called_from = self

func handle_add_event(event):
	ConfigManager.config_data.keybinding[action].events.append(event)
	display_events()

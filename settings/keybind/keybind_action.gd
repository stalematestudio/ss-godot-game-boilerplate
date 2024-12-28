extends VBoxContainer

@export var keybind_event: PackedScene
@export var keybind_input: PackedScene

var action
@onready var action_label = $Action_HBC/Action_Label
@onready var dead_zone_slider = $Action_HBC/Deadzone_Slider
@onready var dead_zone_display = $Action_HBC/Deadzone_Display
@onready var events_vbc = $Events_VBC
@onready var add_event_button = $Event_Add_Button

func _ready():
	add_event_button.connect("pressed", Callable(self, "add_event"))
	action_label.set_text(action.replace('_', ' ').to_upper())
	dead_zone_slider.set_value(ConfigManager.config_data.keybind[action].deadzone)
	dead_zone_slider.connect("value_changed", Callable(self, "deadzone_adjust"))
	dead_zone_display.set_text(String.num(ConfigManager.config_data.keybind[action].deadzone))
	display_events()

func display_events():
	Helpers.remove_children(events_vbc)
	for event in ConfigManager.config_data.keybind[action].events:
		var event_node = keybind_event.instantiate()
		event_node.action = action
		event_node.event = event
		event_node.called_from = self
		events_vbc.add_child(event_node)

func deadzone_adjust(new_val):
	ConfigManager.config_data.keybind[action].deadzone = new_val
	dead_zone_display.set_text(String.num(ConfigManager.config_data.keybind[action].deadzone))

func add_event():
	var add_event_node = keybind_input.instantiate()
	add_event_node.action = action
	add_event_node.called_from = self
	super.add_child(add_event_node)

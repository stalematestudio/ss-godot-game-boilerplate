extends HBoxContainer

var action
var event
var called_from

@onready var event_label = $Event_Label
@onready var event_remove = $Event_Remove

func _ready():
	event_remove.connect("pressed", Callable(self, "remove_self"))
	event_label.set_text(Helpers.event_as_text(event))

func remove_self():
	ConfigManager.config_data.keybind[action].events.erase(event)
	called_from.add_event_button.grab_focus()
	super.queue_free()

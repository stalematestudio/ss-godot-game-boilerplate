extends HBoxContainer

var action
var event

onready var event_label = $Event_Label
onready var event_remove = $Event_Remove

func _ready():
	event_remove.connect("pressed", self, "remove_self")
	event_label.set_text(Helpers.event_as_text(event))

func remove_self():
	ConfigManager.config_data.keybinding[action].events.erase(event)
	get_node("../../Event_Add").grab_focus()
	.queue_free()

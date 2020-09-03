extends HBoxContainer

onready var action
onready var event
onready var event_label = $Event_Label
onready var event_remove = $Event_Remove

func _ready():
	event_remove.connect("pressed", self, "remove_self")

func element_setup():
	var label_text = ''
	if event is InputEventKey:
		label_text = "Key : " + event.as_text()
	elif event is InputEventMouseButton:
		label_text = "Mouse Button : " + Helpers.ButtonIndex2ButtonName( event.get_button_index() )
	elif event is InputEventJoypadMotion:
		label_text = Input.get_joy_name( ConfigManager.joypad_device_id ) + ' : ' + Input.get_joy_axis_string( event.axis )
		label_text += ' pos' if event.axis_value > 0 else ' neg'
	elif event is InputEventJoypadButton:
		label_text = Input.get_joy_name( ConfigManager.joypad_device_id ) + ' : ' + Input.get_joy_button_string( event.button_index )
	else:
		event_label.set_text(event.as_text())
	event_label.set_text(label_text)

func remove_self():
	ConfigManager.config_data.keybinding[action].events.erase(event)
	get_node("../../Event_Add").grab_focus()
	.queue_free()

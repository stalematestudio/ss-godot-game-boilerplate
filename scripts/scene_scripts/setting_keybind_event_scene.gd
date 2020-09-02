extends HBoxContainer

onready var action
onready var event
onready var event_label = $Event_Label
onready var event_remove = $Event_Remove

func _ready():
	event_remove.connect("pressed", self, "remove_self")

func element_setup():
	self.name = event.as_text()
	if event is InputEventKey:
		event_label.set_text( "Key : " + event.as_text() )
	elif event is InputEventMouseButton:
		event_label.set_text( "Mouse Button : " + Helpers.ButtonIndex2ButtonName( event.get_button_index() ) )
	elif event is InputEventJoypadMotion:
		event_label.set_text( Input.get_joy_name( ConfigManager.joypad_device_id ) + ' : ' + Input.get_joy_axis_string( event.axis ) )
		print(event.as_text())
	elif event is InputEventJoypadButton:
		event_label.set_text( Input.get_joy_name( ConfigManager.joypad_device_id ) + ' : ' + Input.get_joy_button_string( event.button_index ) )
		print(event.as_text())
	else:
		event_label.set_text(event.as_text())

func remove_self():
	print(action, event)

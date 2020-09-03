extends PopupDialog

var action
var called_from

onready var new_event = false
onready var accept = $Elements_VBC/Buttons_HBC/Accept_Button
onready var reset = $Elements_VBC/Buttons_HBC/Reset_Button
onready var cancel = $Elements_VBC/Buttons_HBC/Cancel_Button
onready var ins_label = $Elements_VBC/Instruction_Label
onready var event_label = $Elements_VBC/Event_Label

func _ready():
	new_event = false
	ins_label.set_text('ENTER INPUT FOR ' + action.replace('_', ' ').to_upper())
	reset.connect("pressed", self, "reset_new_event")
	accept.connect("pressed", self, "add_new_event")
	cancel.connect("pressed", self, "cancel_new_event")
	.show()

func _input(event):
	if new_event is bool:
		if event is InputEventKey:
			new_event = event
		if event is InputEventMouseMotion:
			return
		elif event is InputEventMouseButton:
			new_event = event
		elif event is InputEventJoypadMotion and abs(event.axis_value) > 0.5:
			new_event = event
		elif event is InputEventJoypadButton:
			new_event = event
		event_label.set_text(Helpers.event_as_text(new_event))
		accept.disabled = false
		reset.disabled = false

func reset_new_event():
	new_event = false
	event_label.set_text('')
	accept.disabled = true
	reset.disabled = true

func add_new_event():
	ConfigManager.config_data.keybinding[action].events.append(new_event)
	called_from.display_events()
	cancel_new_event()

func cancel_new_event():
	get_node("../Event_Add").grab_focus()
	.queue_free()

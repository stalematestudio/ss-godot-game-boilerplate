extends PopupDialog

var called_from

onready var action
onready var new_event = false
onready var reset = $Elements_VBC/Buttons_HBC/Reset_Button
onready var accept = $Elements_VBC/Buttons_HBC/Accept_Button
onready var cancel = $Elements_VBC/Buttons_HBC/Cancel_Button
onready var event_label = $Elements_VBC/Event_Label

func _ready():
	reset.connect("pressed", self, "reset_new_event")
	accept.connect("pressed", called_from, "handle_add_event", [new_event])
	cancel.connect("pressed", self, "queue_free")
	.show()

func _input(event):
	new_event = event
	event_label.set_text(event.as_text())

func reset_new_event():
	new_event = false
	event_label.set_text('')
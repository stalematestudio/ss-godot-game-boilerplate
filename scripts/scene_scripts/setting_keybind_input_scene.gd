extends PopupDialog

onready var action

func _ready():
	.show()

func _input(event):
	get_parent().handle_add_event(event)
	.queue_free()

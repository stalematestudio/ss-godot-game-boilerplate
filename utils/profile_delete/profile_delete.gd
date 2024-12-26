class_name ProfileDeleteDialog extends ConfirmationDialog

@onready var ok_button: Button = get_ok_button()
@onready var cancel_button: Button = get_cancel_button()

signal profile_delete_cancel

func _ready() -> void:
	close_requested.connect(_on_close_requested)
	cancel_button.pressed.connect(_on_close_requested)
	focus_exited.connect(_on_close_requested)
	cancel_button.grab_focus()

func _on_close_requested() -> void:
	profile_delete_cancel.emit()

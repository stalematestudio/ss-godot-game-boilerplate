extends Node

@export var confirmation_dialog_scene: PackedScene = preload("res://utils/confirmation_dialog/confirmation_dialog.tscn")
@onready var confirmation_dialog: ExtendedConfirmationDialog

func confirm_action(action: Callable, message: String = "", confirm: String = "OK") -> void:
	confirmation_dialog = confirmation_dialog_scene.instantiate()
	confirmation_dialog.set_text(message)
	confirmation_dialog.get_ok_button().set_text(confirm)
	confirmation_dialog.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	add_child(confirmation_dialog)
	confirmation_dialog.confirmed.connect(action)
	confirmation_dialog.canceled.connect(confirmation_dialog.queue_free)
	confirmation_dialog.focus_exited.connect(confirmation_dialog.queue_free)
	confirmation_dialog.popup_centered()
	confirmation_dialog.get_cancel_button().grab_focus()
